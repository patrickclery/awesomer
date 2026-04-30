/**
 * MH-A: MarkdownService is @Injectable() and registered in SyncModule providers (not exports).
 * MH-B: SyncService.generateMarkdown() delegates to MarkdownService.generateAll().
 */

import { readFileSync } from 'fs';
import { resolve } from 'path';
import { jest } from '@jest/globals';
import { SyncService } from '../sync.service.js';
import { PrismaService } from '../../prisma/prisma.service.js';
import { MarkdownService } from '../markdown.service.js';

// ---------------------------------------------------------------------------
// MH-A: Source-text assertions on sync.module.ts
// ---------------------------------------------------------------------------

const moduleSrc = readFileSync(resolve(process.cwd(), 'src/sync/sync.module.ts'), 'utf-8');
const markdownSrc = readFileSync(resolve(process.cwd(), 'src/sync/markdown.service.ts'), 'utf-8');

describe('MH-A: SyncModule wiring', () => {
  it('sync.module.ts imports MarkdownService', () => {
    expect(moduleSrc).toMatch(/import\s*\{[^}]*MarkdownService[^}]*\}/);
  });

  it('sync.module.ts lists MarkdownService in providers array', () => {
    // Find the providers array content
    const providersMatch = /providers:\s*\[([^\]]+)\]/.exec(moduleSrc);
    expect(providersMatch).not.toBeNull();
    expect(providersMatch![1]).toContain('MarkdownService');
  });

  it('sync.module.ts does NOT list MarkdownService in exports array', () => {
    const exportsMatch = /exports:\s*\[([^\]]+)\]/.exec(moduleSrc);
    // If there is an exports array, MarkdownService must not be in it
    if (exportsMatch) {
      expect(exportsMatch[1]).not.toContain('MarkdownService');
    }
    // If no exports array, requirement is satisfied by default
  });

  it('markdown.service.ts has @Injectable() decorator', () => {
    expect(markdownSrc).toMatch(/@Injectable\(\)/);
  });
});

// ---------------------------------------------------------------------------
// MH-B: SyncService.generateMarkdown() delegates to MarkdownService.generateAll()
// ---------------------------------------------------------------------------

describe('MH-B: SyncService.generateMarkdown() delegates to MarkdownService', () => {
  it('calls markdownService.generateAll() when generateMarkdown() is invoked', async () => {
    // Build a minimal mock PrismaService (MarkdownService won't be called, but SyncService
    // constructor requires it for type-safety)
    const mockPrisma = {} as unknown as PrismaService;

    // Build a MarkdownService stub with a spy on generateAll
    const generateAllSpy = jest.fn().mockResolvedValue(['README.md']);

    const mockMarkdown = {
      generateAll: generateAllSpy,
    } as unknown as MarkdownService;

    // Build a SyncService with all other deps stubbed out
    const mockGithub = {} as never;
    const mockBackfill = {} as never;
    const mockStaticData = {} as never;

    const service = new SyncService(
      mockPrisma,
      mockGithub,
      mockBackfill,
      mockStaticData,
      mockMarkdown,
    );

    // Call generateMarkdown and verify delegation
    await service.generateMarkdown();

    expect(generateAllSpy).toHaveBeenCalledTimes(1);
  });

  it('generateMarkdown() passes through the outputDir argument to generateAll()', async () => {
    const mockPrisma = {} as unknown as PrismaService;
    const generateAllSpy = jest.fn().mockResolvedValue([]);
    const mockMarkdown = { generateAll: generateAllSpy } as unknown as MarkdownService;

    const service = new SyncService(
      mockPrisma,
      {} as never,
      {} as never,
      {} as never,
      mockMarkdown,
    );

    const testDir = '/tmp/test-output-dir';
    await service.generateMarkdown(testDir);

    expect(generateAllSpy).toHaveBeenCalledWith(testDir);
  });
});
