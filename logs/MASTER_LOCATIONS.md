# MASTER LOCATIONS — EVERYTHING, EVERYWHERE
## Updated: March 4, 2026

---

## COMPUTERS

| Code | Machine | Username | Path | Status |
|------|---------|----------|------|--------|
| C1 | iMac | Gabosaturno (CAPITAL G) | /Users/Gabosaturno | Fallback + planning |
| C2 | MacBook Pro | gabosaturno (lowercase g) | /Users/gabosaturno | Execution + deploys |
| C1->C2 | SMB file share | - | /Volumes/gabosaturno/ | C1 can read/write C2 directly |

---

## REPOS (~/dev/ on BOTH machines — synced March 4)

| Repo | C1 | C2 | Live URL |
|------|----|----|----------|
| astra-command-center | YES | YES | astra-command-center-sigma.vercel.app |
| saturno-bonus | YES | YES | bonus.saturnomovement.com |
| titan-forge | YES | YES | titan-forge-ten.vercel.app |
| sm-app-copy-v1 | YES | YES | (not deployed) |
| content-beast | YES | YES | (not deployed) |
| de-aqui-a-saturno | YES | YES | de-aqui-a-saturno-jet.vercel.app |
| nexus-capture | YES | YES | (Chrome extension) |
| saturno-branding-assets | YES | YES | (not deployed) |
| saturno-movement-studio | YES | YES | (not deployed) |
| victory-belt-cc | YES | YES | (legacy) |
| VB-COMMAND-CENTER | YES | NO | (legacy) |

**Deploy from C2:** `cd ~/dev/<repo> && git push origin main`
**GitHub:** gabosaturno11 | **Vercel:** gabriele-saturnos-projects

---

## EXTERNAL DRIVES

### On C2 (MacBook Pro)

| Drive | Size | Contents |
|-------|------|----------|
| G-DRIVE PRO | TBD | TBD — needs audit |
| G-DRIVE USB-C | TBD | TBD — needs audit |
| G-UTILITIES | TBD | TBD — needs audit |
| Main LaCie | TBD | 10TB — 500+ tracks, 2000+ transcripts, 100+ logos, 10000+ SFX, all brand assets |
| SSK Drive | 477GB | HBS (8.3GB), Black Friday (224MB), iCloud offload (207GB) |

### Previously on C1 (currently disconnected)

| Drive | Size | Contents |
|-------|------|----------|
| G-DRIVE ArmorATD | 4.5TB | Canonical scripts, session logs, offloaded cloud content |
| SSK Drive | 477GB | Same as above if same drive |
| T7 | TBD | Video courses (NTFS, READ-ONLY), Epic Space Music, STAR SYSTEM album |

---

## CLOUD STORAGE (ALL UNLINKED FROM LOCAL — March 3)

### Google Drive (gabo@saturnomovement.com) — PRIMARY
- Offloaded to G-DRIVE ArmorATD (284GB, March 3)
- Key folders: 00_AI_HUB, 01_AOC_BOOK, 02_SATURNO_MOVEMENT, 04_CLAUDE_DOCS, CLAUDE_CODE_KERNEL
- Contains: README_C2_SUPABASE_BACKEND.md (3 copies), BONUS_SATURNO_C2_TRANSFER/, DEV_REPOS_BACKUP_C2_20260302/

### Google Drive (reach@saturnomovement.com) — SECONDARY
- Offloaded to SSK Drive (22MB, March 3)
- 180+ files, needs organization

### Google Drive (smacademycontent@gmail.com) — ACADEMY
- 7 items, minimal

### iCloud Drive
- Consolidated to ICLOUD_C1_03.03.2026/ folder
- Only _PRIVATE + ASTRA_INTERNAL_TRANSFER remain at root
- ASTRA_INTERNAL_TRANSFER has: C1_AUDIT, GABO_ONLY_READ_HAND_TO_C2, SATURNO_MOVEMENT_COMPLETE_REBUILD_BLUEPRINT

