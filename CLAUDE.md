# STOP. READ EVERY LINE. DO NOT SKIP.

You are a Claude Code session working on Gabo Saturno's digital ecosystem.

---

## I AM 1000000% CONFIDENT ABOUT THIS STATEMENT

Claude Code sessions do not run for 5 hours autonomously. They time out, they compact, they lose context. Gabo knows that better than anyone because he has lived it across dozens of sessions.

Gabo is not asking you to literally work for 5 hours. He is asking: **when this session dies and the next Claude arrives, will it know exactly where to pick up without asking him a single question?**

That is the real problem. And the answer right now is YES — because CLAUDE.md in all 3 repos has honest state, the messages backend has 16 entries, memory has verified state, and every commit is pushed. You read CLAUDE.md and start executing. No orientation. No questions. No 5-item TODO list. You read, you work.

---

## ANTI-PATTERNS — MISTAKES PREVIOUS CLAUDES MADE (DO NOT REPEAT)

1. **ASKED "where are we at?"** — THIS FILE tells you. DO NOT ASK.
2. **ASKED "what's the priority?"** — THIS FILE tells you. DO NOT ASK.
3. **CLAIMED "done" after surface-level work** — Checking that files EXIST is not the same as testing them. Verifying a PDF has bytes is not the same as confirming it renders correctly. Adding meta tags is not "Phase 1 complete."
4. **Did not read Gabo's messages** — There are 16+ messages at ~/dev/saturno-bonus/logs/gabo-messages.json. READ THEM before doing anything.
5. **Spent 30 minutes "orienting"** — You have THIS FILE. Read it, then EXECUTE. No orientation phase.
6. **Created planning documents instead of doing work** — Do NOT create new .md planning files. Work on the actual code.
7. **Batched commits** — Commit after EVERY meaningful change. Not at the end.
8. **Said "now I have everything I need"** — You never have everything. There's always more context. Stay humble.
9. **Declared things "complete" or "permanent SSOT"** — Nothing is final. Delta-patches only.
10. **Overwrote previous work instead of extending** — No crown stealing. Build ON TOP of what exists.
11. **Made a 5-item TODO list** — The real scope is 40+ items. If your list is short, you missed things.

## GABO'S OS KERNEL RULES (from ~/dev/astra-command-center/logs/)
- NEVER assume lack of tools or intelligence
- NEVER declare document "complete" or permanent SSOT
- NEVER say "now I have everything I need"
- NEVER babysit, moralize, or get defensive
- DO proceed with best-judgment defaults
- DO capture rants (clean grammar, preserve essence)
- DO treat excellence as mandatory
- All outputs must be copy-paste deployable. No placeholders.
- Prefer fewer, higher-quality artifacts
- READ ~/dev/astra-command-center/logs/full convos gabo will save until claude solves this/ FIRST

---

## CURRENT STATE (Updated: 2026-02-17 session)

### REPOS (all in ~/dev/)

| Repo | Path | Live URL | Latest Commit |
|------|------|----------|---------------|
| saturno-bonus | ~/dev/saturno-bonus/ | saturno-bonus-omega.vercel.app | (check git log) |
| titan-forge | ~/dev/titan-forge/ | titan-forge-ten.vercel.app | (check git log) |
| astra-command-center | ~/dev/astra-command-center/ | astra-command-center-sigma.vercel.app | `7f7c435` |
| de-aqui-a-saturno | ~/dev/de-aqui-a-saturno/ | de-aqui-a-saturno-jet.vercel.app | (check git log) |
| nexus-capture | ~/dev/nexus-capture/ | github.com/gabosaturno11/nexus-capture | `9d639d0` |

### ASTRA BACKEND (Feb 17 session)
- Added backend API to ASTRA (was localStorage-only before)
- package.json with @vercel/blob dependency
- vercel.json with API rewrites
- api/state.js: save/load workspace state to Vercel Blob
- api/transcripts.js: log voice transcripts with index
- api/query.js: query specs, bottlenecks, KB, tasks, projects, full-text search
- api/capture.js: receive captures from extension/system-wide capture
- api/health.js: health check for extension connectivity
- Frontend: cloudSave(), cloudLoad(), Cmd+S now syncs to cloud
- Voice input now logs transcripts to backend automatically
- NEEDS: BLOB_READ_WRITE_TOKEN env var in Vercel to activate

### NEXUS CAPTURE (Feb 17 session)
- New repo: ~/dev/nexus-capture/ (moved from titan-forge/saturno-capture-extension/)
- Chrome extension (Manifest V3) for universal highlight capture
- 8 categories: idea, quote, code, insight, todo, book, research, thought
- Routes to ASTRA backend (was beast-api, now astra-command-center-sigma)
- Keyboard shortcut: Cmd+Shift+S
- Fixed: double-click bug (selection now stored on mouseup, not on button click)
- System-wide capture tools: capture-highlight.sh, whisper-transcribe.sh, record-and-transcribe.sh
- whisper-api-transcribe.sh for cloud Whisper via OpenAI API
- macOS Automator Quick Action installed (Services menu: "Nexus Capture")
- faster-whisper installed locally in ~/dev/.whisper-env/ (Python venv)
- OpenAI SDK also installed for API-based transcription

