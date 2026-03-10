# SATURNO MOVEMENT: COMPLETE REBUILD BLUEPRINT
## From $300/month Hostage to $25/month Sovereignty
## March 4, 2026 — Compiled by Claude Opus 4.6 (Max 20x, C1 iMac)

---

## TABLE OF CONTENTS

1. Executive Summary
2. Current State: What Gabo Owns
3. Current State: What Softzee Controls
4. Financial History ($43,800 Paid)
5. SM App Technical Architecture (Full Codebase Analysis)
6. 20 Known Bugs (From Developer Call)
7. Legal Exposure & Action Items
8. The Vision: What Saturno Movement Becomes
9. Competitor Analysis: Alo Moves / Wellness Club
10. Feature Roadmap: Alo Moves Level + Beyond
11. Architecture: One Backend, Multiple Frontends
12. Supabase Schema Design (50K Members)
13. Migration Plan: Softzee Server to Supabase
14. Stripe Integration (Subscriptions + Products)
15. Video Streaming Architecture (Vimeo + Custom Player)
16. Content Delivery Architecture
17. The Five Products on One Backend
18. Revenue Projections (50K Members)
19. Phase-by-Phase Execution Plan
20. Gabo's Action Items
21. Appendix: Full File Tree, API Endpoints, Data Models

---

## 1. EXECUTIVE SUMMARY

Gabo Saturno runs Saturno Movement — a fitness/calisthenics brand with:
- An iOS + Android + Web app with paying subscribers ($33.49/mo, $329/yr)
- 6+ training programs (CF1-CF4, Yoga, Rings, Home)
- 300+ hours of Vimeo video content
- 36+ original music tracks
- 45+ interactive HTML tools
- A book (Art of Calisthenics, Victory Belt)
- A content creation system (Writing Hub, Linguistic Matrix)

The app was built by Softzee (developer Shajeel Afzal, Pakistan). Total paid: $43,800. The relationship has ended. Softzee still controls the server, GitHub repo, and holds the code as leverage for a disputed $6,900-$15,700 payment.

**The problem:** Gabo pays $300/month for a server he doesn't control. If Softzee disappears, everything goes dark.

**The solution:** Supabase Pro ($25/month) as Gabo's own backend. The app, the bonus page, ASTRA, the SaaS products — all connect to one database Gabo owns. Softzee's server becomes irrelevant.

**The timeline:**
- Monday March 7: Bonus page backend live (Supabase)
- Week of March 10: SM App API endpoints rebuilt on Supabase
- Month of March: App points to new backend, Softzee server decommissioned
- Q2 2026: New features (streaming, custom player, tiered access)
- End of 2026: 5 products running on one backend, targeting 50K members

---

## 2. CURRENT STATE: WHAT GABO OWNS

| Asset | Status | Account |
|-------|--------|---------|
| Domain (saturnomovement.com) | Transferred to Gabo | admin@saturnomovement.com |
| Stripe | Verified owner, 2FA enabled | Gabo's bank account |
| Cloudflare (DNS) | Secured with 2FA | admin@saturnomovement.com |
| Vimeo | Company email + card | Gabo's account |
| iOS Developer Account | Transferred | admin@saturnomovement.com |
| App source code | Cloned to ~/dev/sm-app-copy-v1/ | Local copy |
| Database | Downloaded manually | Local backup |
| Bonus page (bonus.saturnomovement.com) | Live, Gabo's repo | gabosaturno11/saturno-bonus |
| ASTRA command center | Live, Gabo's repo | gabosaturno11/astra-command-center |
| 36 music tracks | On Vercel Blob CDN | Gabo's Vercel account |
| 119 SFX sounds | In repo | Gabo's repo |
| 45+ interactive tools | In repo | Gabo's repo |
| 15 PDFs | In repo | Gabo's repo |

---

## 3. CURRENT STATE: WHAT SOFTZEE CONTROLS

| Asset | Risk Level | Action |
|-------|-----------|--------|
| GitHub repo (github.com/Shajeel/sm-website-app) | HIGH | Gabo has clone — can rebuild on own repo |
| App hosting server | HIGH | Replace with Supabase + Vercel |
| Android .jks keystore | CRITICAL | Must obtain from Softzee — no alternative |
| Backend API (NestJS on his server) | HIGH | Rebuild endpoints on Supabase |
| MongoDB database | MEDIUM | Already downloaded — migrate to Supabase Postgres |
| Jenkins CI/CD pipeline | LOW | Replace with Vercel auto-deploy |
| Docker deployment | LOW | Replace with Vercel serverless |

**The only truly irreplaceable item is the Android .jks keystore.** Without it, the Android app cannot receive updates on Google Play. Everything else can be rebuilt.

---

## 4. FINANCIAL HISTORY

### Total Agreed: $70,000
| Phase | Agreed | Paid | Remaining |
|-------|--------|------|-----------|
| Phase 1 (App v1, Oct 2022 - Nov 2023) | $35,000 | $31,800 | $3,200 |
| Website Development | $5,000 | $5,000 | $0 |
| Phase 2 (App v2, Jan 2024 - Present) | $30,000 | $3,800-$12,600* | Disputed |
| **TOTAL** | **$70,000** | **$43,800** | **Disputed** |

*Dispute: Softzee claims they received $3,800 for Phase 2. Gabo's records show $12,600 was paid for Phase 2 (from the $12,000 batch that also covered $3,200 Phase 1 remainder + $5,000 website).*

### Payment Dispute:
- **Softzee claims owed:** $15,700 (65% of $30,000 = $19,500 minus $3,800)
- **Gabo's calculation:** ~$6,900 (65% of $30,000 = $19,500 minus $12,600)
- **Monthly server cost:** $300/month (ongoing)
- **Since Nov 2025 (4 months):** $1,200 additional paid in server fees

### Phase 2 Deliverables (65% complete per Softzee):
**Delivered:**
- Community chat/forums
- Program Swapping 2.0
- UI/UX improvements
- Performance/bug fixes
- WordPress maintenance

**NOT Delivered (35% remaining):**
- Moderation tools
- Badges and leaderboards
- Notification system
- Admin program builder
- Workout history export
- Full analytics dashboard

