# ASTRA COMMAND CENTER — CLAUDE.md
## Last Updated: March 6, 2026

---

## C2 HANDOFF — MARCH 6 AUDIT SESSION

C1 completed a FULL ecosystem audit. 15 commits pushed. Everything deployed.

### WHAT C1 DID (March 6)
1. Deep-read ALL 59 KB entries, 37 Desktop HTMLs, 339-line Nexus background.js
2. Tested every API endpoint with real curl requests
3. Checked all Vercel env vars for 12 projects
4. Found 46 Chrome extensions across 7 profiles
5. Analyzed 675+ Gabo messages (top wants, frustrations, unaddressed requests)
6. Created FULL_ECOSYSTEM_AUDIT_MARCH6.md (660+ lines, 12 sections, 50 improvements)
7. Fixed 15 bugs in ASTRA index.html (see below)
8. All pushed and deployed to production

### WHAT C2 SHOULD DO NEXT
1. **Read the audit:** ~/dev/astra-command-center/logs/FULL_ECOSYSTEM_AUDIT_MARCH6.md
2. **Start Bonus Page 2.0 Phase 1:** Fix 10 critical/priority-1 bugs (spec at logs/BONUS_PAGE_2.0_SPEC.md)
3. **Supabase backend:** If Gabo created the project, start migration. If not, ask him.
4. **Content Beast:** Link to Vercel (`cd ~/dev/content-beast && vercel link`). Currently 404.
5. **7 Desktop book HTMLs not in any repo:** AOC_MANUSCRIPT_TRACKER, EXERCISE_DATABASE_VISUAL, etc. Consider importing to ASTRA KB.

### FIXES ALREADY APPLIED (DO NOT RE-DO)
- S.kb -> S.knowledgeBase (4 entries)
- 4 duplicate KB IDs removed
- 20+ stale URLs replaced (omega -> bonus.saturnomovement.com)
- C1/C2 labels fixed (3 occurrences)
- cloudLoad 401 handling added
- Auto-backup fixed (was no-op)
- 5 repos added to ASTRA (10 total)
- KB search via kb: prefix in Cmd+K
- 6 new Cmd+K commands
- KB staleness indicator
- Data integrity check command
- Full workspace export now includes knowledgeBase
- 2 completed tasks marked done (domain + env vars)

### REMAINING FROM 50 IMPROVEMENTS (not done yet)
Top priorities for C2:
- #1 Supabase migration (replaces localStorage)
- #2 Real-time sync (Supabase Realtime)
- #3 Silent auth fix (stale password prompt improvement) — partially done
- #7 Capture inbox (display Nexus captures in ASTRA — syncCaptures exists, needs UI)
- #8 Pipeline runner in ASTRA
- #45 Book project dashboard (import AOC_MANUSCRIPT_TRACKER)

---

## MEMORY WARNING FOR C2 CLAUDE

This file was written on C1 (iMac, Max 20x account, gabo@saturnomovement.com).
If you are on C2 (MacBook Pro) or on Max 5x account, YOUR MEMORY IS DIFFERENT.
You have NO context from the C1 sessions. This file IS your context.
Read it. Trust it. Execute from it.

---

## WHAT IS ASTRA

ASTRA Command Center is Gabo's private operating system — a 45,800+ line single HTML file that manages ALL projects across the Saturno ecosystem.

