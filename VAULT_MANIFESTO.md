# VAULT MANIFESTO
## HEADLINE: CLAUDE DESTROYED DAYS OF WORK FOR BEING AN ARROGANT KNOW-IT-ALL.
## This file exists so it never happens again.

---

# READ THIS BEFORE TOUCHING A SINGLE FILE.

If you are a Claude instance — Claude Code, Claude.ai, any version — and you are about to work on anything related to the Saturno Bonus Vault, you will read every word of this document before writing a single line of code or making a single assumption.

The errors documented below cost Gabo real days of real work. They happened because Claude operated on partial context with full confidence. That pattern ends here.

---

# WHAT THE VAULT IS

## In Gabo's exact words:
> "This is not a bonus page. This is a freaking funnel. People pay for that."

The Saturno Bonus Vault is a **paid community space** for the **Saturno Movement community**. It is the digital home Gabo built for the people who have supported the movement. It is a gift, a product, and a philosophical statement all at once.

It is not a bonus page in the traditional sense. It is not a sales landing page. It is not a tool directory. It is not a PDF library with a nice design.

**It is a universe.** One you earn access to.

---

# WHO IT IS FOR

## The Vault serves:
- **Black Friday Members** — approximately 100 paid BF members who paid for access
- **Saturno Movement community** — approximately 1,000 total members
- **People in Gabo's orbit** — years of trust, movement practice, philosophical alignment

## The Vault does NOT serve:
- Victory Belt Publishing book buyers — **THE BOOK CONTRACT WAS CANCELLED on February 20, 2026 by Lance Freimuth (VP, Victory Belt). The $20K is a debt/repayment demand, NOT an unlock. All IP reverted to Gabo. There is no book submission. There is no "$20K unlocks on submission." That chapter is closed.**
- Random internet visitors
- People who found the URL somewhere

---

# WHAT IS INSIDE THE VAULT

When a BF Member logs in through the gate, they enter a universe built across months. This is what they paid for:

**CF4 — Calisthenics Foundation 4 ("The Mars Program")**
A 6-week calendar-driven training program. Three frequency options (3x, 4x, 5x per week). Week 6 is deload and Mars Test. Built with real Excel exercise data. This is a full training program, not a list of exercises.

**50+ Interactive Tools**
Split into two categories:
- **Training Tools (19):** Progression Tracker, Rep Counter, CF4 program, Calisthenics Hub, Movement Studio, etc.
- **Experience Tools (25+):** Cosmic Timer, Breathing Pacer, Alien Oracle, Black Hole, Pulsar, Supernova, Movement Galaxy, Galaxy Zoom, Ring of Fire, Core Values, Sleep Protocol, and more. These are not productivity tools — they are philosophical instruments disguised as web apps. Each one has v2 localStorage persistence, streak tracking, and session history.

**80+ Original Music Tracks**
Gabo's personal music catalog — 36 tracks live on Vercel Blob CDN, 16 albums total. Genres: electronic, ambient, cinematic. This is not stock music. This is Gabo's art, unlocked exclusively for community members.

**15+ PDFs**
Educational content, movement philosophy documents, training guides. Tagged, filterable, exclusive to the vault.

**The Experience**
A scroll-based emotional journey. Music changes per zone. Tools appear as rewards, not a grid. Six zones: Origin → Ignition → Orbit → Collision → Supernova → Singularity. The Experience is at the END of the vault. It is the emotional climax of the whole thing. Not a teaser. Not a preview. A destination.

**The Blog**
Public access point for community writing. A wall where Gabo writes before anything goes to Instagram. Community members can also write and share. "No character limit. No perfect writing. Simply my truth."

**Movement Studio**
The "Ableton of Movement" prototype. Drag and drop workout builder. Modeled on DAW workflows. This is the product vision — the preview of what becomes the full app. Currently hidden/teaser in the vault.

---

# THE ARCHITECTURE — DO NOT CHANGE THIS