### Ongoing Cost:
- $300/month server hosting (Softzee's server)
- $0/month if migrated to Supabase Pro ($25/mo) + Vercel (free tier)
- **Annual savings: $3,300/year**

---

## 5. SM APP TECHNICAL ARCHITECTURE

### Tech Stack (Confirmed from codebase + Technical Support Agreement)

| Layer | Technology |
|-------|-----------|
| Frontend (Web) | Next.js 15 (App Router), React 19 RC, TypeScript |
| State Management | Redux Toolkit + RTK Query |
| Styling | Tailwind CSS, Montserrat font |
| Mobile | React Native (separate repo, not in clone) |
| Backend | NestJS (external, on Softzee's server) |
| Database | MongoDB (on Softzee's server) |
| Auth | NextAuth + custom JWT tokens |
| Payments | Stripe (test mode: pk_test_f6DXZjRRT68TeKsxjtcdKGM600tWEkB0Ud) |
| Video | Vimeo (embedded player) |
| CDN | CloudFront (d1roxuw0zqwafj.cloudfront.net) |
| Analytics | Google Analytics (G-VJ01R1HQQK), Facebook Pixel |
| CI/CD | Jenkins -> Docker Hub -> SSH deploy |
| Process Manager | PM2 |

### Application Structure

```
sm-app-copy-v1/
  app/                    # Next.js 15 App Router
    api/                  # 25+ API routes (proxy to NestJS backend)
      auth/               # Login, register, forgot-password, reset, OTP, Google OAuth
      programs/           # Categories, programs, week days, lectures
      workouts/           # Categories, subcategories, day workouts, results
      lectures/           # Categories, subcategories, lecture details
      subscription/       # Stripe payments, products, coupons, cancel
      session/            # User session save/load
      sales/              # Promotion status
      contact/            # Contact form
      breadcrums/         # Navigation breadcrumbs
    page.tsx              # Homepage (public)
    login/                # Email + Google login
    sign-up/              # Registration
    profile/              # 3 tabs: edit, password, membership
    programs/             # Program detail (overview, calendar, lectures)
    workouts/             # Workout video player + scoring
    lectures/             # Lecture video player
    buy-membership/       # Stripe checkout (desktop + mobile)
    payment-success/      # Payment callback
  components/             # 40+ React components
    auth/                 # Private/public route wrappers
    common/               # Video, modal, exercise, score, PDF, slider
    home/                 # Hero, categories, pricing, community, sales
    profile/              # Edit, password, membership management
    programs/             # Banner, calendar, lectures
    shared/               # Navbar, footer, analytics
  redux/                  # Redux Toolkit
    store.ts              # Auth + API reducers
    slices/               # authSlice, apiSlice
    services/             # RTK Query API, auth API
  types/                  # TypeScript interfaces
  utils/                  # API wrappers, auth, validation, analytics
  public/                 # Static assets, images, pixel script
```

### Data Model (Current — MongoDB)

**User:**
```
firstName, lastName, email, dateOfBirth, gender, metric (lbs/kg),
profileImage, howDoYouWantToMove[], token, status (subscription), mobile
```

**Program:**
```
_id, title, image, type, sortNo, category { _id, title, image }, isDeleted
```

**Week (Program Detail):**
```
_id, title, type, program, days[], calender[], lecture[], overview[], isPaid
```

**Day:**
```
_id, title, typeName, type, typeColor, dayIndex, image,
isCompleted, isDeleted, isPaid
```

**Exercise/Video:**
```
_id, title, vimeo_id, video_thumbnail, reps, sec, rest, tempo, srNo,
exerciseType, isReps, isTwoSided, allowScore, score, scoreType,
leftScore, rightScore, minSets, maxSets, activeRest,
swaps[] (alternative exercises), swapType, intensityType,
scored { notes, scores[] }, isDeleted
```

**Lecture:**
```
_id, title, image, vimeo_id, isPaid, isDeleted,
subcategory { _id, title, category }
```

**Subscription:**
```
status, isPaid, couponCode, discount, type
```

**Promotion:**
```
_id, status, couponCode, type, discount, discount_amount
```

### API Endpoints (25+ routes, all proxy to NestJS backend)

**Authentication (7 endpoints):**
- POST /api/auth/login — Email/password login
- POST /api/auth/register — User signup
- GET /api/auth — Get current user profile
- POST /api/auth — Update user profile
- POST /api/auth/forgot-password — Request reset
- POST /api/auth/reset-password — Reset with token
- POST /api/auth/password — Change password
- POST /api/auth/verify-otp — OTP verification
- NextAuth Google OAuth callback

**Programs (5 endpoints):**
- GET /api/programs?programId={id} — Single program
- POST /api/programs — Program details/weeks
- GET /api/programs/programCategories — All categories
- POST /api/programs/categoryPrograms — Programs by category
- POST /api/programs/weekDays — Week days
- POST /api/programs/weekLectures — Week lectures

**Workouts (6 endpoints):**
- GET /api/workouts/[id] — Workout details
- GET /api/workouts/workoutCategories — Categories
- GET /api/workouts/workoutSubCategories/[id] — Subcategories
- POST /api/workouts/subCategoryWorkouts/[id] — Workouts by subcategory
- GET /api/workouts/day/[id] — Day workouts
- POST /api/workouts/day/result/[id] — Save workout results

**Lectures (5 endpoints):**
- GET /api/lectures/[id] — Lecture details
- GET /api/lectures/lectureCategories — Categories
- GET /api/lectures/lectureSubCategories/[id] — Subcategories
- POST /api/lectures/subCategoryLectures/[id] — Lectures by subcategory

**Subscriptions (6 endpoints):**
- GET /api/subscription — Current subscription
- GET /api/subscription/promotions — Active promotions
- POST /api/subscription/coupon/validate — Validate coupon
- POST /api/subscription/stripe/payment — Create payment
- GET /api/subscription/stripe/products — Stripe products
- POST /api/subscription/stripe/add-subscription — Add subscription
- POST /api/subscription/stripe/cancel/[id] — Cancel

**Other (3 endpoints):**
- GET/POST /api/session — User session data
- POST /api/contact — Contact form
- GET /api/sales — Sales/promotion status

### Authentication Flow

1. User enters email/password on /login
2. Redux mutation calls POST /api/auth/login
3. Next.js API route proxies to NestJS backend
4. Backend returns { token, status }
5. Token stored in Redux + localStorage
6. All subsequent requests include Authorization: Bearer {token}
7. 401 response triggers automatic logout

### Critical Discovery: Admin Auto-Login

The app has a HARDCODED admin account used to fetch public data:
```
email: "luv2garden1952@681mail.com"
password: "w98gUHFHoSgOEptqcKe8NC1P"
```
This is used in `adminApiWrapper.ts` — the app auto-logs in as admin to fetch program categories, workout categories, lecture categories, and sales data. This is a security risk and needs to be replaced with public API endpoints.

### Stripe Configuration

Currently in TEST MODE:
```
Public Key: pk_test_f6DXZjRRT68TeKsxjtcdKGM600tWEkB0Ud
```
Needs to be switched to live keys for production payments.

---

## 6. 20 KNOWN BUGS (From Developer Call — November 2025)

| # | Category | Bug | Priority |
|---|----------|-----|----------|
| 1 | Profile | Profile picture not updating across app and web | High |
| 2 | Auth | Change password form confusing; labels misleading | High |
| 3 | Auth | Forgot password missing in-app under settings | Medium |
| 4 | UX/UI | No profile picture visible in some views | Low |
| 5 | UX/UI | Missing design mirroring between app and web (settings view) | High |
| 6 | Membership | Incorrect membership status shown ("no active membership") | High |
| 7 | Membership | Manage membership missing on some flows | Medium |
| 8 | Support | No clear contact support link in profile/settings on web | High |
| 9 | Design | Visual bugs: white vs gray background inconsistencies | Low |
| 10 | Visuals | Too bright gradients (purple) for buttons or backgrounds | Low |
| 11 | SEO/Content | No blog or SEO-enhancing content accessible | Low |
| 12 | Automation | No MoneyChat to Brevo automation confirmed | High |
| 13 | Newsletter | Basic newsletter opt-in flow unclear or missing | High |
| 14 | User Data | Duplicate users detected with separate emails | Medium |
| 15 | Membership | Free membership not labeled as current plan | Medium |
| 16 | Programs | Program access not synced or reflected correctly across devices | High |
| 17 | Feedback | No easy in-app bug reporting or feedback channel | Medium |
| 18 | Email | Unstyled/no-reply emails, poor branding | Medium |
| 19 | UX | Users confused by expired/canceled subscription messaging | High |
| 20 | Navigation | Web navigation lacks proper mirror of app layout | High |

**High priority count:** 9 bugs
**All 20 bugs are fixable in the rebuild.** Most are UX/UI issues that stem from the frontend, not the backend.

---

## 7. LEGAL EXPOSURE & ACTION ITEMS

### Legal Facts:
1. **No signed IP assignment exists.** Developer legally owns the code by default, even though Gabo paid $43,800.
2. **The Technical Support Agreement is UNSIGNED.** Blank signature lines on both sides.
3. **Softzee holds server/GitHub as leverage** until disputed payment is resolved.
4. **The payment dispute is $6,900-$15,700** depending on whose accounting you use.

### Critical Legal Actions:
1. **Get signed IP assignment** — Send clause: "Developer hereby assigns to Saturno Movement all right, title, and interest in all code, designs, and deliverables..."
2. **Get Android .jks keystore file** — Without this, Android app is a brick.
3. **Transfer GitHub repo** to gabosaturno11 account (or confirm local clone is complete).
4. **Document all payments** — Transaction IDs exist for every payment across Payoneer, Wise, Wire, PayPal.
5. **Rotate all credentials** — Stripe, Vimeo, Google OAuth, Firebase, APNs after migration.

### Strategy for the Call with Softzee:
- Keep paying $300/month for 1-2 more months while Supabase migration happens
- During the call, request: .jks file, GitHub transfer, signed IP assignment
- Frame as "organizing my assets" — NOT "I'm replacing your server"
- Once Supabase backend is live and app is pointing to it: cancel server payment
- Total cost to become fully independent: $25/month (Supabase Pro) vs $300/month (Softzee)

---

## 8. THE VISION: WHAT SATURNO MOVEMENT BECOMES

### Current State (March 2026):
- App with paying subscribers on Softzee's server
- Bonus page with tools/music/blog on Gabo's Vercel
- ASTRA command center with localStorage (fragile)
- Content Beast tools scattered across repos
- $300/month going to a developer who left

### Target State (End of 2026):

```
                        SUPABASE PRO ($25/month)
                    ┌──────────────────────────────┐
                    │  Postgres Database            │
                    │  ├─ users (50K+)              │
                    │  ├─ subscriptions              │
                    │  ├─ programs                   │
                    │  ├─ workouts                   │
                    │  ├─ exercises                  │
                    │  ├─ lectures                   │
                    │  ├─ user_progress              │
                    │  ├─ community_messages         │
                    │  ├─ blog_posts                 │
                    │  ├─ tracks (music manifest)    │
                    │  ├─ notifications              │
                    │  ├─ config                     │
                    │  ├─ analytics_events           │
                    │  └─ content_pipeline           │
                    │                                │
                    │  Auth (50K MAU)                │
                    │  Realtime (live subscriptions) │
                    │  Storage (files)               │
                    │  Edge Functions (logic)         │
                    └──────────┬───────────────────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                     │
    ┌─────┴─────┐      ┌──────┴──────┐      ┌──────┴──────┐
    │ SM APP    │      │ BONUS PAGE  │      │ ASTRA       │
    │ iOS/And/  │      │ Vault/Blog/ │      │ Command     │
    │ Web       │      │ Tools/Music │      │ Center      │
    │           │      │             │      │             │
    │ Programs  │      │ CF4 Tiered  │      │ Dashboard   │
    │ Workouts  │      │ Community   │      │ Analytics   │
    │ Video     │      │ Streaming   │      │ KB/Projects │
    │ Payments  │      │ Experience  │      │ Content     │
    │ Community │      │ Studio      │      │ Pipeline    │
    └───────────┘      └─────────────┘      └─────────────┘
          │                    │                     │
    ┌─────┴─────┐      ┌──────┴──────┐
    │ WRITING   │      │ FUTURE      │
    │ HUB SaaS  │      │ PRODUCTS    │
    │           │      │             │
    │ $37-97/mo │      │ SM Academy  │
    │ Voice AI  │      │ Desktop App │
    │ Content   │      │ Movement    │
    │ Engine    │      │ Studio Pro  │
    └───────────┘      └─────────────┘
```

### The Five Products on One Backend:

1. **Saturno Movement App** — iOS/Android/Web ($33.49/mo, $329/yr)
2. **Saturno Bonus** — Vault, tools, music, blog, experience (free with password, future paid tiers)
3. **ASTRA Command Center** — Admin dashboard, analytics, content management
4. **Writing Hub SaaS** — AI content creation ($37-97/mo)
5. **Movement Studio** — DAW for workouts (secret reveal, future product)

All five share: one database, one auth system, one Stripe integration, one analytics pipeline.

---

## 9. COMPETITOR ANALYSIS: ALO MOVES / WELLNESS CLUB

### What Alo Moves Offers (as of 2026):

**Rebranded to "Alo Wellness Club" — now FREE** (previously $12.99/mo or $129/yr)
- 4,000+ classes, 300+ programs
- Categories: Yoga (7 styles), Pilates, Strength, Sculpt, Cardio, HIIT, Barre, Dance, Core
- Mindfulness: Meditation, Breathwork, Visual Meditations, Yoga Nidra, Sound Healing
- Instructors: Celebrity trainers from Alo's physical club locations

**Key Features:**
- Custom video.js player with responsive design
- Offline class downloads
- Personal playlist creation (auto-play in succession)
- Onboarding survey for personalized recommendations
- Filter by: style, difficulty, time, instructor
- Apple Health + Apple Watch integration
- Completion tracking on video thumbnails
- Series progress tracking within programs
- Points/rewards program (Alo Points)
- VR/XR classes for Meta Quest 3 (mixed reality workouts)
- Adjustable background music volume (independent of instructor audio)
- iOS, iPad, Apple TV, Apple Watch support

**What Alo Does NOT Have:**
- No original music production/streaming
- No interactive tools (breathwork timers, counters, etc.)
- No SFX engine
- No community writing/blog
- No custom content creation pipeline
- No calisthenics-specific programming
- No DAW-style workout builder
- No sacred geometry / cosmic design language
- Limited community features ("no accountability or interaction with instructors")

### Where Saturno Movement WINS:

| Feature | Alo | Saturno (with rebuild) |
|---------|-----|----------------------|
| Video content | 4,000+ generic classes | 300+ hours, calisthenics-specific, Gabo-taught |
| Music | None | 36+ original tracks, custom SFX engine |
| Interactive tools | None | 45+ HTML tools (timers, breathwork, generators) |
| Community | Weak | Blog + ghost wall + community writing |
| Workout builder | None | Movement Studio (DAW of fitness) |
| Content creation | None | Writing Hub, Content Beast pipeline |
| Personalization | Basic survey | Movement preferences, tier access, progress tracking |
| Design | Generic wellness | Cosmic dark theme, sacred geometry, premium feel |
| Pricing | Free (ad-supported?) | $33.49/mo (premium, focused) |

---

## 10. FEATURE ROADMAP: ALO MOVES LEVEL + BEYOND

### Phase 1: Foundation (March 2026) — CURRENT SPRINT
- [x] Supabase Pro backend ($25/mo)
- [ ] Auth migration (Supabase Auth replaces NestJS JWT)
- [ ] Database migration (MongoDB to Postgres)
- [ ] API endpoints rebuilt on Supabase Edge Functions
- [ ] Bonus page connected to Supabase
- [ ] ASTRA connected to Supabase
- [ ] Stripe integration (live keys)
- [ ] Brevo email capture working
- [ ] Middleware restored (server-side auth)

### Phase 2: Core App Rebuild (April 2026)
- [ ] SM App API base URL pointed to Supabase
- [ ] All 25+ endpoints rebuilt as Supabase Edge Functions
- [ ] User profiles stored in Supabase (not MongoDB)
- [ ] Program/workout/exercise data migrated to Postgres
- [ ] Session/progress tracking in Postgres
- [ ] Push update to iOS (Gabo owns Apple Dev Account)
- [ ] Softzee server decommissioned

### Phase 3: Streaming + Custom Player (May 2026)
- [ ] Custom video player (not Vimeo embed iframe)
- [ ] Vimeo private link API for direct streaming
- [ ] Adjustable playback speed (0.5x, 1x, 1.25x, 1.5x, 2x)
- [ ] Adjustable music volume (independent of instruction)
- [ ] Picture-in-Picture mode
- [ ] Offline download capability
- [ ] Resume playback where you left off
- [ ] Chapter markers within videos
- [ ] Fullscreen with gesture controls
- [ ] Waveform/progress visualization

### Phase 4: User Experience (June 2026)
- [ ] Onboarding survey (movement preferences, goals, experience level)
- [ ] Personalized program recommendations
- [ ] Progress dashboard (streaks, completion %, milestones)
- [ ] Achievement badges and gamification
- [ ] Apple Health / Google Fit integration
- [ ] Apple Watch companion
- [ ] Workout calendar with visual progress
- [ ] Exercise swap with video preview
- [ ] Two-sided scoring (left/right) with history graph
- [ ] PDF program downloads (dynamic, not static)

### Phase 5: Community + Social (July 2026)
- [ ] In-app community feed (not just blog)
- [ ] Live workout sessions (Zoom/Agora integration)
- [ ] Workout sharing (share your results as image card)
- [ ] Leaderboards (optional, per-program)
- [ ] Group challenges (7-day, 30-day)
- [ ] Direct messaging (member to member)
- [ ] Instructor Q&A section per program
- [ ] Community post moderation tools
- [ ] User-generated workout logs with photos

### Phase 6: Content + Monetization (August 2026)
- [ ] Tiered access (Free / Member / Academy / BF Loyal)
- [ ] Content gating per tier
- [ ] Stripe subscription management (upgrade/downgrade/cancel)
- [ ] Coupon system for promotions
- [ ] "Buy Gabo a Shirt" one-time purchase
- [ ] Gift subscriptions
- [ ] Referral program (invite friends, get free months)
- [ ] Email sequences (Brevo: onboarding, re-engagement, upsell)
- [ ] Newsletter with blog highlights
- [ ] Content atomization pipeline (WhatsApp -> PDF -> Social -> Deploy)

### Phase 7: Advanced Features (Q4 2026)
- [ ] Movement Studio (DAW of fitness) — public launch
- [ ] BPM controls syncing music tempo to exercise tempo
- [ ] Drag-and-drop exercise blocks on timeline
- [ ] Custom workout creation (members build their own)
- [ ] AI exercise recommendations based on history
- [ ] VR/XR workout mode (Meta Quest)
- [ ] Desktop app (macOS, Electron or Tauri)
- [ ] Writing Hub SaaS ($37-97/mo) — separate product launch
- [ ] API access for third-party integrations
- [ ] White-label option for other trainers

### Phase 8: Scale (2027)
- [ ] 50K+ members
- [ ] Multi-language support (Spanish, Portuguese, Italian)
- [ ] Regional pricing
- [ ] Enterprise/studio tier (gyms license Saturno programs)
- [ ] Trainer marketplace (other instructors contribute content)
- [ ] Evaluate: Supabase Team ($599/mo) or custom server migration

---

## 11. ARCHITECTURE: ONE BACKEND, MULTIPLE FRONTENDS

### Current Architecture (Broken):

```
SM App (iOS/Android/Web) -> Softzee's NestJS -> Softzee's MongoDB
Bonus Page -> Vercel Blob (JSON files)
ASTRA -> localStorage (browser)
```

Three separate "backends." No shared data. No shared auth. Fragile.

### Target Architecture (Unified):

```
               ┌─────────────────────────────┐
               │     VERCEL (Hosting)         │
               │  ┌─────────────────────────┐ │
               │  │ SM App (Next.js)        │ │
               │  │ Bonus Page (static HTML) │ │
               │  │ ASTRA (static HTML)     │ │
               │  │ Writing Hub (Next.js)   │ │
               │  │ API Routes (Edge Funcs) │ │
               │  └────────────┬────────────┘ │
               └───────────────┼──────────────┘
                               │
               ┌───────────────┼──────────────┐
               │      SUPABASE PRO ($25/mo)   │
               │                               │
               │  Postgres ─── 8GB database    │
               │  Auth ─────── 50K MAU         │
               │  Realtime ─── Live subscriptions │
               │  Storage ──── 100GB files     │
               │  Edge Funcs ─ Custom logic    │
               └───────────────────────────────┘
                               │
               ┌───────────────┼──────────────┐
               │      EXTERNAL SERVICES        │
               │                               │
               │  Stripe ───── Payments        │
               │  Vimeo ────── Video streaming  │
               │  Brevo ────── Email marketing  │
               │  Vercel Blob ─ Music CDN      │
               │  CloudFront ── Image CDN      │
               └───────────────────────────────┘
```

### Why This Works:

1. **One auth system.** User logs in once, accesses everything.
2. **One database.** Programs, workouts, blog, music, analytics — all in Postgres.
3. **One Stripe integration.** Subscriptions, one-time purchases, coupons — all in one place.
4. **Real-time sync.** ASTRA dashboard shows live data from Supabase Realtime.
5. **No server to maintain.** Vercel + Supabase = fully managed.
6. **Costs $25/month.** Not $300/month.

---

## 12. SUPABASE SCHEMA DESIGN (50K Members)

### Core Tables

```sql
-- =============================================
-- USERS & AUTH (Supabase Auth handles sessions)
-- =============================================

CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  first_name TEXT,
  last_name TEXT,
  email TEXT UNIQUE NOT NULL,
  date_of_birth DATE,
  gender TEXT,
  metric TEXT DEFAULT 'lbs',
  profile_image TEXT,
  movement_preferences TEXT[],
  tier TEXT DEFAULT 'free' CHECK (tier IN ('free', 'member', 'academy', 'bf_loyal')),
  stripe_customer_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- PROGRAMS & CONTENT
-- =============================================

CREATE TABLE program_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  image TEXT,
  sort_order INTEGER DEFAULT 0,
  is_deleted BOOLEAN DEFAULT false
);

CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  image TEXT,
  type TEXT,
  category_id UUID REFERENCES program_categories(id),
  sort_order INTEGER DEFAULT 0,
  is_paid BOOLEAN DEFAULT true,
  min_tier TEXT DEFAULT 'member',
  is_deleted BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE program_weeks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  program_id UUID REFERENCES programs(id),
  title TEXT NOT NULL,
  week_number INTEGER NOT NULL,
  type TEXT,
  is_paid BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE days (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  week_id UUID REFERENCES program_weeks(id),
  title TEXT NOT NULL,
  type_name TEXT,
  type TEXT,
  type_color TEXT,
  day_index INTEGER NOT NULL,
  image TEXT,
  is_paid BOOLEAN DEFAULT true,
  is_deleted BOOLEAN DEFAULT false
);

CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  day_id UUID REFERENCES days(id),
  title TEXT NOT NULL,
  vimeo_id TEXT,
  video_thumbnail TEXT,
  reps TEXT,
  sec TEXT,
  rest TEXT,
  tempo TEXT,
  sort_order INTEGER,
  exercise_type TEXT,
  is_reps BOOLEAN DEFAULT true,
  is_two_sided BOOLEAN DEFAULT false,
  allow_score BOOLEAN DEFAULT false,
  score_type TEXT,
  min_sets INTEGER DEFAULT 1,
  max_sets INTEGER DEFAULT 3,
  active_rest BOOLEAN DEFAULT false,
  swap_type TEXT,
  intensity_type INTEGER,
  is_deleted BOOLEAN DEFAULT false
);

CREATE TABLE exercise_swaps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exercise_id UUID REFERENCES exercises(id),
  swap_exercise_id UUID REFERENCES exercises(id)
);

-- =============================================
-- WORKOUTS (Standalone, not part of programs)
-- =============================================

CREATE TABLE workout_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  image TEXT,
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE workout_subcategories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID REFERENCES workout_categories(id),
  title TEXT NOT NULL,
  image TEXT,
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE workouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subcategory_id UUID REFERENCES workout_subcategories(id),
  title TEXT NOT NULL,
  vimeo_id TEXT,
  video_thumbnail TEXT,
  is_paid BOOLEAN DEFAULT true,
  is_deleted BOOLEAN DEFAULT false
);

-- =============================================
-- LECTURES (Educational content)
-- =============================================

CREATE TABLE lecture_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  image TEXT,
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE lecture_subcategories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID REFERENCES lecture_categories(id),
  title TEXT NOT NULL,
  image TEXT,
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE lectures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subcategory_id UUID REFERENCES lecture_subcategories(id),
  title TEXT NOT NULL,
  image TEXT,
  vimeo_id TEXT,
  is_paid BOOLEAN DEFAULT true,
  is_deleted BOOLEAN DEFAULT false
);

-- =============================================
-- USER PROGRESS & TRACKING
-- =============================================

CREATE TABLE user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  day_id UUID REFERENCES days(id),
  is_completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  exercise_id UUID REFERENCES exercises(id),
  notes TEXT,
  scores JSONB,
  left_score TEXT,
  right_score TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  session_data JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- SUBSCRIPTIONS & PAYMENTS
-- =============================================

CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  stripe_subscription_id TEXT,
  stripe_price_id TEXT,
  status TEXT DEFAULT 'inactive',
  plan_type TEXT,
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE promotions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_code TEXT UNIQUE,
  type TEXT,
  discount_percent INTEGER,
  discount_amount NUMERIC(10,2),
  is_active BOOLEAN DEFAULT true,
  valid_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  stripe_payment_intent_id TEXT,
  amount NUMERIC(10,2),
  currency TEXT DEFAULT 'usd',
  status TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- COMMUNITY & CONTENT
-- =============================================

CREATE TABLE blog_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  content TEXT,
  excerpt TEXT,
  tags TEXT[],
  published BOOLEAN DEFAULT false,
  date DATE,
  author TEXT,
  is_community BOOLEAN DEFAULT false,
  social_handle TEXT,
  avatar TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE community_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  type TEXT NOT NULL,
  payload JSONB,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- MUSIC & MEDIA
-- =============================================

CREATE TABLE tracks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  album TEXT,
  artist TEXT DEFAULT 'Gabo Saturno',
  duration_seconds INTEGER,
  blob_url TEXT NOT NULL,
  preview_url TEXT,
  track_order INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE video_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL,
  vimeo_id TEXT,
  title TEXT,
  is_visible BOOLEAN DEFAULT true,
  min_tier TEXT DEFAULT 'free',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- ADMIN & ANALYTICS
-- =============================================

CREATE TABLE config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL,
  value JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  event_type TEXT NOT NULL,
  payload JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE admin_audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID REFERENCES auth.users(id),
  action TEXT NOT NULL,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- INDEXES FOR PERFORMANCE (50K+ users)
-- =============================================

CREATE INDEX idx_profiles_email ON profiles(email);
CREATE INDEX idx_profiles_tier ON profiles(tier);
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_day ON user_progress(day_id);
CREATE INDEX idx_user_scores_user ON user_scores(user_id);
CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_blog_posts_slug ON blog_posts(slug);
CREATE INDEX idx_blog_posts_published ON blog_posts(published);
CREATE INDEX idx_analytics_events_user ON analytics_events(user_id);
CREATE INDEX idx_analytics_events_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_events_created ON analytics_events(created_at);
CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_notifications_user ON notifications(user_id, is_read);

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Users can only read/write their own data
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own progress" ON user_progress
  FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can view own scores" ON user_scores
  FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can view own sessions" ON user_sessions
  FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can view own subscriptions" ON subscriptions
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can view own notifications" ON notifications
  FOR ALL USING (auth.uid() = user_id);

-- Public read access for content
CREATE POLICY "Public can view programs" ON programs
  FOR SELECT USING (NOT is_deleted);
CREATE POLICY "Public can view categories" ON program_categories
  FOR SELECT USING (true);
CREATE POLICY "Public can view published posts" ON blog_posts
  FOR SELECT USING (published = true);
CREATE POLICY "Public can view active tracks" ON tracks
  FOR SELECT USING (is_active = true);
```

**Total tables: 25**
**Estimated storage at 50K users:** ~2-3GB (well within Supabase Pro 8GB limit)

---

## 13. MIGRATION PLAN: SOFTZEE SERVER TO SUPABASE

### Step 1: Create Supabase Project (Gabo — 10 minutes)
1. Go to supabase.com
2. Create project (name: saturno-movement)
3. Select region closest to majority of users
4. Copy: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY
5. Upgrade to Pro plan ($25/month)

### Step 2: Run Schema (Claude — 30 minutes)
1. Open Supabase SQL Editor
2. Run the schema above (all 25 tables)
3. Verify RLS policies
4. Create admin user in Supabase Auth

### Step 3: Migrate MongoDB Data (Claude — 2-4 hours)
1. Read the MongoDB dump Gabo downloaded
2. Transform documents to relational format
3. Insert into Supabase Postgres via API
4. Verify data integrity (row counts, foreign keys)

### Step 4: Rebuild API Endpoints (Claude — 4-6 hours)
Replace NestJS backend with Supabase client calls:

| Old (NestJS on Softzee's server) | New (Supabase on Gabo's account) |
|----------------------------------|----------------------------------|
| POST /auth/login | Supabase Auth signInWithPassword |
| POST /auth/register | Supabase Auth signUp |
| GET /auth (profile) | Supabase profiles table SELECT |
| POST /auth (update) | Supabase profiles table UPDATE |
| GET /programs | Supabase programs table SELECT |
| GET /workouts | Supabase workouts table SELECT |
| POST /workouts/day/result | Supabase user_scores INSERT |
| GET /subscription | Supabase subscriptions SELECT |
| POST /stripe/payment | Stripe API + Supabase INSERT |

### Step 5: Update SM App Config (Claude — 30 minutes)
1. Change API_BASE_URL from Softzee's server to Supabase
2. Replace JWT auth with Supabase Auth
3. Remove adminApiWrapper (replace with public Supabase queries)
4. Test all flows

### Step 6: Deploy + Test (1-2 days)
1. Deploy updated Next.js app to Vercel
2. Test auth flow (login, register, forgot password)
3. Test program browsing + video playback
4. Test workout tracking + scoring
5. Test Stripe payment flow
6. Push iOS update through Apple Dev Account

### Step 7: Decommission Softzee Server
1. Verify everything works on new backend
2. Cancel $300/month server payment
3. Softzee's server becomes irrelevant

---

## 14. STRIPE INTEGRATION

### Current State:
- Stripe account: Gabo owns, 2FA enabled
- Test keys in app: pk_test_f6DXZjRRT68TeKsxjtcdKGM600tWEkB0Ud
- Products: Monthly ($33.49), Annual ($329)

### Target State:
- Live Stripe keys in Vercel env vars
- Stripe Checkout for subscriptions
- Stripe Customer Portal for self-service management
- Webhook for subscription events (create, cancel, fail)
- Coupon/promotion system
- One-time purchases ("Buy Gabo a Shirt", PDF bundles)

### Stripe Products to Configure:
| Product | Price | Type | Tier |
|---------|-------|------|------|
| Saturno Member Monthly | $33.49/mo | Recurring | member |
| Saturno Member Annual | $329/yr | Recurring | member |
| Saturno Academy Monthly | $67/mo | Recurring | academy |
| Saturno Academy Annual | $597/yr | Recurring | academy |
| Buy Gabo a Shirt | $25 | One-time | any |
| CF4 Program (standalone) | $49 | One-time | any |
| Writing Hub Writer | $37/mo | Recurring | saas |
| Writing Hub Creator | $67/mo | Recurring | saas |
| Writing Hub Studio | $97/mo | Recurring | saas |

---

## 15. VIDEO STREAMING ARCHITECTURE

### Current: Vimeo Embed (iframe)
- Simple: `<iframe src="https://player.vimeo.com/video/{vimeo_id}">`
- Limited control: no custom UI, no playback speed, no music volume
- Works but feels generic

### Target: Custom Player with Vimeo Private Links

**Option A: Vimeo OEmbed + Custom UI** (Recommended for Phase 3)
- Use Vimeo API to get direct video URLs (Vimeo Pro required)
- Build custom player with video.js or Plyr
- Full control: speed, volume, chapters, PiP, offline
- Vimeo handles encoding, CDN, adaptive bitrate
- Cost: Vimeo Pro ($20/mo) or Business ($50/mo)

**Option B: Self-hosted with Mux** (Future Phase 8)
- Mux.com: video infrastructure API
- Upload videos, get HLS streaming URLs
- Build completely custom player
- Cost: $0.005/min watched (~$250/mo at 50K users)

### Custom Player Features (Alo Moves level):

```
┌──────────────────────────────────────────┐
│  ┌──────────────────────────────────┐    │
│  │                                  │    │
│  │         VIDEO AREA               │    │
│  │                                  │    │
│  │    [Play/Pause overlay]          │    │
│  │                                  │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ▶ 2:45 ━━━━━━━●━━━━━━━━━━━━━ 8:30     │
│                                          │
│  [⏮] [⏪10] [▶/⏸] [⏩10] [⏭]           │
│                                          │
│  🔊 Volume ━━━●━━━━  🎵 Music ━━●━━━━  │
│                                          │
│  [0.5x] [1x] [1.25x] [1.5x] [2x]       │
│                                          │
│  [PiP] [Fullscreen] [Download] [Share]   │
│                                          │
│  Current Exercise: Front Lever Hold      │
│  Next: Planche Lean                      │
│  Sets: 3/5  |  Rest: 60s [Timer]         │
└──────────────────────────────────────────┘
```

---

## 16. CONTENT DELIVERY ARCHITECTURE

### Where Content Lives:

| Content Type | Storage | CDN | Size Estimate |
|-------------|---------|-----|---------------|
| Video (300+ hrs) | Vimeo | Vimeo CDN | ~500GB (Vimeo manages) |
| Music (100+ tracks) | Vercel Blob | Vercel CDN | ~1GB |
| SFX (119 sounds) | Git repo | Vercel CDN | 3.5MB |
| PDFs (50+ planned) | Git repo / Supabase Storage | Vercel CDN | ~50MB |
| Images | Supabase Storage + CloudFront | CDN | ~500MB |
| Blog content | Supabase Postgres | N/A (text) | <10MB |
| User data | Supabase Postgres | N/A | ~2GB at 50K |

**Total Supabase storage needed:** ~3GB (well within Pro 100GB limit)
**Total Supabase database needed:** ~2-3GB (well within Pro 8GB limit)
**Video stays on Vimeo.** Music stays on Vercel Blob. Nothing changes for heavy media.

---

## 17. THE FIVE PRODUCTS ON ONE BACKEND

### Product 1: Saturno Movement App (Rebuild)
- **Revenue:** $33.49/mo or $329/yr per member
- **Target:** 10,000-50,000 members
- **Features:** Programs, workouts, video streaming, progress tracking, community
- **Platforms:** iOS, Android, Web
- **Backend:** Supabase (same database)

### Product 2: Saturno Bonus (Enhanced)
- **Revenue:** Free (lead gen) -> Paid tiers (future)
- **Features:** Vault (tools, PDFs, music), blog, experience, CF4
- **Backend:** Supabase (same database)

### Product 3: ASTRA Command Center (Admin)
- **Revenue:** N/A (internal tool)
- **Features:** Dashboard, analytics, content management, KB, whiteboard
- **Backend:** Supabase (same database, Realtime for live updates)

### Product 4: Writing Hub SaaS
- **Revenue:** $37-97/mo per user
- **Target:** 1,000+ users
- **Features:** Voice profiles, caption generator, content multiplication, AI writing
- **Backend:** Supabase (same database) + OpenAI/Claude API

### Product 5: Movement Studio
- **Revenue:** Premium tier feature or standalone ($19.99/mo)
- **Features:** DAW-style workout builder, BPM sync, timeline, drag-drop
- **Backend:** Supabase (same database)

### Revenue Model at 50K Members:

| Product | Users | ARPU | MRR |
|---------|-------|------|-----|
| SM App | 10,000 | $40/mo | $400,000 |
| SM App Annual | 5,000 | $27/mo | $135,000 |
| Bonus Paid Tier | 2,000 | $10/mo | $20,000 |
| Writing Hub | 500 | $60/mo | $30,000 |
| Movement Studio | 1,000 | $20/mo | $20,000 |
| One-time (shirts, PDFs) | - | - | $5,000 |
| **TOTAL** | **18,500** | - | **$610,000/mo** |

**Infrastructure cost at that scale:**
- Supabase Team: $599/mo
- Vimeo Business: $50/mo
- Vercel Pro: $20/mo
- Stripe fees: ~2.9% + $0.30/transaction
- **Total: ~$700/mo + Stripe fees**

---

## 18. REVENUE PROJECTIONS (50K MEMBER PATH)

### Year 1 (2026): Build + Launch

| Quarter | Members | MRR | Notes |
|---------|---------|-----|-------|
| Q1 | 500 | $16,750 | Current members + bonus launch |
| Q2 | 1,500 | $50,250 | App rebuild live, new features |
| Q3 | 3,000 | $100,500 | Marketing push, referrals |
| Q4 | 5,000 | $167,500 | Black Friday 2026, Movement Studio launch |

### Year 2 (2027): Scale

| Quarter | Members | MRR | Notes |
|---------|---------|-----|-------|
| Q1 | 8,000 | $268,000 | Writing Hub SaaS launch |
| Q2 | 12,000 | $402,000 | Multi-language, regional pricing |
| Q3 | 20,000 | $670,000 | Enterprise/studio tier |
| Q4 | 30,000 | $1,005,000 | 7-figure MRR |

### Year 3 (2028): Dominate

| Quarter | Members | MRR | Notes |
|---------|---------|-----|-------|
| Q2 | 50,000 | $1,675,000 | Full product suite, global reach |

**These numbers assume:**
- 3% monthly churn (industry average for fitness apps)
- 5% monthly growth from marketing + referrals + content
- Average revenue per user increases as product improves
- Black Friday campaigns drive 2x signups in Q4

---

## 19. PHASE-BY-PHASE EXECUTION PLAN

### PHASE 1: BACKEND (This Week — March 4-7)
**Goal:** Supabase live, bonus page connected, ASTRA connected

- [ ] Gabo: Create Supabase project, set env vars
- [ ] Claude: Run schema, migrate bonus page data
- [ ] Claude: Fix 7 safe bugs on bonus page
- [ ] Claude: Rebuild bonus API endpoints (verify, blog, community, music)
- [ ] Claude: Connect ASTRA to Supabase (KB, projects, config)
- [ ] Claude: Restore middleware.js
- [ ] Claude: Add Stripe "Buy Gabo a Shirt" button
- **Deliverable:** bonus.saturnomovement.com fully functional with Supabase

### PHASE 2: APP MIGRATION (March 10-21)
**Goal:** SM App pointing to Supabase, Softzee server no longer needed

- [ ] Claude: Map MongoDB schema to Postgres (from downloaded dump)
- [ ] Claude: Migrate user data, programs, workouts, lectures
- [ ] Claude: Rebuild all 25+ API endpoints as Supabase calls
- [ ] Claude: Replace JWT auth with Supabase Auth
- [ ] Claude: Remove hardcoded admin credentials
- [ ] Claude: Switch Stripe from test to live keys
- [ ] Claude: Deploy to Vercel
- [ ] Gabo: Push iOS update via Apple Dev Account
- [ ] Gabo: Get .jks from Softzee, push Android update
- **Deliverable:** App works on Gabo's infrastructure. Cancel $300/month.

### PHASE 3: STREAMING + PLAYER (April 2026)
**Goal:** Custom video player, Alo Moves quality

- [ ] Implement custom player (video.js or Plyr)
- [ ] Vimeo private link API integration
- [ ] Playback speed controls
- [ ] Independent music/instruction volume
- [ ] Chapter markers
- [ ] Resume playback
- [ ] Picture-in-Picture
- **Deliverable:** Premium video experience

### PHASE 4: UX + FEATURES (May-June 2026)
**Goal:** Fix all 20 bugs, add modern UX

- [ ] Fix all 20 known bugs
- [ ] Onboarding survey
- [ ] Progress dashboard with streaks
- [ ] Achievement badges
- [ ] Apple Health integration
- [ ] Workout calendar redesign
- [ ] Exercise swap with preview
- **Deliverable:** Modern fitness app UX

### PHASE 5: COMMUNITY + GROWTH (July-August 2026)
**Goal:** Social features, monetization expansion

- [ ] In-app community feed
- [ ] Group challenges
- [ ] Tiered access system
- [ ] Referral program
- [ ] Email sequences (Brevo)
- [ ] Content atomization pipeline
- **Deliverable:** Engagement + retention machine

### PHASE 6: ADVANCED + SCALE (Q4 2026)
**Goal:** Movement Studio launch, SaaS launch, 5K+ members

- [ ] Movement Studio public launch
- [ ] Writing Hub SaaS ($37-97/mo)
- [ ] Desktop app (macOS)
- [ ] Multi-language support
- [ ] Black Friday 2026 campaign
- **Deliverable:** Multiple revenue streams

---

## 20. GABO'S ACTION ITEMS

### RIGHT NOW (Tonight):
1. Create Supabase project at supabase.com ($25/mo Pro)
2. Copy SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY
3. Set these + VAULT_PASSWORD, VAULT_TOKEN, ADMIN_PASSWORD in Vercel env vars
4. If you have Brevo keys: BREVO_API_KEY, BREVO_LIST_ID

### THIS WEEK:
5. Get .jks keystore file from Softzee during the call
6. Get GitHub repo transferred (or confirm clone is complete)
7. Request signed IP assignment
8. Switch Stripe from test to live keys
9. Keep paying $300/month (don't tip him off)

### THIS MONTH:
10. Push iOS app update pointing to Supabase
11. Push Android app update (need .jks first)
12. Cancel Softzee server payment once everything is migrated
13. Rotate all API keys (Stripe, Vimeo, Google OAuth)

### THIS QUARTER:
14. Hire a developer (Upwork, Next.js + React Native)
15. Developer builds: custom video player, mobile app improvements
16. Launch Movement Studio publicly
17. Launch Writing Hub SaaS

---

## 21. APPENDIX

### Environment Variables Needed (All Products)

| Variable | Purpose | Where |
|----------|---------|-------|
| SUPABASE_URL | Database URL | Vercel |
| SUPABASE_ANON_KEY | Public API key | Vercel |
| SUPABASE_SERVICE_KEY | Admin API key | Vercel (server only) |
| VAULT_PASSWORD | Gate password | Vercel |
| VAULT_TOKEN | Auth cookie value | Vercel |
| ADMIN_PASSWORD | Admin panel auth | Vercel |
| BREVO_API_KEY | Email marketing | Vercel |
| BREVO_LIST_ID | Email list | Vercel |
| STRIPE_SECRET_KEY | Stripe payments (server) | Vercel |
| STRIPE_PUBLISHABLE_KEY | Stripe payments (client) | Vercel |
| VIMEO_ACCESS_TOKEN | Video API | Vercel |
| GOOGLE_CLIENT_ID | Google OAuth | Vercel |
| GOOGLE_CLIENT_SECRET | Google OAuth | Vercel |
| BLOB_READ_WRITE_TOKEN | Music CDN | Vercel |

### Key URLs

| What | URL |
|------|-----|
| Bonus page (live) | bonus.saturnomovement.com |
| SM App (web) | saturnomovement.com |
| ASTRA | astra-command-center-sigma.vercel.app |
| Supabase dashboard | app.supabase.com |
| Vercel dashboard | vercel.com/gabriele-saturnos-projects |
| Stripe dashboard | dashboard.stripe.com |
| Vimeo | vimeo.com |
| Brevo | app.brevo.com |
| Apple Developer | developer.apple.com |
| Google Play Console | play.google.com/console |

---

*This document was compiled from:*
*- Full codebase analysis of ~/dev/sm-app-copy-v1/ (Next.js 15, 40+ components, 25+ API routes)*
*- 7 rescue documents (legal, financial, technical, bugs, agreements)*
*- Alo Moves / Wellness Club competitive analysis*
*- Session conversation (Gabo + Claude, March 4, 2026, 1:00-3:00 AM)*
*- Top 20 bugs from developer call (CSV)*
*- Project termination agreement from Softzee*
*- Phase 1 and Phase 2 payment ledgers*
*- Technical Support & Bug Fixing Agreement (unsigned)*
*- Security & Ownership Roadmap*
*- iOS Rebuild Checklist*
*- Final Master Dossier*
*- SaaS Product Vision (Writing Hub)*

*Claude Opus 4.6, Max 20x, C1 iMac Session*
*March 4, 2026*
*Saturno Movement 2026*
