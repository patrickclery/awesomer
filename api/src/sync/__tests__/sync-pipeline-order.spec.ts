/**
 * MH-C: Pipeline ordering invariant test.
 *
 * Strategy: Read sync.service.ts as text at runtime and assert character-position
 * ordering. This avoids mocking child_process/git/rsync while keeping the
 * invariant honest — future refactors that break the order will also break
 * this test.
 *
 * Requirement (MH-C from 24-01-PLAN.md):
 *   In deployStaticSite():
 *     rsync call  <  this.generateMarkdown()  <  git add  <  git commit
 *
 *   In runDailyPipeline():
 *     this.generateMarkdown() must NOT appear as a standalone call
 *     (it is only called from within deployStaticSite(), which is called
 *     from runDailyPipeline()).
 */

import { readFileSync } from 'fs';
import { resolve } from 'path';

const srcPath = resolve(process.cwd(), 'src/sync/sync.service.ts');
const src = readFileSync(srcPath, 'utf-8');

// ---------------------------------------------------------------------------
// Helpers: extract the body of a top-level async method by name
// ---------------------------------------------------------------------------

function extractMethodBody(source: string, methodName: string): string {
  // Match "async methodName(" at start of a line (after optional whitespace)
  const startPattern = new RegExp(`async\\s+${methodName}\\s*\\(`);
  const startMatch = startPattern.exec(source);
  if (!startMatch) {
    throw new Error(`Method ${methodName} not found in sync.service.ts`);
  }

  // Walk forward counting braces to find the end of the method body
  let depth = 0;
  let inBody = false;
  let end = startMatch.index;

  for (let i = startMatch.index; i < source.length; i++) {
    const ch = source[i];
    if (ch === '{') {
      depth++;
      inBody = true;
    } else if (ch === '}') {
      depth--;
      if (inBody && depth === 0) {
        end = i;
        break;
      }
    }
  }

  return source.slice(startMatch.index, end + 1);
}

// ---------------------------------------------------------------------------
// deployStaticSite ordering
// ---------------------------------------------------------------------------

describe('MH-C: deployStaticSite() pipeline order', () => {
  let deployBody: string;

  beforeAll(() => {
    deployBody = extractMethodBody(src, 'deployStaticSite');
  });

  it('deployStaticSite() calls rsync', () => {
    expect(deployBody).toMatch(/rsync/);
  });

  it('deployStaticSite() calls this.generateMarkdown()', () => {
    expect(deployBody).toMatch(/this\.generateMarkdown\(/);
  });

  it('deployStaticSite() calls git add', () => {
    expect(deployBody).toMatch(/git add/);
  });

  it('deployStaticSite() calls git commit', () => {
    expect(deployBody).toMatch(/git commit/);
  });

  it('rsync appears BEFORE this.generateMarkdown() in deployStaticSite()', () => {
    const rsyncIdx = deployBody.indexOf('rsync');
    const markdownIdx = deployBody.indexOf('this.generateMarkdown(');
    expect(rsyncIdx).toBeGreaterThan(-1);
    expect(markdownIdx).toBeGreaterThan(-1);
    expect(rsyncIdx).toBeLessThan(markdownIdx);
  });

  it('this.generateMarkdown() appears BEFORE git add in deployStaticSite()', () => {
    const markdownIdx = deployBody.indexOf('this.generateMarkdown(');
    const gitAddIdx = deployBody.indexOf('git add');
    expect(markdownIdx).toBeGreaterThan(-1);
    expect(gitAddIdx).toBeGreaterThan(-1);
    expect(markdownIdx).toBeLessThan(gitAddIdx);
  });

  it('this.generateMarkdown() appears BEFORE git commit in deployStaticSite()', () => {
    const markdownIdx = deployBody.indexOf('this.generateMarkdown(');
    const gitCommitIdx = deployBody.indexOf('git commit');
    expect(markdownIdx).toBeGreaterThan(-1);
    expect(gitCommitIdx).toBeGreaterThan(-1);
    expect(markdownIdx).toBeLessThan(gitCommitIdx);
  });
});

// ---------------------------------------------------------------------------
// runDailyPipeline: generateMarkdown must NOT appear as a standalone call
// ---------------------------------------------------------------------------

describe('MH-C: runDailyPipeline() does not call generateMarkdown() standalone', () => {
  let pipelineBody: string;

  beforeAll(() => {
    pipelineBody = extractMethodBody(src, 'runDailyPipeline');
  });

  it('runDailyPipeline() body does not contain a direct this.generateMarkdown() call', () => {
    // The call MUST NOT appear directly in runDailyPipeline — it should only
    // run inside deployStaticSite() which runs after rsync.
    // Note: this.deployStaticSite() is OK to appear here; the check is that
    // generateMarkdown is not also explicitly called here.
    expect(pipelineBody).not.toMatch(/await\s+this\.generateMarkdown\s*\(/);
  });
});
