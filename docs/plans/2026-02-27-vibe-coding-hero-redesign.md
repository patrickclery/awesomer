# Vibe Coding Hero Redesign

**Date:** 2026-02-27
**Status:** Approved

## Overview

Replace the "linux hacker boot sequence" block on the homepage with a meta joke: the section looks exactly like a Claude Code terminal session that built the site via vibe coding. Breaking the fourth wall — awesomer was built by an AI, and the UI says so.

## Design

### Top Bar (Claude Code Status Line)

Two-row bar mimicking Claude Code's actual prompt UI:

**Row 1:**
```
 ~/awesomer   git ⌐main (~5 ?1) ●    ⊙ 47,018 (69%)
```

**Row 2:**
```
►► bypass permissions on  (shift+tab to cycle)
```

**Colors (from Claude Code UI, not the green matrix theme):**
- Container background: dark navy (`#1a1b2e`)
- `~/awesomer` segment: orange pill with powerline arrow (`#c96a2b` background, white text)
- `git ⌐main (~5 ?1) ●` segment: medium-dark blue-gray
- `⊙ 47,018 (69%)` — context meter, slightly used up
- `►► bypass permissions on` in salmon/coral red
- `(shift+tab to cycle)` in muted gray

The 69% context joke: this much context was consumed vibe-coding the site.

### Command Input

```
> /execute-plan build-trending-repo-rankings-from-awesome-lists.md█
```

- `>` in muted gray
- `/execute-plan` in orange (matching the path segment color)
- filename in light foreground
- `█` blinking cursor

Same dark-navy background, flush below the top bar — one continuous Claude Code panel.

### Task List

```
● TodoWrite

  ✓ Fetch star snapshots from GitHub API
  ✓ Parse awesome list markdown → extract repos
  ✓ Compute trending deltas (7d / 30d / 90d)
  ✓ Render static site output
```

- `● TodoWrite` header in muted text (Claude Code tool call label style)
- `✓` checkmarks in green
- Task text in light foreground
- All 4 marked complete

## What Changes

Replace `BOOT_SEQUENCE` constant and the boot sequence JSX block in `web/src/app/page.tsx` with a new `<VibeCodePanel>` component (or inline JSX).

The green matrix aesthetic is intentionally broken for this block — it should look like Claude Code dropped into the page.

## Files to Touch

- `web/src/app/page.tsx` — replace boot sequence block
- `web/src/app/globals.css` — add any needed styles (navy bg, orange segment, powerline arrow shape)