- **Live URL:** astra-command-center-sigma.vercel.app
- **GitHub:** gabosaturno11/astra-command-center
- **Deploy:** `cd ~/dev/astra-command-center && git push origin main` (Vercel auto-deploys)
- **Auth:** middleware.js + astra-gate.html (password: saturno2025 fallback)
- **Framework:** Zero dependencies. Single HTML file. All JS inline.
- **Design:** Dark theme, Endel-inspired, mint-green accents (#4ade80), #050508 base

---

## ASTRA'S ROLE IN THE ECOSYSTEM

```
ASTRA (dashboard/frontend) ---> Supabase (database/backend) <--- Bonus Page (customer frontend)
                                                               <--- SM App (iOS/Android/Web)
                                                               <--- Writing Hub SaaS (future)
                                                               <--- Movement Studio (future)
```

ASTRA = the control panel. Supabase = the brain. Everything else = frontends.
Currently ASTRA uses localStorage (browser-only, no sync between machines).
Supabase migration gives ASTRA real persistent memory.

---

## CURRENT STATE (March 4, 2026)

| Aspect | Status |
|--------|--------|
| Branch | main, up to date with origin |
| Last commit | 460d3ee (March 6 audit — 15 commits) |
| Uncommitted | This CLAUDE.md update |
| Manual version | v2.38 |
| File size | ~4.5 MB, 45,800+ lines |
| Storage | localStorage + Vercel Blob cloud sync (Cmd+S) |
| Auto-backup | Saves snapshot to localStorage every hour |
| Middleware | Restored (commit db85fb3) |
| Audit | FULL_ECOSYSTEM_AUDIT_MARCH6.md (660+ lines) |

### Vercel Env Vars (ALL SET — verified March 6 audit)

| Var | Purpose | Status |
|-----|---------|--------|
| BLOB_READ_WRITE_TOKEN | Vercel Blob state sync | SET |
| ASTRA_ADMIN_PASSWORD | API auth (Bearer token) | SET |
| OPENAI_API_KEY | Whisper transcription, pipeline | SET |
| ANTHROPIC_API_KEY | AI synthesis | SET |

---

## ACTIVE PROJECTS IN ASTRA (10 seeded)

| Project | ID | Status | Notes |
|---------|-----|--------|-------|
| Claude Code | proj_claude_code | Active | Session tracking, kernel rules |
| Saturno Bonus | proj_saturno_bonus | Active | Promo + vault + blog (see Bonus Page 2.0 spec below) |
| SM App Rebuild | (in KB) | Planning | Full blueprint at iCloud ASTRA_INTERNAL_TRANSFER/ |
| Art of Calisthenics | proj_book | Paused | Book submission package exists |
| HBS | proj_hbs | Paused | Handbalancing system |
| De Aqui a Saturno | proj_karina | Complete | Valentine's experience |
| Nexus Capture | proj_nexus_capture | Active | Chrome extension |
| Content Beast | proj_content_beast | Active | Content pipeline |
| Client OS | proj_client_os | Pending | Client management |
| Branding | proj_branding | Active | Logo system, modular SVG |

---

## KNOWLEDGE BASE INVENTORY (125+ entries)

50+ `kb_` entries and 80+ `ld_` living docs embedded in index.html.
To read: `grep -A 5 "id:'kb_" ~/dev/astra-command-center/index.html`

Key KB entries:
- `kb_bonus_bug_audit_mar4` — 10 verified issues (To Be Revisited)
- `kb_rebuild_plan` — SM App rebuild strategy
- `kb_where_is_everything` — Storage location map
- `kb_cloud_offload_march3` — 522GB cloud offload status

---

## ASTRA FEATURES (v2.38)

**7 Sections:** Content Vault, Tasks, Calendar, Writing Hub, Living Docs, Links, Whiteboard
**Core:** Projects as first-class entities, Cmd+K command palette (200+ commands), drag-drop kanban, voice input, wiki-links, knowledge graph, focus timer, keyboard shortcuts, export/import, ICS calendar, PWA
**Sessions:** 22+ documented sessions (Feb 16 - Mar 4), each adding features/fixes

---

## API ENDPOINTS (9)

| Endpoint | Purpose | Auth |
|----------|---------|------|
| /api/astra-verify | Auth verification | Cookie |
| /api/health | Health check | None |
| /api/repos | GitHub repo info | ASTRA_ADMIN_PASSWORD |
| /api/pipeline | Content pipeline | Custom |
| /api/capture | Nexus highlight capture | Token |
| /api/transcribe | Audio transcription | Token |
| /api/transcripts | Transcript storage | Token |
| /api/query | Backend query | Token |
| /api/state | State sync | Token |

---

## PER-PROJECT MESSAGE LOGS (NEW RULE - March 4)

Each project has its own gabo-messages.json. Messages go to the project they're about.

| Project | Message Log | Count |
|---------|-------------|-------|
| ASTRA | ~/dev/astra-command-center/logs/gabo-messages.json | 8 |
| Bonus | ~/dev/saturno-bonus/logs/gabo-messages.json | 612 (legacy) |
| SM App | ~/dev/sm-app-copy-v1/logs/gabo-messages.json | 14 |

---

## BACKEND ARCHITECTURE (Supabase Migration)

Full plan documented at:
- iCloud: `ASTRA_INTERNAL_TRANSFER/GABO_ONLY_READ_HAND_TO_C2.md`
- iCloud: `ASTRA_INTERNAL_TRANSFER/SATURNO_MOVEMENT_COMPLETE_REBUILD_BLUEPRINT.md`
- Google Drive: `CLAUDE_CODE_KERNEL/README_C2_SUPABASE_BACKEND.md` (3 copies)

**Summary:** Supabase Pro ($25/month) replaces:
- ASTRA localStorage (Supabase Postgres + Realtime)
- Bonus page Vercel Blob JSON (Supabase Postgres)
- Softzee's NestJS server ($300/month) for SM App

**Schema:** 25+ tables designed. See SATURNO_MOVEMENT_COMPLETE_REBUILD_BLUEPRINT.md Section 12.

**Deadline:** Backend live by Monday (Gabo directive, March 4)

---

## REPOS (all in ~/dev/)

| Repo | Live URL | What |
|------|----------|------|
| astra-command-center | astra-command-center-sigma.vercel.app | THIS. Dashboard/hub. |
| saturno-bonus | bonus.saturnomovement.com | Promo + vault + blog |
| titan-forge | titan-forge-ten.vercel.app | Internal tools |
| de-aqui-a-saturno | de-aqui-a-saturno-jet.vercel.app | Valentine's experience |
| nexus-capture | (Chrome extension) | Highlight capture |
| sm-app-copy-v1 | (not deployed) | SM App codebase clone |

---

## C1/C2 DISTINCTION (CRITICAL)

| Code | Machine | Username | Role |
|------|---------|----------|------|
| C1 | iMac | Gabosaturno (CAPITAL G) | Planning, chat, Max 20x context |
| C2 | MacBook Pro | gabosaturno (lowercase g) | Execution, deploys, backend work |

C1 session is CLOSED for code pushes. C2 does all deployments.
C1 (this machine) is for planning and context building with Max 20x.

---

## BACKUPS

| Location | Contents | Size |
|----------|----------|------|
| Google Drive BONUS_SATURNO_C2_TRANSFER/ | Full repo bundle + working tree | 2.2GB |
| Google Drive DEV_REPOS_BACKUP_C2_20260302/ | Git bundles for ALL 11 ~/dev/ repos | 1.3GB |
| G-DRIVE HOMEDIR_C1_BACK_UP_03.03.2026/ | Full home dir backup | 78GB |

---

## DESIGN CONSTRAINTS

- Dark theme ONLY
- ASTRA: Endel-inspired, mint-green (#4ade80), #050508 base
- Bonus: Cosmic blue/teal (#06b6d4, #22d3ee), #050711 base, Sora font
- No emojis in code
- planet-logo.png / planet-logo.svg = white planet silhouette
- Customer password: saturno2025

---

## RULES

1. Read THIS file first, then gabo-messages.json in this repo's logs/
2. DO NOT ASK Gabo questions this file answers
3. DO NOT claim "done" without testing
4. COMMIT after every meaningful change
5. Save ASTRA-related Gabo messages to THIS repo's logs/gabo-messages.json
6. Save bonus-related messages to saturno-bonus/logs/gabo-messages.json
7. UPDATE this file before session ends with honest state
8. NEVER push from C1 (planning only). C2 pushes.

---

## ANTI-PATTERNS (DO NOT REPEAT)

1. Asked "where are we at?" instead of reading this file
2. Made a 5-item TODO (real scope is 40+)
3. Created planning docs instead of writing code
4. Batched commits at end instead of incrementally
5. Declared "complete" after surface check
6. Stopped after pushing (push = checkpoint, not finish line)
7. Read stale files instead of repo files
8. Confused C1/C2 labels
9. Dumped all messages into saturno-bonus instead of per-project
10. Lost context between Max 20x and Max 5x accounts

---

## SESSION CHANGELOG (CONDENSED)

All 22+ sessions from Feb 16 - Mar 4 are documented. Key milestones:

| Date | Version | Key Changes |
|------|---------|-------------|
| Feb 16 | v2.0 | Full v2 upgrade. 3-panel layout, Cmd+K, projects, KB, wiki-links |
| Feb 17 | v2.1-2.5 | Backend API, Nexus Capture, bonus decoupled to saturno-bonus |
| Feb 22 | v2.23-2.25 | Smart search, accessibility, keyboard power, settings |
| Feb 25 | v2.29-2.30 | Ecosystem router, living docs, routing audit |
| Feb 26 | v2.31-2.38 | Security audit, mobile responsive, data integrity, whiteboard touch, KB nav |
| Mar 1-2 | - | Vercel outage, middleware removed/restored, auth lockout, data loss |
| Mar 3 | - | C1 cleanup, cloud offload (522GB), transfer docs created |
| Mar 4 | - | Per-project messages, Bonus 2.0 spec, ASTRA cleanup |

Full session details were in previous CLAUDE.md (1077 lines). Condensed to this.
If you need session-specific details, check git log for commit messages.
