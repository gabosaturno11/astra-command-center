# SPRINT: BONUS PAGE LAUNCH — Monday March 9, 2026

## RULES: NO COPY CHANGES. NO MARKETING NUMBER CHANGES. CODE ONLY.
## MODE: Push every 2-3 tasks. Keep going through compaction. Never stop.
## RUN WITH: claude --dangerously-skip-permissions

---

## GABO ACTIONS (only Gabo can do these)

- [ ] Vercel > saturno-bonus > Env Vars > set VAULT_PASSWORD
- [ ] Vercel > saturno-bonus > Env Vars > set ADMIN_PASSWORD
- [ ] Vercel > saturno-bonus > Env Vars > set VAULT_TOKEN
- [ ] Vercel > astra-command-center > Env Vars > set ASTRA_ADMIN_PASSWORD
- [ ] Create Supabase project (this week, not today)

---

## DONE (session March 3 evening)

- [x] 1. Middleware restored — full lockdown (commit f386720)
- [x] 2. Stale "Opens Friday" removed from title/meta/countdown/nav (commit af880a9)
- [x] 3. Countdown set to Monday March 9 12PM EST (commit 653c508)
- [x] 4. Sprint file created in ASTRA logs (commit 379eaf3)
- [x] 5. MEMORY.md updated with next Claude directive
- [x] 6. Read all 511+ gabo messages
- [x] 7. Read all C1 transfer docs (C2_READ_FOR_BONUS, SUPABASE_BACKEND, MASTER_BACKUP_LOCATIONS)

---

## P0 — VERIFICATION (must pass before Monday)

