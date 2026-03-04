# SPRINT: BONUS PAGE LAUNCH — Monday March 9, 2026

## SOURCE: C1 Transfer Docs (ASTRA_INTERNAL_TRANSFER/)
## Rules: NO COPY CHANGES. NO MARKETING NUMBER CHANGES. CODE ONLY.

---

## GABO ACTIONS (only Gabo can do these)

- [ ] Vercel > saturno-bonus > Env Vars > set `VAULT_PASSWORD` = saturno2025 (or choice)
- [ ] Vercel > saturno-bonus > Env Vars > set `ADMIN_PASSWORD` = choice
- [ ] Vercel > saturno-bonus > Env Vars > set `VAULT_TOKEN` = any secure string
- [ ] Confirm `BLOB_READ_WRITE_TOKEN` is set (music works = yes)
- [ ] Set ASTRA env vars: `ASTRA_ADMIN_PASSWORD` or `ASTRA_AUTH_TOKEN`

---

## DONE (this session, March 3)

- [x] Middleware restored — full lockdown, everything behind auth (commit f386720)
- [x] Stale "Opens Friday" removed from title, meta, countdown, nav (commit af880a9)
- [x] Countdown set to Monday March 9, 12PM EST (commit 653c508)
- [x] All 3 pushed to GitHub, Vercel auto-deploys

---

## SPRINT TASKS (code only, zero mistakes)

### P0 — MUST ship before Monday

1. [ ] Verify gate.html auth flow works end-to-end with middleware
2. [ ] Verify music player loads from Blob CDN (36 tracks)
3. [ ] Verify blog at /blog loads and renders posts
4. [ ] Test all vercel.json routes (/vault, /gate, /blog, /blog/:slug, /blog-admin, /command, /experience)
5. [ ] Verify promo page renders correctly (no JS errors, all sections load)
6. [ ] Check mobile viewport (375px, 480px breakpoints)

### P1 — Should ship before Monday

7. [ ] Restore ASTRA data on C2 (either seed from codebase or wire cloud sync)
8. [ ] Verify ASTRA password gate works (middleware exists, needs env var)
9. [ ] Test community message box (ghost wall) submit + display
10. [ ] Test roulette (10 values, spin, all tabs)
11. [ ] Test email signup graceful fallback (no Brevo keys = no crash)
12. [ ] Verify og:image, og:title, og:description on all customer-facing pages

### P2 — Nice to have before Monday

13. [ ] Supabase project setup (Gabo creates project, Claude builds integration)
14. [ ] Brevo email integration (needs API key + list ID from Gabo)
15. [ ] ASTRA Vimeo control panel

---

## DO NOT TOUCH

- index.html copy (marketing numbers, text, descriptions)
- api/music-blob.js (music works, don't break it)
- Any tool HTML file content
- gate.html design
- vercel.json routing (working)

## KNOWN-GOOD ROLLBACK

If anything breaks: `git checkout 702f277 -- index.html`

---

## VERIFICATION COMMANDS

```bash
# Gate auth
curl -X POST https://bonus.saturnomovement.com/api/verify -H "Content-Type: application/json" -d '{"password":"saturno2025"}'

# Music
curl -s https://bonus.saturnomovement.com/api/music-blob | head -100

# Blog
curl -s https://bonus.saturnomovement.com/api/blog | head -100

# Middleware (should redirect to /gate)
curl -s -o /dev/null -w "%{http_code}" https://bonus.saturnomovement.com/
```

---

*Sprint source: iCloud ASTRA_INTERNAL_TRANSFER/C2_READ_FOR_BONUS.md + README_C2_SUPABASE_BACKEND.md*
*Created: March 3, 2026*
