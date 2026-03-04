# GABO RANT — 2026-03-03 ~1:53 AM
## Topic: Storage chaos, mirroring madness, 40+ copies of everything

### The Problem
14+ folders named "titan" on one machine. OneDrive mirroring Google Drive mirroring Git. iCloud adding noise. 3 monster hard drives. No SSOT. No rails.

### Gabo's Decisions (captured live)

**SSOT model:**
- Local ~/dev/ = truth
- 1:1 with GitHub repo
- 1:1 with Vercel deployment (same account)
- README gets updated with date after every deploy

**Google Drive:**
- One LEGACY/BACK-UPS folder (color-coded)
- Updated bi-weekly or weekly
- Fallback only — in case need to redeploy from somewhere else

**SSK (2TB pen drive):**
- "The traveling rebel"
- Weekly Friday backup of local repos
- Take local repos, not Git repos — local is what actually works

**Monster drives (Main LaCie + others at C2 location):**
- One archive folder: "Good luck"
- Not for deployable code
- For looking stuff up when needed
- Alert when Downloads hits 50 items with no proper names

**OneDrive:**
- Stop mirroring Google Drive (that's insane)
- Use for 1-2 private folders max, simple storage
- Path-too-long bug makes it unusable for deep nesting

**iCloud:**
- Considering restricting/shutting down for dev work
- "If we restrict Gabo from iCloud = Gabo becomes a happy human"
- Convenient for travel backups but too many holes

**Dropbox (2TB):**
- Used for Victory Belt
- Auto-uploads photos and screenshots
- Good for weekly screenshot organization (10 categories max)
- Delete from phone after organizing

**Screenshots (weekly routine):**
- 10 categories max: prompts, Claude thinking, app designs, quotes, etc.
- Run once a week, then delete from phone
- Dropbox handles the auto-upload

**The workflow Claude is building:**
- After every deploy: update README with date
- Weekly Friday: backup ~/dev/ to SSK
- Weekly: organize screenshots from Dropbox
- Alert on Downloads clutter
- No more mirroring chains (OneDrive > Google Drive > Git > Vercel = madness)

### Gabo's words
> "I have too many opportunities and I have to choose"
> "you can create, and because of that YOU NEED RAILS"
> "It is the same amount of work so it is the same shit"
> "I'm fucking tired"
> "You cannot always deploy what you have locally and expect good results"
> "micro things that make the system pipeline clean and it is possible"
> "it just needs to be laid out and not mix with 20 other instances"

### Context
- C2 MacBook Pro: M4 Pro, 48GB RAM, macOS Tahoe 26.3
- C1 iMac: Intel Xeon W, 32GB RAM, macOS Sequoia 15.8 (10 versions behind)
- They will never sync cleanly — different architectures
- C1 = monitor with browser. C2 = the builder.
- Main LaCie and Ableton Live 12 drives visible in Finder sidebar
- Gabo is NOT a developer — he needs rails, not flexibility
