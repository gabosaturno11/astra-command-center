# ASTRA Command Center

**Live:** [astra-command-center.vercel.app](https://astra-command-center.vercel.app)
**Repo:** [github.com/gabosaturno11/astra-command-center](https://github.com/gabosaturno11/astra-command-center)
**Local:** `~/dev/astra-command-center/`
**Vercel Team:** `gabosaturno03s-projects` (Saturno OS)
**Vercel Project:** `astra-command-center`

A zero-dependency, single-file command center for creative solopreneurs. Built as one self-contained HTML file — no frameworks, no build tools, no external APIs. Everything runs in the browser, persists to localStorage.

## What It Is

ASTRA is a private operating system for managing content, tasks, writing, knowledge, links, and visual planning — all from one dark, minimal interface. Designed for people who run entire businesses alone and need everything in one place without the overhead of 12 different SaaS subscriptions.

## 7 Sections

| Section | What It Does |
|---------|-------------|
| **Content Vault** | Store and organize content pieces — filter by type (note, idea, draft, snippet, reference) and theme (book, brand, product, personal, research) |
| **Tasks** | Full task manager with list view, kanban board, and calendar view — drag-and-drop, priorities (P1-P4), status tracking, project grouping |
| **Calendar** | Month view with task pills — drag tasks between dates, ICS export, today highlighting |
| **Writing Hub** | Distraction-free rich text editor with formatting toolbar, version history (50 snapshots), word/character count, markdown export, document management sidebar |
| **Living Docs** | Structured knowledge base with collapsible sections — pre-loaded with 20 kernel sections covering identity, architecture, voice modes, agent stacks, research domains |
| **Links** | Categorized link manager — deploy, tool, reference, resource, docs categories with search |
| **Whiteboard** | Infinite canvas with pan/zoom, 20 enterprise templates (Mind Map, SWOT, Eisenhower, Org Chart, Flowchart, etc.), node connections with bezier curves, minimap, auto-layout, PNG/SVG/JSON export |

## Features

- **Voice Input** — Browser-native speech-to-text on Writing Hub and Living Docs (Web Speech API)
- **Drag-and-Drop** — Tasks across kanban columns, calendar dates, and board views
- **Version History** — 50 snapshots per document with one-click restore
- **Full Export/Import** — JSON backup of entire state, plus markdown export for individual docs
- **20 Whiteboard Templates** — Blank Canvas, Mind Map, Eisenhower Matrix, SWOT Analysis, Project Roadmap, Org Chart, User Persona, Content Calendar, Product Breakdown, Stakeholder Map, 5 Whys, Impact Mapping, RACI Matrix, Action Plan, Gap Analysis, Communication Plan, Service Blueprint, Priority Matrix, Flowchart, Revenue Roadmap
- **Keyboard Shortcuts** — Whiteboard: V(select), H(hand), N(node), C(connect), T(text), S(sticky), G(grid), Delete, Cmd+Z/Cmd+Shift+Z, +/-, 0(reset)
- **ICS Calendar Export** — Export tasks as calendar events
- **Autosave** — 1-second debounced save on every change
- **LocalStorage Persistence** — All data stays in the browser, no server needed
- **Storage Indicator** — Live display of how much localStorage is used

## Design

Endel-inspired dark interface with neutral grey gradients and mint-green accents:

- **Palette**: Deep blacks (`#09090b`) with subtle grey gradient surfaces
- **Accent**: Mint green (`#4ade80`) with teal secondary (`#2dd4bf`)
- **Typography**: System fonts (SF Pro / Segoe UI) + SF Mono for code
- **Borders**: Ultra-subtle `rgba(255,255,255,0.05)` with green glow on interaction
- **Radii**: 8px standard, 12px for cards and panels

## Tech

- **1 HTML file** — `index.html` (120 KB, ~1,200 lines)
- **0 dependencies** — no npm, no CDN, no build step
- **0 external calls** — no APIs, no analytics, no tracking
- **Pure vanilla** — HTML + CSS + JavaScript
- **Works offline** — open the file, it works
- **Browser storage** — localStorage for all persistence

## Deployment

| What | Where |
|------|-------|
| **Production** | [astra-command-center.vercel.app](https://astra-command-center.vercel.app) |
| **Vercel Team** | `gabosaturno03s-projects` (Saturno OS) |
| **Vercel Project** | `astra-command-center` |
| **GitHub Repo** | [gabosaturno11/astra-command-center](https://github.com/gabosaturno11/astra-command-center) |
| **Local Path** | `~/dev/astra-command-center/` |
| **Deploy Method** | `vercel --prod` from project root |

```bash
# Run locally
open index.html

# Deploy
cd ~/dev/astra-command-center
vercel --prod
```

## Structure

```
~/dev/astra-command-center/
  index.html    # The entire application (120 KB)
  README.md     # This file
  .vercel/      # Vercel project config (gitignored)
```

One file. Everything inside.

## License

Private.
