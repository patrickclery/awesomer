/**
 * Offline README parser probe.
 *
 * Runs one parser type over a local file through the compiled build (the same
 * getParser() factory both sync import paths call) and prints a single JSON
 * line with the ParseSummary counts. It never touches the database, the
 * network or the environment, so it is safe to run against any downloaded
 * upstream README to catch format drift before an import.
 *
 * IMPORTANT: Imports from dist/ (compiled output), so it probes exactly what
 * the nightly sync runs.
 *
 * Prerequisites:
 *   cd api && npx nest build   # must compile before running
 *
 * Usage:
 *   cd api
 *   node scripts/probe-readme-parser.js <parserType> <file> [--assert-clean] [--min-items N]
 *
 *   --assert-clean   fail when any description carries badge markup, any
 *                    category name keeps a section number, any category is
 *                    empty, or no items were parsed
 *   --min-items N    fail when fewer than N items were parsed
 *
 * Exit codes:
 *   0  summary printed, all requested assertions held
 *   1  an assertion failed (the summary line is still printed)
 *   2  usage error or unreadable file
 */

import { readFileSync } from 'node:fs';
import { parseArgs } from 'node:util';
import { getParser } from '../dist/src/sync/parsers/parser-factory.js';
import { summarizeParseResult } from '../dist/src/sync/parsers/parse-summary.js';

const USAGE = 'Usage: node scripts/probe-readme-parser.js <parserType> <file> [--assert-clean] [--min-items N]';

function usage(message) {
  if (message) console.error(message);
  console.error(USAGE);
  process.exit(2);
}

let args;
try {
  args = parseArgs({
    allowPositionals: true,
    options: {
      'assert-clean': { type: 'boolean', default: false },
      'min-items': { type: 'string' },
    },
  });
} catch (err) {
  usage(err.message);
}

const [parserType, file] = args.positionals;
if (!parserType || !file || args.positionals.length > 2) usage();

let minItems;
if (args.values['min-items'] !== undefined) {
  minItems = Number(args.values['min-items']);
  if (!Number.isInteger(minItems) || minItems < 0) usage(`Invalid --min-items: ${args.values['min-items']}`);
}

let content;
try {
  content = readFileSync(file, 'utf8');
} catch (err) {
  usage(`Cannot read ${file}: ${err.message}`);
}

const summary = summarizeParseResult(getParser(parserType).parse(content));
console.log(JSON.stringify({ parserType, ...summary }));

const failures = [];
if (args.values['assert-clean']) {
  if (summary.badgeDescriptions > 0) failures.push(`badgeDescriptions=${summary.badgeDescriptions}`);
  if (summary.numberedCategories > 0) failures.push(`numberedCategories=${summary.numberedCategories}`);
  if (summary.emptyCategories > 0) failures.push(`emptyCategories=${summary.emptyCategories}`);
  if (summary.items === 0) failures.push('items=0');
}
if (minItems !== undefined && summary.items < minItems) failures.push(`items=${summary.items} < ${minItems}`);

if (failures.length > 0) {
  console.error(`Probe assertions failed: ${failures.join(', ')}`);
  process.exit(1);
}
