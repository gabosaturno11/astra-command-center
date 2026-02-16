# ASTRA v2 — Refined Execution Spec for Claude Code
**Status:** Ready for autonomous build
**Context:** Claude Code already has the original plan. This doc REFINES and EXTENDS with specific implementation details, data structures, and pre-seeded content.
---
## 🎯 OBJECTIVE
Transform ASTRA from a 7-section command center into a **project-centric hub** where each project is a self-contained universe. Test with two pre-seeded projects:
1. **Saturno Bonus** — deployment status, repo info, customer-facing assets
2. **SM App Rebuild** — developer situation doc for tomorrow's call
---
## 📐 ARCHITECTURE OVERVIEW
```
ASTRA v2
├── SIDEBAR (left)
│   ├── [Existing 7 sections: Content, Tasks, Calendar, Writer, Living Docs, Links, Whiteboard]
│   └── PROJECTS (new section, below existing)
│       ├── Saturno Bonus (icon: rocket)
│       ├── SM App Rebuild (icon: code)
│       └── + New Project
│
└── MAIN AREA (right)
    └── PROJECT VIEW (when project selected)
        ├── HEADER: Project name + icon + status badge
        ├── TAB BAR: Instructions | Living Docs | Knowledge Base | Tasks | Links
        └── CONTENT PANELS (based on active tab)
```
---
## 🔧 DATA STRUCTURES
### Project Schema
```javascript
project: {
  id: string,
  name: string,
  icon: string,           // SVG icon key (rocket, code, book, music, globe, atom, tools, brain)
  status: 'active' | 'paused' | 'complete',
  createdAt: timestamp,
  instructions: string,   // Markdown - what this project IS
  livingDocIds: string[], // References to Living Docs scoped to this project
  kbItems: KBItem[],      // Knowledge base items (inline)
  taskIds: string[],      // References to existing tasks
  linkIds: string[]       // References to existing links
}
```
### Knowledge Base Item Schema
```javascript
kbItem: {
  id: string,
  name: string,
  type: 'md' | 'pdf' | 'img' | 'url' | 'txt' | 'json' | 'other',
  storage: 'inline' | 'reference',
  content: string | null,     // Inline content (text, small images as data URL <500KB)
  path: string | null,        // File path for reference-based storage
  url: string | null,         // URL for web resources
  description: string,
  tags: string[],
  createdAt: timestamp,
  updatedAt: timestamp
}
```
### Whiteboard Node Extension
```javascript
whiteboardNode: {
  ...existingFields,
  docRef: string | null,      // KB item ID - if set, renders as doc card
  docType: string | null,     // For icon/thumbnail rendering
  projectId: string | null    // Which project this node belongs to
}
```
---
## 🎨 ICON PICKER — 60+ Icons
```javascript
const PROJECT_ICONS = [
  // Tech & Dev
  'rocket', 'code', 'terminal', 'git', 'cpu', 'server', 'database', 'cloud',
  // Creative
  'book', 'pen', 'palette', 'camera', 'video', 'mic', 'music', 'layers',
  // Science
  'atom', 'brain', 'flask', 'dna', 'microscope', 'telescope',
  // Navigation
  'globe', 'map', 'compass', 'flag', 'target', 'crosshair',
  // Objects
  'tools', 'wrench', 'hammer', 'key', 'lock', 'shield', 'crown', 'diamond',
  // Nature
  'sun', 'moon', 'star', 'lightning', 'fire', 'mountain', 'tree', 'leaf',
  // Communication
  'mail', 'message', 'phone', 'bell', 'megaphone',
  // Business
  'chart', 'trending', 'dollar', 'briefcase', 'building',
  // People
  'user', 'users', 'heart', 'hand', 'eye',
  // Time & Organization
  'calendar', 'clock', 'folder', 'file', 'grid', 'list', 'archive',
  // Movement (Saturno-specific)
  'activity', 'zap', 'anchor', 'feather'
];
// Implementation: Use Lucide icons (already lightweight SVGs)
```
---
## 📑 TAB STRUCTURE — Project Detail View
### Tab 1: Instructions
- Full-width markdown editor
- Auto-saves on blur/debounce
- This is "what this project IS" — context any AI can read instantly
- Supports standard markdown + code blocks
### Tab 2: Living Docs
- Grid view of Living Docs where `livingDoc.projectId === thisProject.id`
- Each card shows: title, last updated, preview snippet
- Click to open in editor (same as current Living Docs behavior)
- "+ Add Living Doc" button (creates with projectId pre-filled)
### Tab 3: Knowledge Base
- Grid/list toggle view
- Each item card shows:
  - Type badge (PDF, IMG, MD, TXT, URL)
  - Name
  - Description preview
  - Tags (if any)
  - Drag handle (for whiteboard)
