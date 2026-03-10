# BONUS PAGE FRIDAY LAUNCH PREFLIGHT
## bonus.saturnomovement.com
## Generated: 2026-03-09

---

## 1. HTTP STATUS CHECK

| Check | Result |
|-------|--------|
| https://bonus.saturnomovement.com (promo/index) | GREEN - 200 OK, page loads fully |
| https://bonus.saturnomovement.com/gate | GREEN - 200 OK, password input renders |
| https://bonus.saturnomovement.com/vault | Redirects to /gate (302) - correct auth behavior |

---

## 2. ENVIRONMENT VARIABLES

| Env Var | Required By | Status | Impact |
|---------|------------|--------|--------|
| BLOB_READ_WRITE_TOKEN | community-msg.js, config.js, music-blob.js, blog.js, blog-notifications.js | GREEN - SET | Music Blob returns source:"blob", 36 tracks. Community msgs working. |
| BREVO_API_KEY | brevo-subscribe.js, blog.js (notifyGabo) | RED - NOT SET | Email signup returns 503. Gabo not notified of community blog posts. |
| BREVO_LIST_ID | brevo-subscribe.js | RED - NOT SET | Email signup returns 503. |
| VAULT_PASSWORD | verify.js, middleware.js | YELLOW - FALLBACK | Falls back to hardcoded "saturno2025". Works but password is visible in source code. |
| VAULT_TOKEN | verify.js, middleware.js, blog.js, blog-notifications.js | YELLOW - FALLBACK | Falls back to hardcoded "sv_82f7a3d1e9c0b465". Auth works but token is in source. |
| ADMIN_PASSWORD | admin-verify.js, community-msg.js (admin GET), config.js (POST), music-blob.js (upload) | RED - NOT SET | Admin panel login returns 503. Config write disabled. Music upload disabled. |

---

## 3. EXTERNAL DEPENDENCIES (API CALLS)

### A. Promo Page (index.html) — PUBLIC, no auth needed

| Endpoint / Dependency | Purpose | Status |
|----------------------|---------|--------|
| /api/community-msg?public=1 (GET) | Load community reflections for ghost wall | GREEN - Returns 8 reflections |
| /api/community-msg (POST) | Submit user reflection | GREEN - Working (uses BLOB_READ_WRITE_TOKEN) |
| Google Fonts (fonts.googleapis.com) | Sora font | GREEN - External CDN, always available |
| Vercel Blob CDN (ztffd0awmvvpmclw.public.blob.vercel-storage.com) | Background music track, album previews | GREEN - CDN active |
| Spotify URLs (open.spotify.com) | Album links in music discography | GREEN - External links only |

### B. Gate Page (gate.html) — PUBLIC

| Endpoint / Dependency | Purpose | Status |
|----------------------|---------|--------|
| /api/verify (POST) | Password authentication | YELLOW - Works with fallback password "saturno2025" |
| Google Fonts | Sora font | GREEN |

### C. Vault Page (vault.html) — PROTECTED

| Endpoint / Dependency | Purpose | Status |
|----------------------|---------|--------|
| /api/brevo-subscribe (POST) | Email signup (black hole door + email section) | RED - Returns 503 (BREVO_API_KEY not set) |
| /api/config (GET) | Dashboard config for tool visibility | YELLOW - Returns default config (not saved to Blob yet) |
| /api/music-blob (GET) | Music manifest with Blob CDN URLs | GREEN - 36 tracks, source:"blob" |
| audio/manifest.json (GET) | Local music fallback | GREEN - Fallback path exists |
| /api/brevo-subscribe (POST) | Second email capture form | RED - Same as above |
| Google Fonts | Sora font | GREEN |

### D. Blog System (blog.html, blog-post.html, blog-admin.html) — MIXED

| Endpoint / Dependency | Purpose | Status |
|----------------------|---------|--------|
| /api/blog (GET) | List/read blog posts | GREEN - Uses BLOB_READ_WRITE_TOKEN + seed data |
| /api/blog (POST - community) | Community post submission | GREEN - No auth needed, Blob storage working |
| /api/blog (POST/PUT/DELETE - admin) | Admin CRUD | YELLOW - Requires vault_auth cookie (fallback works) |
| /api/community-msg (POST) | Community writing wall messages | GREEN |
| /api/blog-notifications (GET/DELETE) | Admin notification badge | YELLOW - Requires vault_auth (fallback works) |
| Brevo SMTP API (via blog.js notifyGabo) | Email Gabo on community post | RED - BREVO_API_KEY not set, falls back to Blob notification storage |

