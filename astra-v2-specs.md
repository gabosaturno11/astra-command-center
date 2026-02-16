# ASTRA V2 — Technical Specs
**Author:** Claude Opus 4.6 (Session Feb 15, 2026)
**Status:** APPROVED BY GABO — Ready to build
**Repo:** ~/dev/astra-command-center/
**Live:** astra-command-center.vercel.app

---

## WHAT V1 HAS (1,198 lines, single HTML file)
- 7 Sections: Content, Tasks, Calendar, Writing Hub, Living Docs, Links, Whiteboard
- Tasks have `project` field but no project-level architecture
- Living Docs are standalone (not tied to projects)
- Whiteboard has 20 templates, nodes, connections, minimap
- localStorage-based (currently ~34.5KB used, limit is 5-10MB)
- Endel-inspired dark theme: mint-green #4ade80 on deep black
- Voice input, drag-drop, version history, export/import

## WHAT V2 ADDS

### 1. PROJECTS AS FIRST-CLASS ENTITIES

**Data Model:**
```javascript
{
  id: Number,
  name: String,           // "Saturno Bonus"
  icon: String,           // SVG icon key (e.g. "globe", "rocket", "music")
  color: String,          // accent color for this project
  instructions: String,   // markdown — what this project IS
  created: ISO String,
  updated: ISO String
}
```

**Sidebar behavior:**
- New sidebar section: "PROJECTS" below existing sections
- Each project shows: icon + name + badge count (total items)
- Click project → main area shows Project Detail View
- Active project filters Tasks, Living Docs, Links, Knowledge Base automatically
- "All Projects" view shows everything (current behavior preserved)

### 2. PROJECT DETAIL VIEW

When a project is selected, the main content area shows a tabbed view:

```
[Instructions] [Living Docs] [Knowledge Base] [Tasks] [Links]
```

**Instructions Tab:**
- Full-width markdown editor (like Writing Hub)
- This is the "project README" — what it is, current status, key decisions
- Any Claude (Code, API, AI) can read this and know instantly what the project is

**Living Docs Tab:**
- Shows only Living Docs where `doc.projectId === activeProject.id`
- Same collapsible-section editor as current
- Can create new Living Docs scoped to this project
- Existing standalone Living Docs can be assigned to a project

**Knowledge Base Tab (NEW):**
- Grid of document cards (like Content Vault cards but for files)
- Each item has: name, type badge, description, tags, content/reference
- Supports:
  - **Text/Markdown** — stored inline in localStorage
  - **Images < 500KB** — stored as base64 data URL inline
  - **Larger files** — stored as file path reference (opens in Finder/browser)
  - **URLs** — external reference with preview
- Add methods: "+ Add" button, paste image, drag file reference
- Cards are **draggable to whiteboard** (creates node with docRef)

**Knowledge Base Item Data Model:**
```javascript
{
  id: Number,
  projectId: Number,
  name: String,           // "Visual Branding - Color Palette.pdf"
  type: String,           // "pdf", "image", "markdown", "text", "url", "video", "html"
  description: String,    // "Official brand colors for all Saturno properties"
  tags: [String],         // ["design", "branding"]
  content: String|null,   // inline content (text, markdown, small image data URL)
  filePath: String|null,  // local file reference (e.g. "~/Downloads/spec.pdf")
  url: String|null,       // external URL reference
  thumbnail: String|null, // small preview (base64, < 50KB)
  created: ISO String,
  updated: ISO String
}
```

**Tasks Tab:**
- Same task list/board as current, but filtered to `task.project === activeProject.name`
- Can create tasks directly scoped to this project

**Links Tab:**
- Same link cards as current, but filtered to `link.projectId === activeProject.id`
- Can create links directly scoped to this project

### 3. ICON PICKER (60+ SVG Icons)

Grok-style icon picker popup when creating/editing a project.

**Icon categories:**
- **General:** globe, star, heart, flag, bookmark, lightning, fire, target
- **Tech:** code, terminal, database, server, cpu, cloud, wifi, lock
- **Creative:** music, camera, palette, pen, brush, film, mic, headphones
- **Business:** briefcase, chart, dollar, calendar, clock, mail, phone, megaphone
- **Science:** atom, flask, microscope, dna, brain, planet, rocket, telescope
- **People:** user, users, handshake, crown, shield, graduation, baby
- **Objects:** book, document, folder, archive, gift, tools, wrench, key
- **Arrows/Shapes:** compass, layers, grid, cube, circle, triangle, hexagon