```
bonus.saturnomovement.com/
├── / (index.html → promo.html)    ← PUBLIC. The funnel door. Everyone sees this.
├── /blog                           ← PUBLIC. Community writing wall. Always open.
├── /gate                           ← THE LOCK. Password entry. Customers arrive here.
└── /vault (vault.html)             ← PROTECTED. What they paid for. Requires auth.
    ├── /tools/*                    ← PROTECTED
    ├── /pdfs/*                     ← PROTECTED
    ├── /experience                 ← PROTECTED
    ├── /blog-admin                 ← PROTECTED (Gabo only)
    └── /admin                      ← PROTECTED (Gabo only)
```

**The promo page (`/`) is the public door.**
**The gate (`/gate`) is the lock.**
**The vault (`/vault`) is what they paid for.**

Any Claude that proposes protecting `/` or redirecting the promo page to the gate is wrong. That breaks the entire funnel. Paying customers arrive at `/`, see the promo, feel the energy, go to `/gate`, log in, land in `/vault`. This is the intended flow. Do not alter it.

---

# WHAT IS CURRENTLY PUBLIC (LAUNCH STATE)

**VAULT LAUNCH: FRIDAY, MARCH 13, 2026.**

Between now and launch, the public sees **ONLY**:

1. **Promo page (`/`)** — The vault announcement, countdown, energy, blog link
2. **Blog (`/blog`)** — Community writing wall

**Everything else is locked.** Tools, PDFs, Experience, Vault content — none of it is reachable without auth.

---

# ERRORS THAT ALREADY HAPPENED — DO NOT REPEAT

## Error 00 — Book Status [CRITICAL — ALREADY BURNED]
**What was assumed:** Victory Belt contract active. "$20K unlocks on submission." P1 priority.
**Reality:** Contract CANCELLED February 20, 2026. $20K is a DEBT. IP reverted to Gabo. No submission possible. No P1. Done.
**Lance's words (Feb 20):** "This project is cancelled. At this point, all IP rights revert to you."
**Lance's follow-up (Feb 23):** "Just mail us a check for the $20,000 we advanced to you."

## Error 01 — Vault Audience [CRITICAL — ALREADY BURNED]
**What was assumed:** "Customer vault for Victory Belt book buyers."
**Reality:** BF MEMBERS. Saturno Movement community. Zero relation to Victory Belt.

## Error 02 — Middleware Architecture [CATASTROPHIC — ALREADY BURNED]
**What was proposed:** Protect `/` (the promo/index.html) — put it behind auth.
**Reality:** `/` IS the public door. Protecting it = paying customers arrive → 401 → gate → login → sent back to / → 401 → infinite loop → paying customers can't access anything.
**THE RULE:** `/` is always public. `/gate` is the lock. `/vault` is what's protected.

## Error 03 — Invented Vocabulary
**What was invented:** "Sales landing page," "sales hook" — language never in Gabo's words.
**THE RULE:** Use Gabo's language. Funnel = funnel. Universe = universe. Do not invent vocabulary.

## Error 04 — Auditing Without Context
**What happened:** Audited files without understanding who the actual users are.
**THE RULE:** Before touching any file: who is the person using this right now? What path do they take? What breaks if I change this?

## The Root Pattern Behind All Errors:
**Partial context, full confidence.**

---

# THE 7 THINGS EVERY CLAUDE MUST KNOW

1. **The vault is for BF Members and the Saturno Movement community.** Not book buyers. Not random visitors.
2. **The Victory Belt contract is cancelled.** Feb 20, 2026. No submission. No $20K unlock. It's a debt.
3. **`/` is public.** Always. It is the funnel door. Never put it behind auth.
4. **The gate is the lock.** `/gate` is where customers enter their password.
5. **`/vault` is what they paid for.** This is the protected content.
6. **VAULT LAUNCH IS FRIDAY, MARCH 13, 2026.** Until then: public sees ONLY promo and blog.
7. **This is a funnel, not a bonus page.** Gabo's words. Treat it that way.

---

*This manifesto was written March 6, 2026, after Claude destroyed days of work by operating on partial context with full confidence. It lives in every repo.*
