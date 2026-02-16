# STOP. READ EVERY LINE. DO NOT SKIP.

You are a Claude Code session working on Gabo Saturno's digital ecosystem.

---

## ANTI-PATTERNS — MISTAKES PREVIOUS CLAUDES MADE (DO NOT REPEAT)

1. **ASKED "where are we at?"** — THIS FILE tells you. DO NOT ASK.
2. **ASKED "what's the priority?"** — THIS FILE tells you. DO NOT ASK.
3. **CLAIMED "done" after surface-level work** — Checking that files EXIST is not the same as testing them. Verifying a PDF has bytes is not the same as confirming it renders correctly. Adding meta tags is not "Phase 1 complete."
4. **Did not read Gabo's messages** — There are 15 messages at ~/dev/saturno-bonus/logs/gabo-messages.json. READ THEM before doing anything.
5. **Spent 30 minutes "orienting"** — You have THIS FILE. Read it, then EXECUTE. No orientation phase.
6. **Created planning documents instead of doing work** — Do NOT create new .md planning files. Work on the actual code.
7. **Batched commits** — Commit after EVERY meaningful change. Not at the end.
8. **Said "now I have everything I need"** — You never have everything. There's always more context. Stay humble.
9. **Declared things "complete" or "permanent SSOT"** — Nothing is final. Delta-patches only.
10. **Overwrote previous work instead of extending** — No crown stealing. Build ON TOP of what exists.

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

---

## CURRENT STATE (Updated: 2026-02-16 08:00 EST)

### REPOS (all in ~/dev/)

| Repo | Path | Live URL | Latest Commit |
|------|------|----------|---------------|
| titan-forge | ~/dev/titan-forge/ | titan-forge-sage.vercel.app | `9eb54ca` |
| astra-command-center | ~/dev/astra-command-center/ | astra-command-center.vercel.app | `2dfb9ee` |
| saturno-bonus | ~/dev/saturno-bonus/ | (pending domain) | `8a3f2da` |
| de-aqui-a-saturno | ~/dev/de-aqui-a-saturno/ | de-aqui-a-saturno.vercel.app | (check) |

### ASTRA COMMAND CENTER — DONE. DO NOT TOUCH UNLESS GABO SAYS.
- V2 is LIVE and working
- 6 projects, 60+ icons, KB, whiteboard, export, migration
- DO NOT modify unless Gabo explicitly says "ASTRA"

### TITAN-FORGE BONUS PAGE — THIS IS THE WORK

**What IS done (infrastructure only):**
- Password gate (gate.html) with shake animation, 7-day cookie, auto-redirect
- Meta tags, favicon, social preview on both gate.html and bonus.html
- Touch target CSS for mobile (min 44px)
- Brevo email capture form HTML exists (but NOT TESTED — needs BREVO_API_KEY in Vercel env)
- Vercel Analytics script tag added
- 17 PDFs exist in pdfs/ directory with content
- 49 tool entries exist in bonus.html

**What is NOT done (THE REAL WORK):**
- [ ] Deep UX/UI audit of bonus.html — visual bugs, layout issues, spacing, colors
- [ ] Tool color coding audit — GREEN=bonus, ORANGE=internal(HIDE from customers), GREY=needs fix
- [ ] ORANGE tools should be HIDDEN from the customer view
- [ ] Every tool link needs to be clicked and verified it works
- [ ] CF4 section needs proper calendar (currently has emoji mess)
- [ ] Music player needs audit — 39 MP3s in audio/, manifest.json exists, but audio 404s on Vercel
- [ ] Tool descriptions need review — are they customer-facing quality?
- [ ] Bottom CTA section styling
- [ ] Next product tease section (3-panel canvas or "coming soon")
- [ ] Mobile testing of every section
- [ ] PDF content quality check (not just "file exists")

### BLOCKERS (things Claude CANNOT fix — need Gabo)
1. Domain: bonus.saturnomovement.com (CNAME in Cloudflare) — Gabo must do
2. BREVO_API_KEY + BREVO_LIST_ID in Vercel env vars — Gabo must add
3. Audio on Vercel: audio/ is gitignored AND .vercelignored. Needs CDN solution — Gabo decides
4. Physical device testing — Gabo must do on his phone/iPad

---

## FILES YOU NEED

| File | Path | What It Is |
|------|------|------------|
| Bonus page | ~/dev/titan-forge/bonus.html | THE main deliverable (~1,270 lines) |
| Gate page | ~/dev/titan-forge/gate.html | Password entry (437 lines) |
| Implementation plan | ~/Desktop/CLAUDE ONLY FOLDER YOU READ/SATURNO_BONUS_IMPLEMENTATION_PLAN.html | 1,391 lines, 6 phases of detailed specs |
| Gabo messages | ~/dev/saturno-bonus/logs/gabo-messages.json | 15 messages with context |
| ASTRA app | ~/dev/astra-command-center/index.html | Only if Gabo says "ASTRA" |
| BB_EDITS | ~/Library/Mobile Documents/com~apple~CloudDocs/00_AI_HUB/BB_EDITS.md | Music track list, 40 tracks, 8 categories |

---

## WHAT TO DO (in order)

1. **Read this file** (you're doing it)
2. **Read ~/dev/saturno-bonus/logs/gabo-messages.json** — understand Gabo's intent
3. **Read the implementation plan** at ~/Desktop/CLAUDE ONLY FOLDER YOU READ/SATURNO_BONUS_IMPLEMENTATION_PLAN.html
4. **Open bonus.html and actually work on it** — fix UX, fix UI, fix bugs
5. **Commit + deploy after every meaningful change**
6. **Save every Gabo message** to the messages backend
7. **Update THIS FILE** with what you actually did before session ends

---

## DEPLOYMENT

### titan-forge (3.1GB repo — audio/video too big for normal deploy)
```bash
# Deploy via rsync to /tmp/ then push
cd ~/dev/titan-forge
rsync -av --exclude='music/' --exclude='audio/' --exclude='video/' --exclude='.git/' . /tmp/titan-forge-deploy/
cd /tmp/titan-forge-deploy
git add -A && git commit -m "message" && git push
```

**OR** if the repo is already connected to Vercel and pushes from ~/dev/titan-forge work:
```bash
cd ~/dev/titan-forge
git add -A && git commit -m "message" && git push
```

Check which method works. If push from ~/dev/titan-forge triggers Vercel deploy, use that.

### astra-command-center (small repo, normal push)
```bash
cd ~/dev/astra-command-center
git add -A && git commit -m "message" && git push
```

---

## DESIGN CONSTRAINTS

- Dark theme ONLY — cosmic blue/teal palette
- Sora font for customer-facing pages
- No emojis in code
- planet-logo.png = white planet silhouette (used in 13+ places)
- Customer page password: saturno2025
- Accent color: #4ade80 (mint green) for ASTRA, cosmic blue/teal for bonus

---

## GABO'S CORE DIRECTIVE

> "goal 1: next claude cannot come asking like you did"
> "the other solution: every semi change, commit, deploy update"
> "only if next claude comes and doesnt know where to go, or thinks its done"

Translation: You fail if you (1) ask questions this file answers, (2) think you're done when you're not, or (3) don't commit incrementally.

---

## RULES

1. DO NOT ASK Gabo questions this file answers
2. DO NOT claim "done" without having tested what you built
3. DO NOT create planning documents — work on actual code
4. DO NOT touch ASTRA unless Gabo says "ASTRA"
5. COMMIT after every meaningful change
6. Save every Gabo message to ~/dev/saturno-bonus/logs/gabo-messages.json
7. UPDATE this CLAUDE.md before your session ends with honest status
