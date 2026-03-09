# ASTRA Command Center

**Live:** [astra-command-center-sigma.vercel.app](https://astra-command-center-sigma.vercel.app)
**Version:** v2.42
**Deploy:** `git push origin main` (Vercel auto-deploys)

A single-file command center for managing an entire digital ecosystem. Dark theme, zero frameworks, all inline JS/CSS. Built for solopreneurs who need everything in one place.

## 11 Sections

| Section | What It Does |
|---------|-------------|
| **Dashboard** | Metrics, urgent tasks, project grid, quick actions, session timer |
| **Content Vault** | Content pieces — notes, ideas, drafts, snippets, references |
| **Tasks** | List, kanban board, and calendar views — drag-and-drop, P1-P4 priorities |
| **Calendar** | Month view with task pills, ICS export |
| **Writing Hub** | Rich text editor with version history, word goals, zen mode |
| **Living Docs** | Structured specs with collapsible sections |
| **Links** | Categorized link manager with health checks |
| **Doc Hub** | Knowledge base with markdown rendering, archive, tags |
| **Whiteboard** | Infinite canvas with 20 templates, node connections, minimap |
| **Pipeline** | AI content pipeline — 8 voice modes, 6 faders, prompt templates |
| **Repos** | Connected GitHub repos with live status |

## Key Features

- **Triple sync:** localStorage + Vercel Blob (30s) + Supabase (60s) + Realtime
- **Cmd+K command palette:** 200+ commands, fuzzy search
- **Keyboard shortcuts:** Cmd+0-9 sections, Cmd+N new, Cmd+K search
- **Projects:** Multi-project management with KB, tasks, content per project
- **Knowledge Base:** 125+ entries with inline markdown, tags, archive
- **Brain Dump:** Quick rant capture with routing to content/pipeline
- **Voice Modes:** 8 modes (Raw, Teacher, Prophet, etc.) + 6 faders
- **Ecosystem Health:** Live API + deployment status checker
- **Export/Import:** Full workspace backup with versioning metadata
- **Supabase Realtime:** Cross-machine live sync (11 tables)
- **Auto-restore:** Detects empty localStorage, offers cloud restore

## Tech

- **1 HTML file** — `index.html` (~46,700 lines, 4.7 MB)
- **All JS/CSS inline** — no build step, no bundler
- **Backend:** 12 Vercel serverless API endpoints
- **Storage:** localStorage + Vercel Blob + Supabase Postgres
- **Dependencies:** @vercel/blob, @supabase/supabase-js, openai
- **Auth:** Middleware + password gate

## API Endpoints

| Endpoint | Purpose |
|----------|---------|
| /api/health | Health check |
| /api/config | Public config (capabilities) |
| /api/state | Vercel Blob state sync |
| /api/supabase-sync | Supabase CRUD |
| /api/pipeline | AI content pipeline |
| /api/capture | Nexus extension capture |
| /api/transcribe | Audio transcription |
| /api/repos | GitHub repo info |
| /api/astra-verify | Auth verification |
| /api/transcripts | Transcript storage |
| /api/query | Backend query |

## Structure

```
~/dev/astra-command-center/
  index.html          # The entire frontend (~46,700 lines)
  api/                # 12 Vercel serverless functions
  docs/               # Supabase migration SQL
  logs/               # Session logs, specs, audit reports
  astra-gate.html     # Auth gate page
  astra-manual.html   # User manual
  middleware.js        # Auth middleware
  package.json        # Node dependencies
  CLAUDE.md           # Project-specific Claude Code context
  README.md           # This file
```

## Design

- Dark theme only — Endel-inspired
- Base: `#050508`
- Accent: mint green `#4ade80`
- Section colors: tasks=green, content=cyan, writer=purple, calendar=yellow
- Font: system stack (SF Pro / Segoe UI)

## License

Private.
