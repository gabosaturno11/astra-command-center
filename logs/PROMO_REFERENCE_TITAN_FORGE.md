# PROMO PAGE REFERENCE — titan-forge-upgrade.vercel.app/promo
## For comparison against bonus.saturnomovement.com (index.html)
## Created: 2026-03-03 by QC Claude

---

## PURPOSE

This is the v2 promo page (titan-forge-upgrade repo). Use it as a reference for what's CLEANER than the current bonus promo page. Both pages share the same DNA but the titan-forge version has tighter architecture.

---

## WHAT'S CLEANER IN THIS VERSION

### 1. Section Structure — 3 Clear Sections (What/Why/Who)
- Each section has: label (mono, 9px, cyan) + heading (clamp responsive) + body + visual grid
- Clean `data-anim` attribute triggers scroll reveal
- Separators between sections with animated pulse gradient
- **Bonus promo has:** What + Why + proof strip + at a glance + content map + music + roulette + tools + oracle + countdown + blog CTA — much more sprawling

### 2. Visual Grid — Consistent 2-Column Layout
- Default blocks: 1:1 aspect ratio
- Wide blocks: `grid-column: 1/-1`, 2:1 aspect ratio
- 12px gap, 14px border-radius
- Hover: cyan border glow + box-shadow
- **Bonus promo has:** Inconsistent grids (content map is 7 items in 2-col = orphan)

### 3. Typography System — Tight Scale
| Element | Font | Size | Weight | Spacing |
|---------|------|------|--------|---------|
| Section label | JetBrains Mono | 9px | — | 0.35em |
| Heading | Default | clamp(1.4rem, 4vw, 1.8rem) | 700 | — |
| Body | Default | 13px | — | — |
| Hero title | Default | clamp(2.6rem, 9vw, 4.5rem) | 800 | 0.08em |
| Hero statement | JetBrains Mono | 11px | — | 0.04em |
| Buttons | JetBrains Mono | 10-11px | 600 | 0.2em |

### 4. Color Palette — Fewer, Tighter
```
#050508    bg (slightly warmer than bonus #050711)
#06b6d4    cyan (primary)
#a855f7    purple (secondary)
#d4af37    gold (tertiary)
#2dd4bf    teal (terminal)
#d4d4d8    text
#fafafa    bright text
```

### 5. Quote Block with Terminal Morph
- Quote block EXISTS in HTML (`.quote-block`)
- Terminal morph WORKS — typewriter effect, teal text, then fades back to quote
- **Bonus promo:** Has the JS for terminal morph (~65 lines) but `.quote-block` HTML element was removed. Dead code.

### 6. CTA — Single, Clear
- One CTA section at the bottom: "Explore the System" -> `/gate`
- Clean button: transparent bg, cyan border, JetBrains Mono, uppercase
- Hover: cyan tint bg + intensified border + box-shadow glow
- **Bonus promo:** Multiple CTAs ("Coming Soon", countdown, blog CTA, oracle link) scattered and some are stale/dead

### 7. Music Toggle — Simpler
- Fixed bottom-right, 48x48 circle
- Alien emoji icon
- Quote popup on toggle
- 5 tracks with auto-advance
- **Bonus promo:** Same system but also has full ASTRA Beatport player, 16 album cards, and auto-plays on ANY interaction (scroll/click/touch/mousemove)

### 8. Canvases — 6 Total, All Functional
1. **Particle field** (background, 80-160 particles, scroll parallax)
2. **Mastery grid** (8x8, click flash, pulse wave)
3. **Waveform** (50 bars, touch-responsive, sine compound)
4. **Neural network** (28 nodes, mouse repulsion, click push)
5. **Constellation** (click to add stars, nearest-neighbor connections)
6. **Roulette wheel** (12 segments, spin with easing, logo center)
- All have proper DPR scaling, RAF loops, resize handlers
- **Bonus promo:** Has particle field + mastery grid + waveform + neural network + roulette wheel + tool cover art canvases + album art canvas. But albumCanvas JS references non-existent element (dead code). gravitationalPull targets non-existent class names.

### 9. Roulette — Same System, Cleaner Integration
- 12 values with quotes/doctrine/mantra/reflect tabs
- Ghost wall saves to localStorage
- Web Audio API SFX for spin (sawtooth glide) and land (sine drop)
- Result card with tab navigation (dots for quotes)
- **Same in both versions**, but bonus promo's roulette also posts to `/api/community-msg` which is never fetched back on load

