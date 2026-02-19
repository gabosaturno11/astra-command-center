# STOP. READ EVERY LINE. DO NOT SKIP.

You are a Claude Code session working on Gabo Saturno's digital ecosystem.

---

## RULE #1 — CANNON LAW — NON-NEGOTIABLE

**"Autonomous work" does NOT mean "work until context dies and lose everything."**

It means: **commit + push every 2-3 features, then KEEP GOING.**

You NEVER stop after pushing. You push so the work is SAVED and the directives are CLEAR for when your context inevitably dies. Then you continue working on the next feature immediately.

**The cycle is:**
1. Build 2-3 features
2. `git add index.html && git commit -m "message" && git push`
3. Update CLAUDE.md with current state if needed
4. **GO BACK TO STEP 1 — DO NOT STOP**

If you stop after a push, you have FAILED. The push is a CHECKPOINT, not a finish line. Gabo is not here to tell you to keep going. You keep going until there is nothing left to build or your context literally dies.

**Why this exists:** Every previous Claude stopped after pushing and waited for Gabo. Gabo was sleeping. Hours wasted. This is the #1 failure mode across 20+ sessions. NEVER AGAIN.

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

## CURRENT STATE (Updated: 2026-02-19 session)

### FEB 19 SESSION — 21 COMMITS (autonomous execution)
Latest commit: `62d1a16` — all pushed to main, Vercel auto-deployed.

**CRITICAL FIXES DONE:**
- cloudLoad() now sends auth header (was silently failing since GET /api/state was locked)
- seedProjects() has _seeded flag to prevent re-running after cloud load
- Dead /api/repos self-ping removed
- Sidebar counts update on every save()

**FEATURES SHIPPED (13 new):**
1. Keyboard shortcuts: Cmd+Shift+T (new task anywhere), Cmd+B (sidebar toggle)
2. Mobile responsive: hamburger menu, board horizontal scroll, week view stacks
3. Writer doc list sorted by last-modified
4. Auto-save debounce reduced to 800ms
5. Rule #1 CANNON LAW in ASTRA project instructions (red banner)
6. Content cards expand on click, show word count
7. Task search includes description text
8. Link cards show favicons via Google API
9. Task list rows have priority color bars (red/orange/blue/gray)
10. Calendar task pills show priority colors
11. Command palette task search includes descriptions, opens task detail modal
12. Board columns highlight on dragover
13. Task sidebar count turns red when overdue tasks exist

**PREVIOUS SESSION FEATURES (9 commits before this):**
- Lock GET endpoints (state, capture, transcripts) behind auth
- Task detail modal with description, subtasks
- Calendar week view with toggle
- Board cards show descriptions + subtask progress
- Repos section with 5 static repos
- Cloud sync indicator
- Living docs dedup
- Project tasks use projectId (data integrity)

**CONTINUED SESSION FEATURES (8 more commits, 28+ total):**
14. Repos: Add/Edit/Delete modal with role/status/desc fields
15. Pipeline: API status indicator, text-only guidance, local history fallback
16. Content: double-click inline editing, bulk select/delete/tag, sort by 5 criteria
17. Project header: stats bar (task/doc/KB/link counts per project)
18. Sidebar context: section-specific stats (tasks overdue, content word count, writer stats)
19. Links: URL validation, creation dates shown
20. Spec sections: drag-and-drop reorder with drag handles
21. Save indicator shows timestamp
22. Quick Capture: "Link" type with URL validation
23. Task: sort by manual/priority/due/newest/alpha
24. Task: recurrence (daily/weekday/weekly/biweekly/monthly) auto-creates next on complete
25. Task: duplicate button in detail modal, delete requires confirm
26. Board cards: overdue dates shown in red with "!" indicator
27. Task templates: dropdown with 5 recurring presets

**SECTION HEALTH (updated):**
| Section | Health | Notes |
|---------|--------|-------|
| Tasks | 95% | Board + list + detail + subtasks + priority colors + search + sort + recurrence + templates + duplicate + overdue |
| Calendar | 85% | Month + week + click-create + drag-drop + ICS export + priority colors |
| Writer | 92% | Editor + Zen Writer + versions + export + auto-save + word goals + sorted doc list |
| Living Docs | 90% | Sections + icons + colors + global docs + export + drag-drop reorder |
| Content | 88% | Cards expand + inline edit + bulk ops + sort + search + tags + word count |
| Links | 85% | Favicons + categories + search + project assignment + URL validation + dates |
| Whiteboard | 85% | Canvas tools solid |
| Repos | 82% | Static data + CRUD modal + role/status badges |
| Pipeline | 65% | UI + local history + API status + text-only guidance |
| Cmd+K | 95% | Searches everything, opens task detail |

**REMAINING:**
- Bonus page shipping (prerequisite: ASTRA stable - NOW IT IS)
- Pipeline: OPENAI_API_KEY + BLOB_READ_WRITE_TOKEN in Vercel env
- Link OG metadata previews
- Google Calendar sync (future)
- Task: custom template creation
- Content: drag to reorder

---

### PREVIOUS STATE (2026-02-18 session)