- [ ] 8. curl verify API — confirm password auth works
- [ ] 9. curl music-blob API — confirm 36 tracks return
- [ ] 10. curl blog API — confirm posts return
- [ ] 11. curl community-msg API — confirm endpoint responds
- [ ] 12. Test middleware redirect: unauthenticated / -> /gate
- [ ] 13. Test middleware pass-through: /gate loads without redirect loop
- [ ] 14. Test middleware pass-through: /blog loads publicly (no auth)
- [ ] 15. Test middleware pass-through: /api/* endpoints work
- [ ] 16. Test middleware pass-through: static assets (css, js, png, mp3) load
- [ ] 17. Verify vercel.json routes: /vault -> vault.html
- [ ] 18. Verify vercel.json routes: /bonus -> vault.html
- [ ] 19. Verify vercel.json routes: /gate -> gate.html
- [ ] 20. Verify vercel.json routes: /experience -> experience.html
- [ ] 21. Verify vercel.json routes: /command -> admin.html
- [ ] 22. Verify vercel.json routes: /blog -> blog.html
- [ ] 23. Verify vercel.json routes: /blog/:slug -> blog-post.html
- [ ] 24. Verify vercel.json routes: /blog-admin -> blog-admin.html

---

## P0 — CODE FIXES (zero mistakes)

- [ ] 25. Check ALL console.error/console.log in index.html — remove any debug logs
- [ ] 26. Verify countdown JS fires correctly (not stuck on expired state before March 9)
- [ ] 27. Verify music toggle button appears and works (start/stop bg music)
- [ ] 28. Verify ASTRA preview player tracks load from Blob CDN
- [ ] 29. Verify tool peek canvases render (Black Hole, Pulsar, Supernova)
- [ ] 30. Verify sacred geometry sigil SVG renders in vault CTA section
- [ ] 31. Verify ghost wall reflections display (localStorage read)
- [ ] 32. Verify community message box submits to /api/community-msg
- [ ] 33. Verify roulette spin works (10 values, all 4 tabs)
- [ ] 34. Verify scroll-reveal animations on sections (IntersectionObserver)
- [ ] 35. Verify parallax section exits reset styles on scroll-back
- [ ] 36. Verify email signup form handles no-Brevo gracefully (no crash)
- [ ] 37. Verify gate.html password submit -> sets cookie -> redirects to /vault
- [ ] 38. Verify vault nav links work (Music, Blog, Tools, Experience)
- [ ] 39. Verify "Lock Vault" button in footer clears auth and goes to /gate
- [ ] 40. Verify back-to-vault buttons on all 67+ tool pages

---

## P1 — META & SEO

- [ ] 41. Verify og:image URL resolves (https://bonus.saturnomovement.com/assets/planet-logo.png)
- [ ] 42. Verify og:url on all customer-facing pages uses bonus.saturnomovement.com
- [ ] 43. Verify favicon loads on all pages (assets/planet-logo.png)
- [ ] 44. Verify manifest.json for PWA install
- [ ] 45. Verify preconnect hints (fonts.googleapis.com, fonts.gstatic.com, blob CDN)

---

## P1 — MOBILE (375px + 480px)

- [ ] 46. Check index.html renders on 375px viewport (no overflow-x)
- [ ] 47. Check gate.html input font-size >= 16px (iOS auto-zoom prevention)
- [ ] 48. Check touch targets >= 44px on all interactive elements
- [ ] 49. Check music toggle has safe-area-inset for notch devices
- [ ] 50. Check fullscreen tool expand/close works (ESC key + close button)
- [ ] 51. Check modal max-height 90vh with overflow scroll
- [ ] 52. Check blog.html responsive at 375px and 480px
- [ ] 53. Check blog write panel responsive at 480px

---

## P1 — ACCESSIBILITY

- [ ] 54. Verify prefers-reduced-motion disables all animations
- [ ] 55. Verify skip-to-content link on index.html
- [ ] 56. Verify keyboard navigation on roulette tabs
- [ ] 57. Verify keyboard navigation on music toggle (Space + Enter)
- [ ] 58. Verify ASTRA player track rows keyboard accessible
- [ ] 59. Verify focus-visible outlines on all interactive elements
- [ ] 60. Verify aria-labels on all icon-only buttons

---

## P1 — PERFORMANCE

- [ ] 61. Verify Vercel cache headers: assets/ immutable 1yr
- [ ] 62. Verify Vercel cache headers: PDFs 30d
- [ ] 63. Verify Vercel cache headers: HTML must-revalidate
- [ ] 64. Verify no blocking resources in <head> (fonts async)
- [ ] 65. Verify footer logo lazy-loaded
- [ ] 66. Check total page weight (target: <500KB excluding fonts)

---

## P1 — SECURITY

- [ ] 67. Verify no hardcoded passwords in any API file
- [ ] 68. Verify admin-verify does NOT return password in response
- [ ] 69. Verify blog.js sanitizeContent strips dangerous tags
- [ ] 70. Verify blog.js input validation (title 200, excerpt 500, content 500KB)
- [ ] 71. Verify no console.log in any customer-facing file
- [ ] 72. Verify CLAUDE.md / README.md not accessible via URL (middleware blocks)
- [ ] 73. Verify logs/ folder not accessible via URL
- [ ] 74. Verify internal tools (transcript-to-pdf, ecosystem-guide, nexus, capture, pipelines) moved to internal/ or blocked

---

## P2 — ASTRA

- [ ] 75. Verify ASTRA middleware works (password gate on sigma.vercel.app)
- [ ] 76. Wire cloud sync (api/state.js) so ASTRA data persists
- [ ] 77. Seed ASTRA with current project data (bonus, claude-code, book projects)
- [ ] 78. Update ASTRA bonus living doc with March 9 launch state

---

## P2 — BLOG

- [ ] 79. Verify blog-post.html renders markdown content
- [ ] 80. Verify community write panel (side panel, avatars, publish)
- [ ] 81. Verify share card generator (1080x1080 canvas)
- [ ] 82. Verify blog-admin.html loads and shows post list
- [ ] 83. Verify blog-admin dirty tracking + unsaved changes warning
- [ ] 84. Verify blog notifications endpoint for community posts

---

## P2 — VAULT CONTENT

- [ ] 85. Verify all 67 tool HTML files load without JS errors
- [ ] 86. Verify CF4 program (week navigation, frequency toggle, progress tracking)
- [ ] 87. Verify CF4 sub-pages have viewport meta + responsive CSS
- [ ] 88. Verify PDF section filter tabs work
- [ ] 89. Verify experience.html zone navigation works
- [ ] 90. Verify calisthenics-hub.html timer and journal

---

## P2 — FUTURE (this week, not launch day)

- [ ] 91. Supabase Phase 1: create lib/supabase.js, install dependency
- [ ] 92. Supabase Phase 2: dual-write blog.js (Supabase + Blob fallback)
- [ ] 93. Supabase Phase 2: dual-write community-msg.js
- [ ] 94. Supabase Phase 2: dual-write config.js
- [ ] 95. Supabase Phase 3: migrate existing Blob data to Supabase
- [ ] 96. Brevo email integration (needs API key from Gabo)
- [ ] 97. Vimeo integration for bonus page video content
- [ ] 98. Movement Studio as separate repo (Gabo directive msg 289)

---

## FILES TO READ BEFORE STARTING

1. This file
2. ~/dev/saturno-bonus/CLAUDE.md (42KB, full project spec)
3. ~/dev/saturno-bonus/logs/gabo-messages.json (511+ messages)
4. ~/.claude/projects/-Users-gabosaturno/memory/MEMORY.md
5. iCloud: ASTRA_INTERNAL_TRANSFER/C2_READ_FOR_BONUS.md

## KNOWN-GOOD ROLLBACK

```bash
cd ~/dev/saturno-bonus
git checkout 702f277 -- index.html
git add index.html && git commit -m "ROLLBACK to known-good 702f277" && git push
```

---

*Created: March 3, 2026 — 98 tasks, code-only sprint*
*Source: 511+ gabo messages + C1 transfer docs + 22 sessions of CLAUDE.md*
