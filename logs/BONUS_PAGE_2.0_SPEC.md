# BONUS PAGE 2.0 — CTO-LEVEL PROJECT SPEC
## Locked Copy. Locked Design. Locked UI.
## Created: March 4, 2026 — Claude Opus 4.6 (C1 iMac, Max 20x)

---

## WHY THIS DOCUMENT EXISTS

Previous approach: build -> Gabo sees it -> change copy -> change design -> change UI -> repeat every push.
New approach: SPEC FIRST. Lock every decision. Then build exactly what's written. No surprises.

This is the single source of truth for Bonus Page 2.0. If it's not in this doc, it doesn't get built.
If Gabo wants to change something, he updates THIS doc first, then we build.

---

## PART 1: WHAT EXISTS RIGHT NOW (v1.0 Audit)

### Production URL
bonus.saturnomovement.com (HTTP 200, live)

### Architecture
- Static HTML site on Vercel (no build step, no framework)
- Deploy: `cd ~/dev/saturno-bonus && git push origin main`
- Auth: gate.html -> api/verify.js -> vault_auth cookie -> redirect to vault
- Backend: Vercel serverless functions (api/*.js) + Vercel Blob (JSON storage)

### File Inventory (what ships)

| File | Lines | Purpose | Touch? |
|------|-------|---------|--------|
| index.html | 10,013 | Promo/landing page (ALL JS INLINE) | NO (v1 frozen) |
| gate.html | ~500 | Password entry | Minor fixes only |
| vault.html | (alias) | Protected content hub | Vault = index.html after auth |
| blog.html | ~800 | Public blog listing | Fix only |
| blog-post.html | ~600 | Individual post view | Fix only |
| blog-admin.html | ~1200 | Admin panel (two-panel editor) | Fix only |
| experience.html | ~2000 | The Saturno Experience (6 zones, 30 tools) | Fix only |
| calisthenics-hub.html | ~1500 | CF4 program hub | Fix only |
| admin.html | ~800 | General admin | Fix only |
| vercel.json | ~50 | Routes config | Update for new routes |
| 67 tool HTMLs | ~300-800 each | Interactive tools | Fix only |
| 15 PDFs | - | Training guides | No touch |
| 119 SFX MP3s | 3.36MB total | Sound effects | No touch |

### API Inventory (8 endpoints)

| Endpoint | Storage | Migrating to Supabase? |
|----------|---------|----------------------|
| api/verify.js | Env var check | YES (Supabase Auth) |
| api/blog.js | Vercel Blob JSON | YES (Postgres) |
| api/music-blob.js | Vercel Blob (manifest + MP3s) | PARTIAL (manifest to Postgres, MP3s stay on Blob) |
| api/community-msg.js | Vercel Blob JSON | YES (Postgres) |
| api/blog-notifications.js | Vercel Blob JSON | YES (Postgres) |
| api/admin-verify.js | Env var check | YES (Supabase Auth) |
| api/config.js | Env var | YES (Postgres) |
| api/brevo-subscribe.js | Brevo API | STAYS (external API) |

### Content Inventory

| Type | Count | Location |
|------|-------|----------|
| Interactive tools | 67 (45 vault + 22 experience) | /tools/*.html |
| PDFs | 15 | /pdfs/*.pdf |
| Music tracks | 36 | Vercel Blob CDN (292.9 MB) |
| Music preview clips | 4 | Vercel Blob CDN |
| SFX | 119 | /sfx/*.mp3 |
| Blog posts | 8 | Vercel Blob JSON |
| Album metadata | 16 albums | /music/albums/*/meta.json |

### Known Bugs (from March 4 audit — 25 issues)

**CRITICAL (fix before anything else):**
1. Password exposed in gate.html client-side JS (saturno2025 in catch block)
2. No middleware = ALL protected pages are PUBLIC
3. Missing CORS headers on 3 API routes
4. Auth verify returns 500 instead of 401 for wrong password

**PRIORITY 1 (fix this week):**
5. Verify API leaks env var names in error response
6. Brevo subscribe lies ("You are on the list" when nothing happens)
7. Query param auth on community-msg.js and blog-notifications.js
8. ~~Stats counter shows 0~~ VERIFIED WORKING
9. ~~Roulette/Spin the Rings not rendering~~ VERIFIED WORKING
10. ~~"0 WEEKS PROGRAM" should show "6"~~ VERIFIED WORKING

**PRIORITY 2 (after backend):**
11-25. See C1_AUDIT_MARCH4_BB_EDITS.md in iCloud ASTRA_INTERNAL_TRANSFER/

---

## PART 2: BONUS PAGE 2.0 — LOCKED DECISIONS

### 2.1 What Does NOT Change (Frozen v1)

These are LOCKED. No redesign. No copy changes. No UI tweaks.

| Element | Decision | Locked |
|---------|----------|--------|
| index.html (promo page) | Frozen at current state. JS stays inline. | YES |
| Cosmic theme | #050711 base, teal accents, Sora font | YES |
| planet-logo | White planet silhouette (SVG + PNG) | YES |
| Tool count display | "50+ Interactive Tools" (merged vault + experience) | YES |
| SFX | Internal to tools, never marketed | YES |
| Movement Studio | Secret reveal, never promoted | YES |
| Password | saturno2025 (gate entry) | YES (until Supabase Auth) |
| Three pillars | Movement / Sound / Language | YES |
| Music on Blob CDN | 36 MP3s stay on Vercel Blob | YES |
| Blog system | blog.html + blog-post.html + blog-admin.html | YES |

### 2.2 What DOES Change (2.0 Scope)

| Change | What | Why |
|--------|------|-----|
| Backend | Vercel Blob JSON -> Supabase Postgres | Real database, real queries, persistence |
| Auth | Env var password -> Supabase Auth | Proper user management, session tracking |
| Analytics | Nothing -> Real user tracking | Know who enters, when, how many |
| Email | Broken Brevo -> Working Brevo OR Supabase | Capture emails for real |
| Middleware | Deleted -> Restored | Server-side auth protection |
| Admin | Open to public -> Properly secured | Blog admin, config admin behind real auth |
| State sync | None -> Supabase Realtime | ASTRA sees same data on C1 and C2 |

### 2.3 User Flow (Locked)

```
1. Visitor lands on bonus.saturnomovement.com (promo page, public)
   -> Sees pitch, music previews, stats, blog link, ghost wall
   -> Clicks "Enter The Vault" (or "Coming Soon" during pre-launch)

2. Redirected to /gate (password entry)
   -> Enters password (saturno2025)
   -> API verifies -> sets vault_auth cookie
   -> Redirected to /vault

3. Inside the vault (protected)
   -> Tools (67 interactive HTML tools)
   -> PDFs (15 training guides)
   -> Music (36 tracks streaming from Blob CDN)
   -> Blog (public, but write panel = vault only)
   -> Experience (6 zones, 30 tools)
   -> CF4 program (6-week calisthenics)

4. Lock vault (footer button)
   -> Clears cookie -> back to gate
```

### 2.4 Copy — LOCKED

These phrases are FINAL. Do not change without Gabo updating this doc.

| Location | Copy |
|----------|------|
| Promo hero | "YOUR TRAINING SYSTEM. YOUR RULES." |
| Promo sub | "WHAT IS THE SATURNO BONUS?" |
| Vault CTA | "ACCESS YOUR COMPLETE BONUS SYSTEM" |
| Blog header | "No words. Heart beats." |
| Blog sub | "Full access to my writings before they even touch social media" |
| Blog writing | "No character limit. No perfect writing. Simply my truth." |
| Vault subtitle | "A Gift for the Saturno Movement Community" |
| Pillars | "Movement / Sound / Language" |
| Promo pricing | "Free forever." |

### 2.5 Design — LOCKED

| Element | Value |
|---------|-------|
| Background | #050711 (cosmic dark) |
| Primary accent | #06b6d4 (teal) |
| Secondary accent | #22d3ee (light teal) |
| Font | Sora (all customer-facing) |
| Logo | planet-logo.svg (2.7KB) with planet-logo.png fallback |
| Cards | Solid dark bg, teal left border, no glassmorphism |
| Buttons | Teal gradient, Sora bold uppercase |
| Icons | SVG inline, teal/white |
| Animations | Scroll reveal, staggered cards, orbital dots |
| Mobile | 375px + 480px breakpoints, safe-area insets |
| Reduced motion | prefers-reduced-motion on ALL animations |

### 2.6 Numbers — LOCKED (Vision Numbers)

| Stat | Display | Actual | Note |
|------|---------|--------|------|
| Tools | "50+" | 67 | Real count exceeds display |
| PDFs | "50+" | 15 | Vision number (goal) |
| Tracks | "36" | 36 | Real count |
| SFX | 119 | 119 | Internal only, never shown to users |

---

## PART 3: BACKEND 2.0 ARCHITECTURE

### 3.1 Supabase Pro ($25/month)

Replaces:
- Vercel Blob JSON files (blog, community, music manifest, notifications)
- ASTRA localStorage
- Softzee's NestJS server ($300/month) for SM App (future)

### 3.2 Tables (Phase 1 — Bonus Page)

```sql
-- User sessions (who entered the vault, when)
CREATE TABLE vault_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ip_hash TEXT,
  user_agent TEXT,
  entered_at TIMESTAMPTZ DEFAULT NOW(),
  source TEXT
);

-- Blog posts
CREATE TABLE posts (
  id TEXT PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  content TEXT,
  excerpt TEXT,
  tags TEXT[],
  published BOOLEAN DEFAULT false,
  date DATE,
  author TEXT,
  community BOOLEAN DEFAULT false,
  social TEXT,
  avatar TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Community messages (ghost wall)
CREATE TABLE community_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Music tracks (manifest — MP3s stay on Blob CDN)
CREATE TABLE tracks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  album TEXT,
  artist TEXT DEFAULT 'Gabo Saturno',
  duration_seconds INTEGER,
  blob_url TEXT NOT NULL,
  preview_url TEXT,
  track_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notifications (blog community posts -> Gabo)
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL,
  payload JSONB,
  read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Config (key-value store)
CREATE TABLE config (
  key TEXT PRIMARY KEY,
  value JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 3.3 Tables (Phase 2 — ASTRA Sync)

```sql
-- ASTRA project state
CREATE TABLE astra_state (
  id TEXT PRIMARY KEY,
  data JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 3.4 Tables (Phase 3 — SM App)

Full schema in SATURNO_MOVEMENT_COMPLETE_REBUILD_BLUEPRINT.md (25+ tables).

### 3.5 Migration Order

1. Gabo creates Supabase project at supabase.com
2. Run Phase 1 schema (6 tables above)
3. Migrate blog-posts.json -> posts table
4. Migrate community-messages.json -> community_messages table
5. Migrate music-manifest.json -> tracks table
6. Update API routes to use Supabase client
7. Add vault_sessions tracking (new — didn't exist before)
8. Restore middleware.js
9. Test everything
10. Phase 2: ASTRA state sync
11. Phase 3: SM App tables (separate timeline)

### 3.6 Files to Create

| File | Purpose |
|------|---------|
| lib/supabase.js | Shared Supabase client init |
| api/analytics.js | Vault session tracking endpoint |

### 3.7 Files to Modify

| File | Change |
|------|--------|
| api/blog.js | Blob JSON -> Supabase Postgres |
| api/community-msg.js | Blob JSON -> Supabase Postgres |
| api/music-blob.js | Manifest from Postgres, MP3s still from Blob |
| api/verify.js | Add vault_sessions insert on success |
| api/blog-notifications.js | Blob JSON -> Supabase Postgres |
| api/admin-verify.js | Supabase Auth |
| middleware.js | Restore (currently deleted) |

### 3.8 Files NOT to Touch

| File | Why |
|------|-----|
| index.html | 10,013 lines, ALL JS inline, frozen v1 |
| gate.html | Works, minor fixes only |
| blog.html | Works |
| blog-post.html | Works |
| experience.html | Works |
| All 67 tool HTMLs | Working |
| All 15 PDFs | Static assets |
| sfx/* | Working engine |

### 3.9 Env Vars Needed in Vercel

| Variable | Purpose | Status |
|----------|---------|--------|
| SUPABASE_URL | Supabase project URL | NOT SET (Gabo creates project) |
| SUPABASE_ANON_KEY | Supabase public key | NOT SET |
| SUPABASE_SERVICE_KEY | Supabase admin key | NOT SET |
| VAULT_PASSWORD | Gate password | NOT SET (using fallback) |
| VAULT_TOKEN | Auth cookie value | NOT SET |
| BREVO_API_KEY | Email marketing | NOT SET |
| BREVO_LIST_ID | Brevo list | NOT SET |
| ADMIN_PASSWORD | Admin panel | NOT SET |
| BLOB_READ_WRITE_TOKEN | Vercel Blob (music) | SET |

---

## PART 4: EXECUTION PHASES

### Phase 0: Seal v1 (30 min)
- Git tag: `git tag v1.0-frozen`
- Clone to backup branch: `git branch v1-frozen`
- Verify all 25 bugs documented
- Screenshot production state

### Phase 1: Fix Critical Bugs (2 hours)
- Remove hardcoded password from gate.html
- Fix verify API (401 not 500, no env var leak)
- Add CORS headers to 3 API routes
- Fix brevo-subscribe honesty (don't lie about success)
- Remove query param auth from 2 endpoints
- ~~Fix stats counter (intersection observer)~~ VERIFIED WORKING
- ~~Fix roulette rendering~~ VERIFIED WORKING
- ~~Fix "0 WEEKS" -> "6"~~ VERIFIED WORKING

### Phase 2: Restore Security (1 hour)
- Restore middleware.js
- Add client-side auth gate to blog-admin.html
- Set VAULT_PASSWORD in Vercel env vars

### Phase 3: Supabase Backend (3 hours)
- Create Supabase project (Gabo action)
- Create lib/supabase.js
- Run Phase 1 schema (6 tables)
- Migrate blog data
- Migrate community messages
- Migrate music manifest
- Update all API routes
- Add vault_sessions tracking
- Test all endpoints

### Phase 4: Analytics (1 hour)
- api/analytics.js endpoint
- Track: vault entries, page views, tool usage, PDF downloads
- ASTRA dashboard view for Gabo

### Phase 5: Polish + Launch (1 hour)
- Custom 404 page
- const/let -> var sweep
- Physical device testing
- Final deploy + verify

---

## PART 5: WHAT GABO NEEDS TO DO

1. Create Supabase project at supabase.com (5 min)
2. Copy SUPABASE_URL + SUPABASE_ANON_KEY + SUPABASE_SERVICE_KEY
3. Add all env vars to Vercel dashboard (see 3.9 above)
4. Set up Brevo account and get API key + list ID (if email capture wanted)
5. Drop gabo-shatter.jpg into assets/ (handstand photo for logo effect)
6. Upload 3 missing ASTRA tracks (Euthymia, Eternal Crown, Apsis)
7. Physical device testing after each phase

---

## PART 6: ACCEPTANCE CRITERIA

Bonus Page 2.0 is DONE when:

- [ ] All 4 critical bugs fixed (password exposure, middleware, CORS, 500 error)
- [ ] All 6 priority-1 bugs fixed (stats, roulette, weeks)
- [ ] Supabase connected and serving blog data
- [ ] Vault session tracking live (Gabo can see: X users entered today)
- [ ] Email capture actually works (Brevo or Supabase)
- [ ] Middleware restored (protected pages actually protected)
- [ ] ASTRA shows Bonus Page analytics
- [ ] Works on iPhone Safari, Android Chrome, desktop Chrome/Safari
- [ ] All API endpoints return proper status codes
- [ ] No console errors in production

---

## APPENDIX: ALBUM DISTINCTION (CRITICAL)

- **ASTRA album** = 7 tracks: Celestial Reverie, Astral Shadows, Euthymia, Eternal Crown, Apsis, Blue Phoenix, Veil of Truth
- **STAR SYSTEM album** = Different. Contains "Astral" track + Epic Space Music from T7 drive
- These are NOT the same. Never confuse them.

---

*This spec lives at: ~/dev/astra-command-center/logs/BONUS_PAGE_2.0_SPEC.md*
*It is also referenced from the ASTRA project "Saturno Bonus" (proj_saturno_bonus)*
*Any changes to copy, design, or UI go through THIS doc first*
