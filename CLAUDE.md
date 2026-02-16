# STOP. READ EVERY LINE. DO NOT SKIP.

You are a Claude Code session working on Gabo Saturno's digital ecosystem.

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

## CURRENT STATE (Updated: 2026-02-16 10:00 EST)

### REPOS (all in ~/dev/)

| Repo | Path | Live URL | Latest Commit |
|------|------|----------|---------------|
| titan-forge | ~/dev/titan-forge/ | titan-forge-sage.vercel.app | `86dd606` |
| astra-command-center | ~/dev/astra-command-center/ | astra-command-center.vercel.app | `ab32c9a` |
| saturno-bonus | ~/dev/saturno-bonus/ | (pending domain) | `dc752ba` |
| de-aqui-a-saturno | ~/dev/de-aqui-a-saturno/ | de-aqui-a-saturno.vercel.app | (check) |

### ASTRA COMMAND CENTER — DONE. DO NOT TOUCH UNLESS GABO SAYS.
- V2 is LIVE and working
- 6 projects, 60+ icons, KB, whiteboard, export, migration
- DO NOT modify unless Gabo explicitly says "ASTRA"

### TITAN-FORGE BONUS PAGE — CURRENT STATE

**What HAS been shipped (committed + pushed):**
- 3 internal tools hidden (Master Hub, Music Organizer, Transcript to PDF)
- Auth works on Vercel + custom domains (not just github.io)
- og:image absolute URL on both gate.html and bonus.html
- Vercel Analytics production script (was debug)
- Modal signup: alert() replaced with inline feedback
- Modal closes on overlay click
- Music auto-advances to next track
- Track count dynamic (was hardcoded "36")
- Lock Vault button in footer (clears cookie + localStorage)
- Coming Soon tease section (Handstand System, The Book, App V2)
- BONUS badges on HBF and exclusive PDFs (green border + badge)
- ALL 44 tool descriptions rewritten to customer-facing quality
- Tools categorized: 19 Training + 25 Experience (was vague tags)
- Case-sensitive audio path fixed (Tears-Of-Joy-Chill)
- .env.example created
- Gate og:image fixed to absolute URL

**What still needs work:**
- [ ] CF4 calendar inside CF4_COMPLETE_PROGRAM.html (emoji mess needs clean calendar)
- [ ] More tools could be checked individually for UX quality
- [ ] app-promo.mov needs MP4 conversion for cross-browser video embed
- [ ] Consider adding PDF thumbnails (currently text-only cards)
- [ ] Music player UX improvements (shuffle, repeat, volume control)
- [ ] Footer could be more polished

### BLOCKERS (things Claude CANNOT fix — need Gabo)
1. Domain: bonus.saturnomovement.com (CNAME in Cloudflare) — Gabo must do
2. BREVO_API_KEY + BREVO_LIST_ID in Vercel env vars — Gabo must add
3. Audio on Vercel: audio/ is gitignored AND .vercelignored. Needs CDN solution — Gabo decides
4. Physical device testing — Gabo must do on his phone/iPad
5. app-promo.mov is MOV format — needs conversion to MP4 for web

---

## FILES YOU NEED

| File | Path | What It Is |
|------|------|------------|
| Bonus page | ~/dev/titan-forge/bonus.html | THE main deliverable (~1,370 lines) |
| Gate page | ~/dev/titan-forge/gate.html | Password entry (485 lines) |
| Implementation plan | ~/Desktop/CLAUDE ONLY FOLDER YOU READ/SATURNO_BONUS_IMPLEMENTATION_PLAN.html | 1,391 lines, 6 phases |
| Gabo messages | ~/dev/saturno-bonus/logs/gabo-messages.json | 16+ messages with context |
| Full convos | ~/dev/astra-command-center/logs/full convos gabo will save until claude solves this/ | READ THIS |
| ASTRA app | ~/dev/astra-command-center/index.html | Only if Gabo says "ASTRA" |
| BB_EDITS | ~/Library/Mobile Documents/com~apple~CloudDocs/00_AI_HUB/BB_EDITS.md | Music track list |

---

## WHAT TO DO (in order)

1. **Read this file** (you're doing it)
2. **Read ~/dev/saturno-bonus/logs/gabo-messages.json** — understand Gabo's intent
3. **Read the full convos folder** in ASTRA logs
4. **Ask Gabo what the priority is** if he's awake — otherwise continue where this list stops
5. **Commit + deploy after every meaningful change**
6. **Save every Gabo message** to the messages backend
7. **UPDATE this CLAUDE.md** with what you actually did before session ends

---

## DEPLOYMENT

### titan-forge
```bash
cd ~/dev/titan-forge
git add <specific-files> && git commit -m "message" && git push
```
Vercel auto-deploys on push to main.

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
