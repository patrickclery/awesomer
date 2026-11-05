#!/usr/bin/env node
/**
 * Read-only check that origin/main is an exact, fully linked mirror of the
 * markdown on origin/gh-pages (D-13, D-14).
 *
 * Run from the checkout root, after `git fetch origin main gh-pages`:
 *   node api/scripts/verify-markdown-mirror.mjs
 *
 * Reads the local remote-tracking refs and does not fetch. Writes only to its
 * own temp directory, which it removes. Prints a JSON report.
 * Exit 0: no violations. Exit 1: violations. Exit 2: the check could not run.
 */

import { execFileSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, posix } from 'node:path';

const MAIN = 'origin/main';
const GH_PAGES = 'origin/gh-pages';
const TREES = ['l', 'r'];

const RELATIVE_LINK = /\]\(((?:\.\.\/)?[lr]\/[^)\s#?]+\.md|\.\.\/README\.md)(?:#[^)\s]*)?\)/g;
const LIVE_LINK = /https:\/\/patrickclery\.com\/awesomer\/(l|r)\/([^/)\s"'#?]+)\//g;

function git(...args) {
  return execFileSync('git', args, { encoding: 'utf8', maxBuffer: 1024 * 1024 * 1024, stdio: ['ignore', 'pipe', 'pipe'] });
}

/** Entries of a tree as { type, sha, name }, where name is relative to the tree. */
function listTree(ref, tree) {
  return git('ls-tree', '-z', ref, `${tree}/`)
    .split('\0')
    .filter(Boolean)
    .map((line) => {
      const [meta, path] = line.split('\t');
      const [, type, sha] = meta.split(' ');
      return { type, sha, name: path.slice(tree.length + 1) };
    });
}

function listPaths(ref) {
  return git('ls-tree', '-r', '-z', '--name-only', ref).split('\0').filter(Boolean);
}

function blobSha(ref, path) {
  try {
    return git('rev-parse', '--verify', '--quiet', `${ref}:${path}`).trim();
  } catch {
    return null;
  }
}

function markdownBlobs(entries) {
  return new Map(entries.filter((e) => e.type === 'blob' && e.name.endsWith('.md')).map((e) => [e.name, e.sha]));
}

function compareTree(tree) {
  const onMain = markdownBlobs(listTree(MAIN, tree));
  const onPages = markdownBlobs(listTree(GH_PAGES, tree));
  const names = (from, predicate) => [...from].filter(predicate).length;
  return {
    [`${tree}_stale_on_main`]: names(onMain.keys(), (name) => !onPages.has(name)),
    [`${tree}_missing_on_main`]: names(onPages.keys(), (name) => !onMain.has(name)),
    [`${tree}_content_differs`]: names(onMain.keys(), (name) => onPages.has(name) && onPages.get(name) !== onMain.get(name)),
  };
}

function checkLinks(mainPaths) {
  const onMain = new Set(mainPaths);
  const routes = {};
  for (const tree of TREES) {
    routes[tree] = new Set(listTree(GH_PAGES, tree).filter((e) => e.type === 'tree').map((e) => e.name));
  }
  const pages = mainPaths.filter((path) => path === 'README.md' || (/^[lr]\//.test(path) && path.endsWith('.md')));
  if (pages.length === 0) return { dead_relative_links: 0, dead_live_links: 0, pages_with_dead_live_links: 0 };

  const dir = mkdtempSync(join(tmpdir(), 'verify-markdown-mirror-'));
  try {
    const roots = ['README.md', ...TREES].filter((root) => onMain.has(root) || mainPaths.some((p) => p.startsWith(`${root}/`)));
    const archive = join(dir, 'main.tar');
    git('archive', '--format=tar', '-o', archive, MAIN, ...roots);
    execFileSync('tar', ['-xf', archive, '-C', dir]);

    let deadRelative = 0;
    let deadLive = 0;
    let pagesWithDeadLive = 0;
    for (const page of pages) {
      const text = readFileSync(join(dir, page), 'utf8');
      for (const [, target] of text.matchAll(RELATIVE_LINK)) {
        if (!onMain.has(posix.normalize(posix.join(posix.dirname(page), target)))) deadRelative++;
      }
      let deadHere = 0;
      for (const [, tree, slug] of text.matchAll(LIVE_LINK)) {
        if (!routes[tree].has(slug)) deadHere++;
      }
      deadLive += deadHere;
      if (deadHere > 0) pagesWithDeadLive++;
    }
    return { dead_relative_links: deadRelative, dead_live_links: deadLive, pages_with_dead_live_links: pagesWithDeadLive };
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
}

function main() {
  git('rev-parse', '--verify', '--quiet', `${MAIN}^{commit}`);
  git('rev-parse', '--verify', '--quiet', `${GH_PAGES}^{commit}`);

  const mainPaths = listPaths(MAIN);
  const counts = {
    ...compareTree('l'),
    ...compareTree('r'),
    readme_differs: blobSha(MAIN, 'README.md') === blobSha(GH_PAGES, 'README.md') ? 0 : 1,
    non_md_on_main: mainPaths.filter((path) => /^[lr]\//.test(path) && !path.endsWith('.md')).length,
    ...checkLinks(mainPaths),
  };
  // pages_with_dead_live_links restates dead_live_links per page, so it is not summed.
  const violations = Object.entries(counts)
    .filter(([key]) => key !== 'pages_with_dead_live_links')
    .reduce((sum, [, value]) => sum + value, 0);

  console.log(JSON.stringify({ ...counts, violations }, null, 2));
  return violations === 0 ? 0 : 1;
}

try {
  process.exitCode = main();
} catch (error) {
  console.error(`verify-markdown-mirror: could not run: ${error.message}`);
  process.exitCode = 2;
}