All icons are inline SVG (no external dependencies). Each ~200-400 bytes.
Stored as a `const ICONS = {}` map in the JS.

### 4. WHITEBOARD DOCUMENT DRAG

**How it works:**
- Knowledge Base items get a drag handle
- Drag a KB item → drop on whiteboard canvas
- Creates a whiteboard node with:
  - `docRef: kbItemId` — links back to the KB item
  - Title = KB item name
  - Body = KB item description
  - Color = project color
  - Type badge shown on node (PDF, IMG, MD, etc.)
  - If image: shows thumbnail as node background
  - Double-click node → opens the document (inline viewer or file path)

**Node rendering for doc-ref nodes:**
```
+------------------------+
| [PDF] Visual Branding  |  ← type badge + name
|                        |
| Official brand colors  |  ← description
| for all Saturno props  |
+------------------------+
```

For images:
```
+------------------------+
| [IMG] gate-screenshot  |
| +--------------------+ |
| |   [thumbnail]      | |
| +--------------------+ |
+------------------------+
```

### 5. PRE-SEEDED PROJECTS

On first load (or migration from V1), create these projects:

**Project 1: SM App Rebuild**
- Icon: rocket
- Color: #8b5cf6 (purple)
- Instructions: Full developer situation + rebuild timeline
- Living Docs: "Developer Situation & Rebuild Plan" (sections below)
- KB Items: References to rescue docs in iCloud

**Project 2: Saturno Bonus**
- Icon: gift
- Color: #4ade80 (green)
- Instructions: Repo structure, deployment info, shipping plan
- Living Docs: "Deployment & Repo Structure", "Shipping Plan"
- KB Items: gate.html screenshot, design refs

**Project 3: Book (AOC)**
- Icon: book
- Color: #f59e0b (amber)
- Instructions: Victory Belt submission, $20K advance
- Living Docs: ASTRA Kernel (migrated from V1 seed)
- KB Items: References to submission package files

**Project 4: HBS Program**
- Icon: target
- Color: #06b6d4 (cyan)
- Instructions: Handbalancing System, filming, launch

**Project 5: De Aqui a Saturno**
- Icon: heart
- Color: #ec4899 (pink)
- Instructions: Valentine's experience, Vimeo integration

### 6. STORAGE ARCHITECTURE

**localStorage budget:**
- Total available: ~5MB (conservative), 10MB on most browsers
- Current usage: ~34.5KB
- Each project with instructions + 5 KB items + 2 Living Docs: ~15-20KB
- 10 projects fully loaded: ~200KB
- Inline images (base64): budget 500KB per image, ~10 images = 5MB
- **Strategy:** Warn at 4MB. Offer export. Suggest moving large images to file refs.

**Migration from V1:**
- Detect if `S.projects` exists. If not, create it as empty array.
- Move existing Living Docs to "Unassigned" or let user assign.
- Existing tasks with `project` field get matched to new project entities.
- All existing data preserved. Zero data loss.

### 7. DEPLOY CONTROL (Per-Project)

Each project's Instructions tab includes a "Deployment" section at the bottom:
- **Repo:** clickable link to GitHub
- **Live URL:** clickable link to Vercel/GH Pages
- **Last deploy:** date + commit hash
- **Status:** badge (LIVE / BROKEN / LOCAL ONLY)

This is just structured fields in the project's `instructions` markdown. No separate system needed.

---

## IMPLEMENTATION ORDER

1. **State migration** — add `projects`, `knowledgeBase` arrays to S, preserve all V1 data
2. **Project CRUD** — create, edit, delete projects with icon picker
3. **Sidebar projects section** — renders below existing sections
4. **Project detail view** — tabbed layout with Instructions, Living Docs, KB, Tasks, Links
5. **Knowledge Base** — add/edit/delete items, inline text/image, file path refs
6. **Icon picker component** — 60+ SVG icons in a popup grid
7. **Scope filtering** — Tasks, Living Docs, Links filtered by active project
8. **Whiteboard doc drag** — KB items become draggable nodes
9. **Pre-seed projects** — SM App, Saturno Bonus, Book, HBS, De Aqui a Saturno
10. **Developer situation doc** — Full Living Doc with structured sections

