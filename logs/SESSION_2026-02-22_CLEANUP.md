# Session Log — Feb 22, 2026

## OneDrive Git Sync Fix (Other Claude Session)

The madness is ended. Fixes across all 5 repositories:

### sm-app-copy-v1
- Deleted `public/img/favicon (1).ico` — OneDrive conflict duplicate that got committed
- Updated `.gitignore` with OneDrive sync protection patterns

### titan-forge
- Untracked 36 `.mp3` files from git that were committed before `.gitignore` rule existed (stay on disk locally, won't bloat repo)
- Updated `.gitignore` with OneDrive sync protection patterns

### VB-COMMAND-CENTER
- Created `.gitignore` from scratch — repo had zero protection
- Includes standard exclusions + OneDrive sync protection patterns

### AI-Hub
- Updated `.gitignore` with OneDrive sync protection patterns

### saturno-linguistic-matrix
- Updated `.gitignore` with OneDrive sync protection patterns

### What the OneDrive protection blocks
Every repo now ignores:
- `desktop.ini` — Windows/OneDrive folder config files
- `~$*` — Office temp files OneDrive loves to sync
- `*.tmp` — temp files
- `*- Copy*` — OneDrive's "resolve conflict" copies
- `* (*).*` — OneDrive's `filename (1).ext` duplicate pattern

All changes pushed to `claude/cleanup-git-onedrive-sync-ucqWu` on each repo, ready for PR review. No cross-repo mirroring or `.git` corruption found — repos are structurally clean.

---

## Dropbox Cleanup Plan (Pending Gabo's Go)

### Target structure (folder name TBD by Gabo):
```
Dropbox/
  [BOOK FOLDER NAME TBD]/
    01_submission/
    02_toc/
    03_writing/
    04_visual_references/
    05_frameworks/
    06_vb_guidelines/
    07_media/
  _ARCHIVE/              (everything else buried)
```

### Source material (the 3 gold sources):
1. iCloud > VB SPRINT — 17 files, the best stuff (Premium Submission, Full Submission PDF, VB Guidelines, frameworks)
2. Downloads > _ORGANIZED/aoc-book — submission pack + FINAL SUBMISSION folder (.0.md gold file, Physical Intelligence, m4a audio, FINAL TOC)
3. iCloud > 01_AOC_BOOK/08_existing-projects — Exercise Taxonomy

### Rules:
- NOT mirroring anything to OneDrive or victory-belt-cc
- NOT generating new content
- Downloads stays untouched (backup)
- Waiting for Gabo to confirm folder name before moving anything

---

## AOC PDF Generation (Failed — Archived)

Generated 4 PDFs via WeasyPrint. Gabo rejected all:
- Too colorful
- Content Inventory had unreliable data (conflicting sources across Perplexity spaces)
- More noise than signal
- PDFs still on Desktop/AOC_BOOK_MATERIALS/ but are NOT canonical

### Anti-pattern logged:
Do NOT fabricate completion percentages or word counts from scattered, conflicting AI conversation dumps. If the data doesn't exist in one reliable place, say so — don't guess.