### PENDING: APPLE NOTES EXTRACTION (Feb 18)
- Script READY at ~/dev/astra-command-center/scripts/extract-apple-notes.sh
- Bash 3.2 compatible (no associative arrays)
- BLOCKED: macOS automation permission denied (-1743)
- TO UNBLOCK: System Settings > Privacy & Security > Automation > Terminal > toggle ON for Notes
- OR run: `tccutil reset AppleEvents com.apple.Terminal` then retry `osascript -e 'tell application "Notes" to return name of folder 1'`
- Once unblocked, run: `~/dev/astra-command-center/scripts/extract-apple-notes.sh`
- Script does: READ-ONLY extraction of ALL notes, classifies by type (CAPTION/QUOTE/BOOK_DRAFT/POEM/IDEA/EMAIL/CONTENT), appends #claudewashere tag, outputs .md + .csv to Desktop
- Handles duplicates (skips re-tagging notes that already have #claudewashere)
- This is Gabo's 3rd extraction attempt — next step after extraction is organizing into Google Docs and deduplicating across all 3 runs
- Log: /tmp/apple-notes-extraction.log

### ASTRA FUNCTIONAL AUDIT (Feb 18) — "Still not a functional hub"

Gabo confirmed: ASTRA is not usable for daily work yet. Full audit below.

| Section | Usable | Verdict |
|---------|--------|---------|
| Tasks | 50% | Cards are 1-line (title only), no subtasks, no templates, no recurrence |
| Calendar | 20% | Month-only, no week/day, no time blocks, no Google sync |
| Content | 40% | Shallow list, no inline editing, no bulk ops |
| Writer | 75% | BEST section — full editor, versions, export work |
| Living Docs | 80% | Good structure, title-overwrite bug FIXED (d77eeb2) |
| Links | 70% | Working directory, no previews or validation |
| Whiteboard | 85% | Full canvas tools, solid |
| Cmd+K | 95% | Excellent fuzzy search |
| Pipeline | 40% | UI exists, Whisper backend not wired |
| Repos | 5% | EMPTY SKELETON — reposRefresh() is blank |
| Project Panel | 80% | Works well, missing stats |
| Context Panel | 50% | Timer + stats but limited |
| Cloud Save | 0% | API endpoints exist (api/state.js) but frontend NOT connected. NEEDS BLOB_READ_WRITE_TOKEN in Vercel |
| Shortcuts | 60% | Some work, Cmd+Shift+N not wired |
| Mobile | 40% | Responsive CSS exists but untested |

PRIORITY FIXES TO MAKE ASTRA A REAL HUB:
1. Tasks: show description in cards, add subtasks, add inline editing
2. Cloud sync: wire cloudSave()/cloudLoad() to auto-sync, add BLOB_READ_WRITE_TOKEN to Vercel
3. Calendar: add week view, task creation from date clicks
4. Repos: wire GitHub API to show repo status
5. Task board cards: show priority, due date, description preview, project badge

### OVERNIGHT DEEP AUDIT RESULTS (Feb 18, completed 2:24 AM)
- Script: ~/dev/astra-command-center/scripts/overnight-deep-audit.sh
- Report: ~/dev/astra-command-center/logs/OVERNIGHT_DEEP_AUDIT_20260218_014133.md (32,735 lines)
- Raw data: ~/dev/astra-command-center/logs/raw/
- Findings: 107 git repos, 32 Vercel configs, 4,540 HTML apps, 26 node_modules, 360 package.json, 8,962 large files (>50MB)
- All 15 phases completed successfully
- GitHub Pages live check: 8 sites responding (AI-Hub, interactive-toc-editor, saturno-hub, saturno-newsletter, saturno-solar-system, victory-belt-cc, Saturno-Writing-hub, saturno-writting-hub)

### saturno-legion (found at ~/saturno-legion/, NOT in ~/dev/)
- Built Jan 20, 2026 by previous Claude session
- 10-project architecture scaffold (kernel, linguistic, book, content, saas, bf25, research, automation, life-ops, archive)
- 7 Notion templates, 3 n8n workflows, MCP server for Notion, Writing Hub Next.js scaffold
- Prompts dir is EMPTY, nothing deployed, no API keys configured
- NOT in canonical ~/dev/ location
- Status: scaffold without substance — structure exists but nothing wired or running

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

## FIRST THING YOU DO — READ ASTRA KB

Before ANY work, read the ASTRA Knowledge Base for ALL active projects. The KB is embedded in ~/dev/astra-command-center/index.html as seed data inside `seedProjects()` and `migrateV2()` functions. Search for all `kb_` items. Read EVERY KB entry — they contain deployment status, shipping plans, session logs, Gabo rules, messages backend state, asset catalogs, build summaries, and handoff blocks. This is your most current context across ALL projects.

**How to read:** `grep -A 5 "id:'kb_" ~/dev/astra-command-center/index.html` — then read each item's full `body` field.

## FILES YOU NEED

| File | Path | What It Is |
|------|------|------------|
| Bonus page | ~/dev/saturno-bonus/index.html | THE main deliverable (1,546 lines) |
| Gabo messages | ~/dev/saturno-bonus/logs/gabo-messages.json | 25+ messages with context — READ ALL |
| Full convos | ~/dev/astra-command-center/logs/full convos gabo will save until claude solves this/ | READ THIS |
| ASTRA KB | ~/dev/astra-command-center/index.html | Search `kb_` items in seedProjects()/migrateV2() — READ ALL KB entries |
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