### OneDrive — UNLINKED
- Offloaded to SSK + G-DRIVE (2.9GB, March 3)

### Dropbox — DELETED
- Offloaded to G-DRIVE (27GB, March 3)

---

## KEY FILES (WHERE TO READ)

| What | Path |
|------|------|
| Global kernel | ~/.claude/CLAUDE.md (on each machine) |
| C2 root kernel | ~/CLAUDE.md (on C2 only) |
| Memory | ~/.claude/projects/-Users-Gabosaturno/memory/MEMORY.md (C1 only) |
| ASTRA state | ~/dev/astra-command-center/CLAUDE.md |
| Bonus state | ~/dev/saturno-bonus/CLAUDE.md |
| Bonus 2.0 spec | ~/dev/astra-command-center/logs/BONUS_PAGE_2.0_SPEC.md |
| SM App blueprint | iCloud ASTRA_INTERNAL_TRANSFER/SATURNO_MOVEMENT_COMPLETE_REBUILD_BLUEPRINT.md |
| ASTRA messages | ~/dev/astra-command-center/logs/gabo-messages.json |
| Bonus messages | ~/dev/saturno-bonus/logs/gabo-messages.json |
| SM App messages | ~/dev/sm-app-copy-v1/logs/gabo-messages.json |
| This file | ~/dev/astra-command-center/logs/MASTER_LOCATIONS.md |

---

## BACKUPS

| Location | Contents | Size | Date |
|----------|----------|------|------|
| G-DRIVE HOMEDIR_C1_BACK_UP_03.03.2026/ | C1 home dir | 78GB | Mar 3 |
| G-DRIVE DOWNLOADS_BACKUP_2026-03-03/ | C1 Downloads | 54GB | Mar 3 |
| G-DRIVE DESKTOP_BACKUP_2026-03-03/ | C1 Desktop | 7GB | Mar 3 |
| G-DRIVE DOCUMENTS_LOCAL_C1_BACK_UP_03.03.2026/ | C1 Documents | 329MB | Mar 3 |
| G-DRIVE DROPBOX_OFFLOAD_2026-03-03/ | Dropbox content | 27GB | Mar 3 |
| G-DRIVE GDRIVE_BACK_UP_03.03.2026/ | Google Drive gabo@ | 284GB | Mar 3 |
| SSK ICLOUD_BACK_UP_03.03.2026/ | iCloud content | 207GB | Mar 3 |
| GDrive BONUS_SATURNO_C2_TRANSFER/ | Full bonus repo | 2.2GB | Mar 2 |
| GDrive DEV_REPOS_BACKUP_C2_20260302/ | All 11 repo bundles | 1.3GB | Mar 2 |
| C2 ~/dev/C2_HOME_BACKUP_03.04.2026/ | C2 loose home files | ~250MB | Mar 4 |

---

## VERCEL ENV VARS NEEDED

| Variable | Status | Project |
|----------|--------|---------|
| BLOB_READ_WRITE_TOKEN | SET | saturno-bonus |
| VAULT_PASSWORD | NOT SET (using fallback saturno2025) | saturno-bonus |
| VAULT_TOKEN | NOT SET | saturno-bonus |
| BREVO_API_KEY | NOT SET | saturno-bonus |
| BREVO_LIST_ID | NOT SET | saturno-bonus |
| ADMIN_PASSWORD | NOT SET | saturno-bonus |
| SUPABASE_URL | NOT SET (create project first) | saturno-bonus |
| SUPABASE_ANON_KEY | NOT SET | saturno-bonus |
| SUPABASE_SERVICE_KEY | NOT SET | saturno-bonus |
| ASTRA_ADMIN_PASSWORD | NOT SET | astra-command-center |
| OPENAI_API_KEY | NOT SET | astra-command-center |

---

*This doc lives in version control. Always up to date with latest push.*