- Add options:
  - Paste text → creates MD item
  - Paste image → converts to data URL if <500KB, else prompts for path
  - Add file reference → name + path + description
  - Add URL → fetches title, stores as URL type
- Click to expand/edit
- **Drag to whiteboard** creates linked node
### Tab 4: Tasks
- Filtered view: `tasks.filter(t => t.projectId === thisProject.id)`
- Same task card UI as main Tasks section
- "+ Add Task" pre-fills projectId
### Tab 5: Links
- Filtered view: `links.filter(l => l.projectId === thisProject.id)`
- Same link card UI as main Links section
- "+ Add Link" pre-fills projectId
---
## 🚀 PRE-SEEDED PROJECT 1: Saturno Bonus
```javascript
{
  id: "proj_saturno_bonus",
  name: "Saturno Bonus",
  icon: "rocket",
  status: "active",
  instructions: `# Saturno Bonus — Customer Bonus Vault
## Purpose
Customer-facing bonus page with tools, music, and CF4 content for BF25 buyers.
## Deployment
| Environment | URL | Status |
|-------------|-----|--------|
| **Production** | https://titan-forge-sage.vercel.app/bonus.html | ✅ Live |
| **Repo** | https://github.com/gabosaturno11/titan-forge | Main branch |
| **Password** | saturno2025 | — |
## What's Included
- Hand-balancing tools & progressions
- Music/audio content
- CF4 bonus materials
- Downloadable PDFs (Biomechanics ebook DONE)
## Current Status
✅ Deployed and live on Vercel
✅ Biomechanics ebook complete
⚠️ Needs: Content audit for broken links
⚠️ Needs: Verify all PDF downloads work
## Next Actions
1. Run full link audit on bonus.html
2. Confirm all video embeds load
3. Test PDF download flow
4. Add any missing BF25 deliverables`,
  kbItems: [
    {
      id: "kb_bonus_deploy",
      name: "Deployment Status",
      type: "md",
      storage: "inline",
      content: `# Deployment Status — Saturno Bonus
**Live URL:** https://titan-forge-sage.vercel.app/bonus.html
**Password:** saturno2025
**Deploys from:** titan-forge repo, main branch
**Platform:** Vercel (auto-deploy on push)
## Deployment Checklist
- [x] Vercel project connected
- [x] Custom domain configured
- [x] Password protection active
- [ ] Analytics tracking
- [ ] Error monitoring`,
      description: "Current deployment status and checklist",
      tags: ["deployment", "vercel", "status"]
    },
    {
      id: "kb_bonus_repo",
      name: "Repository Structure",
      type: "md",
      storage: "inline",
      content: `# titan-forge Repository