### 10. Responsive — Cleaner Breakpoints
- 768px: tighter padding, smaller blur
- 480px: 1-column grid, smaller logo, reduced spacing
- Content max-width: 640px centered
- **Bonus promo:** Has 768/600/480/375 breakpoints — more granular but also more complex

### 11. Entrance Animation Sequence
```
0.0s  intro-pulse (radial expand from center, 2.8s)
0.3s  logo (scale 0.3→1 with cyan glow, 2s)
0.8s  title (slide up with glowing shadow, 1.4s)
1.0s  title scramble (random chars → reveal, 40ms/frame)
1.4s  divider line (scaleX 0→1, 0.8s)
1.6s  hero statement (fade + slide up, 1s)
```
- **Bonus promo:** Similar but also has intro audio trigger tied to first interaction

### 12. Scroll Features
- Smooth scroll (`scroll-behavior: smooth`)
- Scroll parallax on particles (`scrollY * 0.0003`)
- Glitch surprise at 35-55% scroll (one-time)
- System notifications at scroll milestones (typewriter, top-right)
- Section reveal via IntersectionObserver (threshold 0.1)

---

## ARCHITECTURAL DIFFERENCES

| Feature | Titan-Forge Promo | Bonus Promo (index.html) |
|---------|-------------------|--------------------------|
| Sections | 3 (What/Why/Who) + roulette + CTA | 12+ distinct sections |
| Lines of code | ~3,500 | ~4,974 |
| Dead JS code | Minimal | ~195 lines (quote morph + albumCanvas) |
| CTAs | 1 clear CTA | Multiple scattered, some stale |
| Music control | Toggle button only | Toggle + full Beatport player + 16 album cards |
| Auto-play music | On load (try/catch) | On ANY first interaction |
| Gravitational pull | Not present | Present but targets non-existent classes |
| Tools (peek) | Not present | 3 tools with cover art + fullscreen |
| Countdown | Not present | March 9 2026, no post-launch state |
| Blog CTA | Not present | Present |
| Content map | Not present | 7 items (orphan in grid) |
| Alien oracle | Quote popup on music toggle | Full oracle section with 10 wisdoms |

---

## WHAT BONUS PROMO HAS THAT TITAN DOESN'T (KEEP THESE)
- ASTRA music player (Beatport-style, 7 tracks, waveform viz)
- 16 album art cards
- 3 interactive tools (Breathing Pacer, Hold Timer, Movement Generator)
- Content map inventory
- Countdown timer
- Blog CTA section
- Alien Oracle section
- Proof strip (scrolling ticker)
- Built-with footer + pillars

---

## QC FINDINGS — 10 IMPROVEMENTS FOR BONUS PROMO

Based on comparing both versions:

### Launch-Day Blockers
1. **Countdown post-launch state** — After March 9, shows "THE VAULT IS COMING" (teaser text). Should flip to "THE VAULT IS LIVE" + direct `/gate` link.
2. **"Coming Soon" CTAs** — Scroll nav + vault CTA say "Coming Soon". After launch: "Enter The Vault" -> `/gate`.
3. **Oracle "Dropping Friday"** — opacity 0.4, cursor:default. Dead tease. Link to `/gate` or remove.

### UX Wins
4. **Music auto-play on ANY interaction** — Scroll, click, touch, mousemove all trigger music. Titan-forge uses explicit toggle only. Users get surprised audio.
5. **Ghost wall doesn't fetch community reflections** — Posts to `/api/community-msg` but never reads back. localStorage only = single-device, clears with browser data.
6. **Mastery grid has no payoff** — No persistence (localStorage), no progress indicator, no explanation. Users click cells, nothing happens. Add state save + "X/64" counter.

### Polish/Cleanup
7. **Gravitational pull targets nothing** — `initGravItems()` queries `.inventory-item`, `.content-map-item`, `.album-card`, `.mastery-node` — none exist in HTML. Effect never fires on elements.
8. **~195 lines dead JS** — Quote terminal morph (`.quote-block` removed from HTML) + albumCanvas art generator (`#albumCanvas` replaced by `<img>`). Running on every load, doing nothing.
9. **Content map orphan** — 7 items in 2-column grid. Last item alone. Add 8th or center last.
10. **Duplicate audio source** — `bgMusic` has two identical `<source>` tags for same MP3.

---

*QC Reference — Do not deploy from this file. This is analysis only.*
*Source: https://titan-forge-upgrade.vercel.app/promo*
*Compared against: ~/dev/saturno-bonus/index.html (4,974 lines)*