---

## DESIGN RULES (LOCKED)

- Same Endel-inspired palette: deep black + mint-green #4ade80
- No external dependencies (zero CDN, zero npm)
- Single HTML file (index.html)
- All data in localStorage
- Mobile-responsive (works on iPad for Gabo's couch sessions)
- No emojis in code
- Glassmorphism for modals/overlays (matching de-aqui-a-saturno patterns)

---

## FILES IN THIS REPO

```
~/dev/astra-command-center/
  index.html                    ← V1 (1,198 lines) — will become V2
  README.md                     ← existing
  astra-v2-specs.md             ← THIS FILE (Claude's technical plan)
  astra-v2-specs-refined.md     ← Gabo's ASTRA Kernel doc (from Downloads)
  astra-v2-log-2026-02-15.md    ← Session log (created at end of session)
  logs/                         ← existing
```

---

## SM APP REBUILD — LIVING DOC CONTENT (Pre-seeded)

### Section 1: Assets You Own
- Domain: saturnomovement.com (admin@saturnomovement.com, Cloudflare, 2FA)
- Stripe: Verified owner, 2FA + authenticator, payouts to your bank
- Vimeo: Company email + card, all videos accessible
- iOS Developer Account: Transferred to admin@saturnomovement.com
- GitHub: sm-app-copy-v1 (your clone of the codebase)
- Cloudflare: Full admin access, secured with 2-step authentication
- Backups: Database and code fully backed up and cloned

### Section 2: What Softzee Still Controls
- Server hosting the live app (AWS, his infrastructure)
- Original GitHub repo (Shajeel/sm-website-app)
- Deployment pipeline (deploys go through his server)
- Android Keystore (.jks) — likely still with him
- Backend environment variables and secrets

### Section 3: Financial Dispute Summary
- Phase 1: $35K agreed, $31.8K paid — COMPLETED
- Website: $5K paid — COMPLETED
- Phase 2: $30K agreed, $12.6K paid — 65% complete (Softzee's claim)
- Softzee claims: $15.7K remaining
- Softzee demands: Payment before full handover
- Gabo's position: ~$10K dispute

### Section 4: App Tech Stack
- Frontend: Next.js (App Router) + React/TypeScript
- Backend: Node.js (Next.js API routes on AWS)
- Payments: Stripe subscriptions ($33.49/mo or $329/yr)
- Video: Vimeo streaming (300+ hours of content)
- Mobile: React Native or native iOS/Android
- Auth: Email, Google Sign-In, Apple Sign-In
- Programs: CF1, CF2, CF3, CF4, Yoga, Rings, Home (6+ programs)
- Features: Calendar, community, workout logging, progress tracking

### Section 5: Rebuild Timeline (Honest Estimate)
| Layer | Gabo + Claude | Junior Dev | Senior Dev | Gabo + Senior |
|-------|---------------|------------|------------|---------------|
| Landing Page | 1-2 weeks | 2-3 weeks | 3-5 days | 3-5 days |
| Web App | 2-3 months | 3-5 months | 4-6 weeks | 4-6 weeks |
| Mobile (PWA) | +2 weeks | +4 weeks | +1 week | +1 week |
| Mobile (Native) | 3-5 months | 4-6 months | 6-10 weeks | 6-10 weeks |
| **Total** | **3-4 months** | **5-8 months** | **2-3 months** | **6-8 weeks** |

Recommendation: PWA first (no App Store drama), native later.

### Section 6: Strategic Recommendations
1. Don't pay remaining $15.7K until full handover (server, keystore, pipeline)
2. Ship bonus.saturnomovement.com FIRST — this is revenue TODAY
3. Landing page can be rebuilt in a weekend with Claude Code
4. Study sm-app-copy-v1: map database schema, plan Supabase migration
5. Web app on managed stack: Vercel + Supabase (not custom AWS)
6. Mobile: PWA first, React Native later

### Section 7: Gabo's Confidence Statement
"1 month ago was one thing, today.... I am confident I can build saturno movement app in a week if I wanted to even if I didn't have the source code, which I do."

---

*This document is the complete technical blueprint for ASTRA V2.*
*Any Claude session can read this and build the upgrade.*