### E. Admin Panel (admin.html)

| Endpoint / Dependency | Purpose | Status |
|----------------------|---------|--------|
| /api/admin-verify (POST) | Admin login | RED - ADMIN_PASSWORD not set, returns 503 |
| /api/config (GET/POST) | Read/write dashboard config | YELLOW (read) / RED (write - needs ADMIN_PASSWORD) |

### F. Middleware (middleware.js) — AUTH LAYER

| Dependency | Purpose | Status |
|-----------|---------|--------|
| process.env.VAULT_TOKEN | Primary auth token validation | YELLOW - Falls back to hardcoded FALLBACK_TOKEN |

---

## 4. EXTERNAL CDN / THIRD-PARTY SERVICES

| Service | Used For | Status |
|---------|----------|--------|
| Google Fonts CDN | Sora font family | GREEN - Always available |
| Vercel Blob Storage | Music (36 tracks), blog posts, community msgs, notifications | GREEN - Active and serving data |
| Brevo (Sendinblue) API | Email subscriptions + admin notifications | RED - API key not configured |
| Spotify | Album links (external, no API call) | GREEN - Static links |

---

## 5. SUMMARY

### READY FOR LAUNCH (GREEN)

- Homepage/promo page loads at 200
- Gate authentication works (with fallback password)
- Vault page loads behind auth
- Music player: 36 tracks streaming from Vercel Blob CDN
- Community reflections: read + write working
- Blog system: posts load, community writing works
- All static assets (fonts, images, SFX, PDFs) serve correctly
- PWA manifest present
- Security headers configured in vercel.json

### BLOCKING / BROKEN (RED)

1. **BREVO_API_KEY** — Email signup on vault page returns 503 "Subscription is not available yet." Two email capture forms are broken. Gabo does not get notified of community blog posts via email (falls back to Blob storage, but no email).

2. **BREVO_LIST_ID** — Required alongside BREVO_API_KEY for email subscriptions.

3. **ADMIN_PASSWORD** — Admin panel (/command) login returns 503. Cannot manage dashboard config, upload music, or view community messages as admin.

### NON-BLOCKING BUT SHOULD FIX (YELLOW)

4. **VAULT_PASSWORD** — Using hardcoded fallback "saturno2025". Password is visible in api/verify.js source code on GitHub. Set env var in Vercel to override.

5. **VAULT_TOKEN** — Using hardcoded fallback token "sv_82f7a3d1e9c0b465". Token is visible in source. Set env var in Vercel to override.

6. **Config not persisted to Blob** — /api/config returns _source:"default". Config was never saved to Blob (no one has POST'd to it). Non-blocking because vault falls back to showing all tools.

### ASSETS NOT YET AVAILABLE

7. **3 ASTRA album tracks missing** — Euthymia, Eternal Crown, Apsis (iCloud 0-byte placeholders on source machine)
8. **assets/gabo-shatter.jpg** — Gabo's handstand photo for logo shatter effect not provided
9. **Video CDN** — app-promo.mp4 and other videos are gitignored, no Vimeo integration yet

---

## 6. ACTION ITEMS FOR LAUNCH

### Must Do (Vercel Dashboard > saturno-bonus > Settings > Environment Variables)

```
BREVO_API_KEY=<get from https://app.brevo.com/settings/keys/api>
BREVO_LIST_ID=<get from Brevo contact list ID>
ADMIN_PASSWORD=<choose a strong password>
VAULT_PASSWORD=saturno2025  (or new password — overrides hardcoded fallback)
VAULT_TOKEN=<generate random token — overrides hardcoded fallback>
```

After setting env vars, trigger a redeploy: Vercel Dashboard > Deployments > Redeploy (or `git push` any change).

### Nice to Have Before Launch

- Physical device testing (mobile Safari, Android Chrome)
- Drop gabo-shatter.jpg into assets/
- Upload remaining 3 ASTRA tracks once downloaded from iCloud