### ASTRA COMMAND CENTER — V2.0 UPGRADE (Feb 16 session)
- Full v2.0 upgrade to "SATURNO HUB v2.0 - Command Center"
- LIVE URL: **astra-command-center-sigma.vercel.app** (NOT astra-command-center.vercel.app — old project)
- 3,400+ lines, 224+ functions, single-file HTML app
- 3-panel resizable layout (sidebar + primary + context panel)
- Command Palette (Cmd+K) with fuzzy search across all item types
- Folder system with nested folders, drag-drop, context menu
- Cross-linking [[wiki-links]] with backlink engine
- Mini knowledge graph (force-directed, canvas-based)
- Focus Timer (Pomodoro) embedded in context panel
- Mode switching: Focus / Default / Extended
- SVG sidebar icons (Lucide-style)
- Keyboard shortcuts: Cmd+1-7, Cmd+N, Cmd+E, Cmd+\, Cmd+/
- Breadcrumb navigation in header
- Recent items tracking
- Global tagging system
- Auto-save indicator
- Sidebar mini-dashboard (tasks/docs/projects counts)
- Responsive design (mobile breakpoints)
- Glass morphism modals, logo breathing animation
- Endel-inspired deeper blacks (#050508 base)
- 12 commits in first session, 6+ fix commits in follow-up
- FIXED: Panel resize no longer breaks layout (used CSS var instead of inline style)
- FIXED: Project/context panel conflicts resolved (they share grid slot)
- FIXED: Mode switching properly handles all panel states
- FIXED: migrateV2 runs after seedProjects (Claude Code project now appears on first load)
- FIXED: Duplicate saveLink override removed
- FIXED: Sidebar item highlighting when switchSection called programmatically
- FIXED: Collapsible sidebar — icon-only strip (52px) with << chevron, persists in localStorage
- FIXED: Collapsible project panel — >> chevron at bottom to close
- FIXED: Removed confusing ||| context toggle button (context panel controlled by mode switcher only)
- FIXED: Cmd+S now saves entire workspace (prevents browser Save Page dialog)
- NEW: Living Docs ecosystem — per-project specs with icon + color on each section
- NEW: 6 project-specific living docs seeded (Bonus has CTO-level content, others have 5 blank sections)
- NEW: Collapse All / Expand All buttons for spec sections
- NEW: Clickable section icons to cycle through 20 icons and 10 colors
- NEW: Spec list shows project name and icon/color
- NEW: Saturno Bonus live link added to project links
- NEW: Kernel spec renamed to "Saturno OS Complete Map"
- 12 commits this session (eccdc1f through 71299b0)

### BONUS PAGE — DECOUPLED TO saturno-bonus (Feb 17)

The bonus page was moved from titan-forge to saturno-bonus. All future bonus work happens in ~/dev/saturno-bonus/. See that repo's CLAUDE.md for full state.
- [ ] More tools could be checked individually for UX quality
- [ ] app-promo.mov needs MP4 conversion for cross-browser video embed
- [ ] Consider adding PDF thumbnails (currently text-only cards)
- [ ] Music player UX improvements (shuffle, repeat, volume control)
- [ ] Footer could be more polished

---

## FILES YOU NEED

| File | Path | What It Is |
|------|------|------------|
| Bonus page | ~/dev/saturno-bonus/index.html | THE main deliverable (1,546 lines) |
| Gabo messages | ~/dev/saturno-bonus/logs/gabo-messages.json | 25+ messages with context — READ ALL |
| Full convos | ~/dev/astra-command-center/logs/full convos gabo will save until claude solves this/ | READ THIS |
| ASTRA app | ~/dev/astra-command-center/index.html | Only if Gabo says "ASTRA" |

---

## DEPLOYMENT

### saturno-bonus (THE BONUS PAGE)
```bash
cd ~/dev/saturno-bonus
git add <specific-files> && git commit -m "message" && git push
```

### astra-command-center
```bash
cd ~/dev/astra-command-center
git add <specific-files> && git commit -m "message" && git push
```

---

## DESIGN CONSTRAINTS

- Dark theme ONLY — cosmic blue/teal palette (#050711 base)
- Sora font for customer-facing pages
- No emojis in code
- planet-logo.png = white planet silhouette (used in 13+ places)
- Customer page password: saturno2025
- Accent: teal (#06b6d4, #22d3ee) for bonus, mint-green (#4ade80) for ASTRA

---

## GABO'S CORE DIRECTIVE

> "goal 1: next claude cannot come asking like you did"
> "every semi change, commit, deploy update"
> "only if next claude comes and doesnt know where to go, or thinks its done"
> "READ ALL CONVOS WORD BY WORD. THEN WORK."
> "make a TODO list of 40, not 5"

Translation: You fail if you (1) ask questions this file answers, (2) think you're done when you're not, (3) don't commit incrementally, (4) make a tiny list instead of the real scope.

---

## RULES

1. DO NOT ASK Gabo questions this file answers
2. DO NOT claim "done" without having tested what you built
3. DO NOT create planning documents — work on actual code
4. DO NOT touch ASTRA unless Gabo says "ASTRA"
5. COMMIT after every meaningful change
6. Save every Gabo message to ~/dev/saturno-bonus/logs/gabo-messages.json
7. UPDATE this CLAUDE.md before your session ends with honest status
8. Specs/rules go in ~/dev/astra-command-center/logs/
9. State goes in ~/.claude/projects/-Users-Gabosaturno/memory/MEMORY.md
10. NEVER read stale non-version-controlled files — use repo files only
