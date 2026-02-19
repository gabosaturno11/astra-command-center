# ASTRA 5-HOUR AUTONOMOUS EXECUTION SCRIPT
## For any Claude Code session to pick up and run
## Created: Feb 19, 2026

---

## RULES FOR THIS SCRIPT

1. Work in ~/dev/astra-command-center/index.html (single-file app)
2. Commit + push after EVERY phase (Vercel auto-deploys)
3. DO NOT refactor what works — only fix/upgrade what's listed
4. DO NOT add new sections — improve existing ones
5. Test each change visually (check the DOM output makes sense)
6. If stuck on one phase for >20min, skip to next, leave a TODO comment
7. Dark theme only. No emojis in code. Mint green accent (#4ade80).

---

## HOUR 1: TASKS (the weakest daily-use section)

### Phase 1A: Board cards show description (30 min)

**Problem:** Board cards show title only. No description, no context.

**File:** index.html
**Function:** `renderTasks()` around line 1866-1869

Current board card HTML:
```html
<div class="board-card">
  <div class="board-card-title">${title}</div>
  <div class="board-card-meta">${priority} ${project} ${due}</div>
</div>
```

**Changes:**
1. Add `description` field to task object (in `addTask()` ~line 1877)
   - Default: `description: ''`
2. Update board card template to show description preview (first 80 chars, truncated):
   ```html
   <div class="board-card-title">${title}</div>
   ${t.description ? `<div class="board-card-desc">${esc(t.description).substring(0,80)}</div>` : ''}
   <div class="board-card-meta">...</div>
   ```
3. Add CSS for `.board-card-desc`:
   ```css
   .board-card-desc{font-size:10px;color:var(--text-muted);margin-bottom:6px;line-height:1.4;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
   ```
4. Update list view task-row to have an expandable description area:
   - Click task title to expand/collapse description textarea below the row
   - Or: add a small "..." button that opens inline description editor

**Commit:** `feat: task cards show description preview in board view`

### Phase 1B: Task description editing (15 min)

**Changes:**
1. In list view, add a description row that appears on click/expand:
   - Below each task-row, add a hidden `<div class="task-desc-row">` with a textarea
   - Toggle visibility on title click or a expand arrow
2. Update `updateTask()` to handle description field
3. Board card click opens a task detail modal OR inline editor

**Commit:** `feat: inline task description editing in list and board view`

### Phase 1C: Subtasks (15 min)

**Changes:**
1. Add `subtasks: []` to task object (array of `{id, title, done}`)
2. In board card, show subtask progress: `2/5 subtasks`
3. In expanded task detail, show checkbox list of subtasks with add/delete
4. CSS for subtask items inside task detail

**Commit:** `feat: subtasks with progress indicator on board cards`

---

## HOUR 2: CALENDAR + TASK CREATION FLOW

### Phase 2A: Week view (30 min)

**Problem:** Calendar is month-only. Week view is essential for daily planning.

**Function:** `renderCalendar()` around line 1895

**Changes:**
1. Add `calView` variable: `'month'` or `'week'` (default: 'month')
2. Add week/month toggle buttons in calendar header (next to Today button)
3. Week view: 7 columns (Mon-Sun), each showing the full day with time slots or just task pills stacked vertically
4. Week view shows tasks for current week with bigger task pills (title + priority + project)
5. Navigation in week view: prev/next moves by 7 days
6. `calToday()` works in both views

**HTML changes:**
- Add toggle buttons in `#panel-calendar` header area
- Week grid: `.calendar-week-grid` with 7 equal columns, taller rows

**CSS:**
```css
.calendar-week-grid{display:grid;grid-template-columns:repeat(7,1fr);gap:1px;flex:1}
.calendar-week-day{background:var(--bg-surface);padding:8px;min-height:200px;display:flex;flex-direction:column;gap:4px}
.calendar-week-header{font-size:11px;color:var(--text-muted);padding:4px 0;text-align:center;font-weight:600}
.calendar-week-day.today{background:var(--bg-elevated);border:1px solid var(--accent)}
```

**Commit:** `feat: calendar week view with toggle`

### Phase 2B: Click-to-create task from calendar (15 min)

**Changes:**
1. Clicking empty space in a calendar day creates a new task with that date pre-filled
2. In month view: click the day number area
3. In week view: click empty space in day column
4. Uses existing `addTask()` but pre-fills the `due` field

**Commit:** `feat: click calendar day to create task with date`

### Phase 2C: Task detail modal (15 min)

**Problem:** No way to see full task details at a glance.

**Changes:**
1. Add a task detail modal (reuse modal pattern from content-modal)
2. Opens on board card click or double-click in list view
3. Shows: title (editable), description (editable textarea), status, priority, project, due date, subtasks list, created date
4. Save button updates task
5. Delete button with confirm

**Commit:** `feat: task detail modal with full editing`

---

## HOUR 3: LIVING DOCS + WRITER POLISH

### Phase 3A: Fix duplicate spec names (15 min)

**Problem:** Seed data has duplicate names ("Titan Forge" x2, multiple "Untitled Spec")

**Function:** `seedProjects()` / `migrateV2()` — check where specs are created

**Changes:**
1. In `migrateV2()`, check for duplicate spec names before creating
2. Add dedup logic: if spec with same title+projectId exists, skip
3. Clean up any existing duplicates on load (keep the one with more content)

**Commit:** `fix: deduplicate living doc names in seed/migrate`

### Phase 3B: Spec section reordering (15 min)

**Changes:**
1. Add drag-and-drop reordering for spec sections
2. Each section header gets a drag handle (6-dot icon on left)
3. Drop target indicators between sections

**Commit:** `feat: drag-drop reorder spec sections`

### Phase 3C: Writer auto-save indicator + word count goal (15 min)

**Problem:** Writer section works but the Zen Writer has better UX. Bring some Zen Writer features to the inline writer.

**Changes:**
1. Show word count in writer panel header (already exists in Zen but not inline)
2. Add "Saved" / "Unsaved" indicator in writer panel header
3. Auto-save timer (800ms debounce, same as Zen Writer)

**Commit:** `feat: writer panel word count and save indicator`

### Phase 3D: Writer doc list improvements (15 min)

**Changes:**
1. Show last-modified date on each doc in the picker
2. Sort by last-modified (most recent first)
3. Show word count per doc in the list

**Commit:** `feat: writer doc list shows dates and word counts`

---

## HOUR 4: REPOS + PIPELINE + POLISH

### Phase 4A: Repos — static GitHub data (30 min)

**Problem:** Repos section is empty skeleton. `/api/repos` doesn't exist.

**Solution:** Don't build an API. Show static repo data from state, with a manual refresh button that calls GitHub API client-side.

**Changes:**
1. Seed `S.repos` with known repos:
   ```js
   S.repos = [
     { name: 'astra-command-center', url: 'https://github.com/gabosaturno11/astra-command-center', live: 'https://astra-command-center-sigma.vercel.app', status: 'active' },
     { name: 'saturno-bonus', url: 'https://github.com/gabosaturno11/saturno-bonus', live: 'https://saturno-bonus-omega.vercel.app', status: 'active' },
     { name: 'titan-forge', url: 'https://github.com/gabosaturno11/titan-forge', live: 'https://titan-forge-ten.vercel.app', status: 'active' },
     { name: 'de-aqui-a-saturno', url: 'https://github.com/gabosaturno11/de-aqui-a-saturno', live: 'https://de-aqui-a-saturno-jet.vercel.app', status: 'complete' },
     { name: 'nexus-capture', url: 'https://github.com/gabosaturno11/nexus-capture', live: null, status: 'active' },
   ]
   ```
2. Replace `reposRefresh()` to render from `S.repos` (no API call)
3. Each repo card shows: name, live URL link, GitHub link, status badge
4. "Add Repo" button to manually add repos
5. Delete/edit repo capability

**Commit:** `feat: repos section with static repo data and cards`

### Phase 4B: Pipeline UI improvements (15 min)

**Problem:** Pipeline section exists but feels disconnected.

**Changes:**
1. Show pipeline history in a cleaner card layout (not raw JSON)
2. Each card: prompt preview, synthesis preview, date, source badge
3. Click card to expand full synthesis text
4. Copy button on each card

**Commit:** `feat: pipeline history card layout`

### Phase 4C: Mobile responsiveness audit (15 min)

**Changes:**
1. Test at 375px width mentally / check CSS breakpoints
2. Sidebar should collapse to hamburger on mobile
3. Task board should scroll horizontally on mobile
4. Calendar should stack on mobile
5. Fix any overflow issues

**Commit:** `fix: mobile responsive improvements`

---

## HOUR 5: CLOUD SYNC + FINAL POLISH

### Phase 5A: Cloud sync status indicator (15 min)

**Problem:** No visible feedback on whether cloud sync is working.

**Changes:**
1. Add a small cloud icon in the header (near the save indicator)
2. States: synced (green cloud), syncing (spinning), error (red cloud), offline (gray cloud)
3. Click to manually trigger sync
4. Show last sync timestamp on hover

**Commit:** `feat: cloud sync status indicator in header`

### Phase 5B: Fix seedProjects running on every fresh load (15 min)

**Problem:** `seedProjects()` checks `if(S.projects && S.projects.length) return;` — but if cloud load overwrites state, seeds may re-run or conflict.

**Changes:**
1. Add `S._seeded = true` flag after seeding
2. Check flag in addition to projects length
3. Ensure cloudLoad doesn't trigger re-seed

**Commit:** `fix: prevent seed data re-running after cloud load`

### Phase 5C: Keyboard shortcut additions (10 min)

**Changes:**
1. `Cmd+Shift+N` — new task (currently not wired per audit)
2. `Cmd+Shift+T` — new task from anywhere (opens task section + addTask)
3. `Cmd+E` — toggle sidebar
4. Update shortcuts modal with all new shortcuts

**Commit:** `feat: wire remaining keyboard shortcuts`

### Phase 5D: Sidebar mini-dashboard accuracy (10 min)

**Problem:** Sidebar shows task/doc/project counts but they may not update live.

**Changes:**
1. Call `updateSidebarCounts()` after every save()
2. Ensure counts reflect actual state (not stale)

**Commit:** `fix: sidebar counts always reflect current state`

### Phase 5E: Final integration test + cleanup (10 min)

**Checklist:**
- [ ] Switch through all 9 sections — no JS errors
- [ ] Create task, edit description, add subtask, drag on board
- [ ] Calendar month and week view toggle
- [ ] Click calendar day creates task
- [ ] Writer — create doc, type, auto-save, word count
- [ ] Zen Writer — open, type, close, content persists
- [ ] Repos — shows 5 repos with links
- [ ] Cmd+K — search tasks, docs, specs
- [ ] Cloud save — prompts password, saves, shows sync indicator
- [ ] Export all data — works
- [ ] No console errors

**Commit:** `chore: final integration test pass`

---

## EXECUTION ORDER (PRIORITY)

If time runs out, here's what matters most (in order):

1. **Phase 1A** — Board cards show description (biggest daily-use improvement)
2. **Phase 2C** — Task detail modal (unlocks full task management)
3. **Phase 1C** — Subtasks (project management essential)
4. **Phase 2A** — Calendar week view (daily planning)
5. **Phase 4A** — Repos section (currently broken/empty)
6. Everything else

---

## WHAT NOT TO TOUCH

- Whiteboard — 85% functional, leave it
- Knowledge Base — working fine
- Project panel — working fine
- Command palette — 95% functional
- Living Docs structure — working, just fix dupes
- Authentication/API — just locked down, don't change

---

## GIT PROTOCOL

After every phase:
```bash
cd ~/dev/astra-command-center
git add index.html
git commit -m "phase-name: description"
git push
```

Vercel auto-deploys on push to main.
Live URL: https://astra-command-center-sigma.vercel.app

---

*This script was generated from a live audit of ASTRA's current state.*
*All line numbers reference the index.html as of commit 8acc7fc.*
*Any Claude Code session can execute this without asking Gabo anything.*