**GitHub:** https://github.com/gabosaturno11/titan-forge
## Key Files
- \`/bonus.html\` — Main bonus page
- \`/assets/\` — Images, PDFs, media
- \`/styles/\` — CSS
## Branches
- \`main\` — Production (Vercel deploys from here)
- \`gh-pages\` — STALE, do not use (logo 404s)
## Deploy Process
1. Make changes locally
2. \`git add . && git commit -m "message"\`
3. \`git push origin main\`
4. Vercel auto-deploys in ~30 seconds`,
      description: "Repo structure and deploy process",
      tags: ["github", "repo", "structure"]
    }
  ],
  livingDocIds: [],
  taskIds: [],
  linkIds: []
}
```
---
## 🚀 PRE-SEEDED PROJECT 2: SM App Rebuild
```javascript
{
  id: "proj_sm_app_rebuild",
  name: "SM App Rebuild",
  icon: "code",
  status: "active",
  instructions: `# SM App Rebuild — Developer Situation
## Vision
"Ableton of Movement" — a movement composition app that treats movement like music production.
## The Situation
- Current app built by Softzee
- Unclear ownership boundaries
- Need to establish: what we own vs. what they control
- Goal: Take over maintenance or rebuild
## For Tomorrow's Developer Call
**Primary Objectives:**
1. Clarify codebase ownership
2. Understand current deployment pipeline
3. Define handoff requirements
4. Establish realistic timeline
## Key Questions to Answer
1. Where does the current codebase live?
2. What's the deployment process?
3. What do we need from them to take over?
4. What's the minimum viable handoff?
5. Are there any vendor lock-ins or proprietary dependencies?
## Research Context (from R3)
- Fitness App Benchmarking needed
- Movement UX Patterns research
- Pricing & Monetization strategy`,
  kbItems: [
    {
      id: "kb_dev_call_prep",
      name: "Developer Call Prep — TOMORROW",
      type: "md",
      storage: "inline",
      content: `# Developer Call Prep Doc
**Date:** Tomorrow
**With:** Softzee team
**Goal:** Understand ownership, get access, define handoff
---
## BEFORE THE CALL
- [ ] Confirm we have (or request) repo access
- [ ] List all services/APIs the app currently uses
- [ ] Identify hosting/deployment setup
- [ ] Review any existing contracts or agreements
---
## QUESTIONS TO ASK
### Ownership & Access
1. "What parts of the codebase are proprietary to Softzee vs. ours?"
2. "Can we get full repo access today?"
3. "Who has admin access to deployment platforms?"
### Technical Architecture
4. "What third-party services does this rely on?"
5. "Walk me through how updates get pushed live"
6. "What's the database situation — who owns the data?"
### Handoff
7. "What's the cleanest path to us taking over maintenance?"
8. "What documentation exists?"
9. "Can you do a recorded walkthrough of the codebase?"
---
## RED FLAGS TO WATCH
⚠️ Vague answers about ownership
⚠️ Reluctance to share repo access
⚠️ Hidden dependencies or vendor lock-in
⚠️ No documentation
⚠️ "It's complicated" without specifics
⚠️ Pushback on recorded walkthrough
---
## IDEAL OUTCOME
✅ Full repo access granted (or timeline for it)
✅ Clear list of all dependencies and services
✅ Written handoff timeline with milestones
✅ Recorded architecture walkthrough scheduled
✅ No surprises — everything on the table
---
## NOTES DURING CALL
(Fill in during the call)
### What we learned:
### Action items:
### Follow-up needed:`,
      description: "Prep doc for developer call — questions, red flags, ideal outcomes",
      tags: ["developer", "call", "prep", "priority"]
    },
    {
      id: "kb_app_vision",
      name: "App Vision — Ableton of Movement",
      type: "md",
      storage: "inline",
      content: `# Saturno Movement App — Vision Doc
## The Concept
"Ableton of Movement" — treat movement composition like music production.
## Core Metaphor
| Music (Ableton) | Movement (SM App) |
|-----------------|-------------------|
| Tracks | Movement sequences |
| Clips | Individual exercises |
| Arrangement | Workout flow |
| Effects | Progressions/regressions |
| Tempo | Pace/rest intervals |
| Mix | Balance of modalities |
## Key Features (Vision)
1. **Drag-and-drop workout builder**
2. **Movement library** (video clips)
3. **Progression paths** (like effect chains)
4. **Templates** (like Ableton project templates)
5. **Export** (to PDF, video, calendar)
## Differentiators
- Not just "pick exercises" — COMPOSE movement
- Visual timeline interface
- Modular, remixable workouts
- Built for creators, not just consumers`,
      description: "The Ableton of Movement vision for the app",
      tags: ["vision", "product", "app"]
    },
    {
      id: "kb_softzee_situation",
      name: "Softzee Situation Summary",
      type: "md",
      storage: "inline",
      content: `# Softzee Situation — What We Know
## Current State
- Softzee built the current SM app
- Ownership boundaries unclear
- We need to either:
  - A) Take over maintenance
  - B) Rebuild from scratch
  - C) Continue partnership with clearer terms
## What We Need to Clarify
1. **Code ownership** — Do we own the codebase or just license it?
2. **Data ownership** — User data, content, analytics
3. **Deployment control** — Can we deploy without them?
4. **Dependencies** — What breaks if we part ways?
## Possible Outcomes
### Best Case
Full handoff, we own everything, clean break, documentation provided.
### Acceptable Case
Transition period, they support handoff, we rebuild critical pieces.
### Worst Case
Vendor lock-in, proprietary dependencies, need full rebuild.
## Decision Framework
If handoff cost > rebuild cost → rebuild
If handoff time > 3 months → consider rebuild
If trust is broken → rebuild`,
      description: "Summary of the Softzee developer situation",
      tags: ["softzee", "developer", "situation"]
    }
  ],
  livingDocIds: [],
  taskIds: [],
  linkIds: []
}
```
---
## 📦 STORAGE STRATEGY
```javascript
// localStorage keys
'astra_projects'        // Project[] array
'astra_kb_items'        // KBItem[] array (if separating from projects)
'astra_whiteboard'      // Existing — extend with docRef support
// Storage budget
// Current usage: ~34.5KB
// localStorage limit: 5-10MB
// Headroom: PLENTY
// Future-proofing: If >2MB, migrate to IndexedDB
```
### Hybrid Storage Rules
| Content Type | Size | Storage Method |
| --- | --- | --- |
| Text/Markdown | Any | Inline |
| Small images | <500KB | Data URL inline |
| Large images | >500KB | Path reference |
| PDFs | Any | Path reference |
| Videos | Any | URL reference |
| Code snippets | Any | Inline |
---
## 🎨 DESIGN SPECS
### Keep Existing
- Endel-inspired dark theme
- Current 7-section sidebar layout
- All existing functionality untouched
### Add
- **Projects section** in sidebar (collapsible, below existing sections)
- **Project icons:** 24x24px, muted color (#666), brighten on hover (#fff)
- **Status badges:** 
  - Active: green dot (#4ade80)
  - Paused: yellow dot (#facc15)
  - Complete: checkmark (#4ade80)
- **Tab bar:** pill-style tabs, subtle background on active (#333)
- **KB cards:** rounded corners (8px), subtle border (#333), hover lift (translateY -2px)
- **Type badges:** colored pills (MD=blue, PDF=red, IMG=green, URL=purple, TXT=gray)
---
## ⚡ EXECUTION ORDER
```
PHASE 1 (30 min): Data Layer
├── Define project schema in code
├── Define KB item schema
├── Create CRUD functions: createProject, updateProject, deleteProject
├── Create CRUD functions: addKBItem, updateKBItem, deleteKBItem
├── Pre-seed Saturno Bonus project with all content above
└── Pre-seed SM App Rebuild project with all content above
PHASE 2 (30 min): Projects Sidebar
├── Add "PROJECTS" section header to sidebar
├── Render project list with icons and status dots
├── Icon picker modal (grid of 60 icons)
├── Click project → set as active, show in main area
├── "+ New Project" button with name + icon picker
└── Collapse/expand toggle for section
PHASE 3 (45 min): Project Detail View
├── Header component: icon + name + status badge + edit button
├── Tab bar component: Instructions | Living Docs | KB | Tasks | Links
├── Instructions tab: markdown editor with auto-save
├── Living Docs tab: filtered grid + add button
├── Knowledge Base tab: grid view + add modal + type badges
├── Tasks tab: filtered list + add button
└── Links tab: filtered list + add button
PHASE 4 (30 min): Knowledge Base Features
├── Add KB item modal (paste text, paste image, add reference, add URL)
├── Image paste → detect size → inline or prompt for path
├── KB item card component with drag handle
├── Click to expand/edit KB item
└── Delete KB item with confirmation
PHASE 5 (20 min): Whiteboard Integration
├── Extend whiteboard node schema with docRef, docType, projectId
├── Implement drag from KB → drop on whiteboard
├── Render doc-linked nodes with icon + name + description
├── Double-click doc node → open KB item
└── Visual distinction for doc nodes vs plain nodes
PHASE 6 (15 min): Polish & Deploy
├── Test Saturno Bonus project end-to-end
├── Test SM App Rebuild project end-to-end
├── Verify Developer Call Prep doc is accessible
├── Test whiteboard drag integration
├── Verify localStorage persistence across refresh
└── Deploy to Vercel
```
---
## ✅ DEFINITION OF DONE
1. ✅ Projects section visible in sidebar with both pre-seeded projects
2. ✅ Click "Saturno Bonus" → see Instructions, KB with deployment docs
3. ✅ Click "SM App Rebuild" → see Instructions, KB with Developer Call Prep
4. ✅ Developer Call Prep doc is complete and ready for tomorrow
5. ✅ Can add new KB items (text, image, reference, URL)
6. ✅ Can drag KB item onto whiteboard → creates linked node
7. ✅ All data persists in localStorage
8. ✅ Deployed live to https://astra-command-center.vercel.app
---
## 🗣️ CONTEXT FOR CLAUDE CODE
> You already have the original plan. This doc REFINES it with:
> - Exact data structures (copy-paste ready)
> - Complete pre-seeded content for both projects
> - Specific UI specs (colors, sizes, behaviors)
> - Phase-by-phase execution order
> 
> **PRIORITY 1:** SM App Rebuild with Developer Call Prep doc — user has a call TOMORROW
> **PRIORITY 2:** Saturno Bonus with deployment info
> **PRIORITY 3:** Whiteboard drag integration
> 
> The existing 7 sections stay UNTOUCHED. You're ADDING alongside them.
> 
> Design language: Endel dark theme is already established. Match it exactly.
> 
> When in doubt: ship working > ship perfect. User needs this tonight.
---
## 📎 REFERENCE LINKS
- **ASTRA Live:** https://astra-command-center.vercel.app
- **ASTRA Repo:** https://github.com/gabosaturno11/astra-command-center
- **Saturno Bonus Page:** https://titan-forge-sage.vercel.app/bonus.html
- **titan-forge Repo:** https://github.com/gabosaturno11/titan-forge