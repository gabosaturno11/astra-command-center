# WHERE IS EVERYTHING — Quick Reference
## After Cloud Offload, March 3, 2026

---

## CODE (CANONICAL — DO NOT MOVE)

```
~/dev/saturno-bonus/          -> bonus.saturnomovement.com
~/dev/astra-command-center/   -> astra-command-center-sigma.vercel.app
~/dev/titan-forge/            -> titan-forge-ten.vercel.app
~/dev/de-aqui-a-saturno/      -> de-aqui-a-saturno-jet.vercel.app
~/dev/nexus-capture/          -> Chrome extension
~/dev/saturno-movement-studio/-> saturno-movement-studio.vercel.app
+ 5 more repos in ~/dev/
```

Deploy: `cd ~/dev/<repo> && git push origin main` -> Vercel auto-deploys

---

## CLOUD DATA (ARCHIVED TO EXTERNAL DRIVES)

### Google Drive (gabo@saturnomovement.com) — 284GB
- **STILL IN CLOUD:** Yes (Google Drive web/app)
- **BACKUP:** `/Volumes/G-DRIVE ArmorATD/GDRIVE_OFFLOAD_2026-03-03/gabo_saturnomovement_2026-03-03/`

### Google Drive (reach@saturnomovement.com) — 22MB
- **BACKUP:** `/Volumes/SSK Drive/REACH_GDRIVE_OFFLOAD_2026-03-03/`

### Google Drive (smacademycontent@gmail.com) — ~1.5GB
- **BACKUP:** `/Volumes/SSK Drive/SMACADEMY_OFFLOAD_2026-03-03/`

### iCloud Drive — 207GB
- **BACKUP:** `/Volumes/SSK Drive/ICLOUD_BACK_UP_03.03.2026/`
- **_PRIVATE folder:** Still in iCloud ONLY (SSK ran out of space) -> Norpass Vault

### OneDrive — 2.9GB
- **BACKUP:** `/Volumes/SSK Drive/ONEDRIVE_OFFLOAD_2026-03-03/`
- **ALSO ON:** `/Volumes/G-DRIVE ArmorATD/ONEDRIVE_OFFLOAD_2026-03-03/`

### Dropbox — 27GB
- **BACKUP:** `/Volumes/G-DRIVE ArmorATD/DROPBOX_OFFLOAD_2026-03-03/`
- **NOTE:** GABRIELE SATURNO/VB folder was excluded (left in Dropbox)

---

## REPO BUNDLES (EMERGENCY RESTORE)

```
Google Drive/BONUS_SATURNO_C2_TRANSFER/
  saturno-bonus.bundle          (240MB — full git history)
  saturno-bonus-files/          (1.9GB — working tree with audio)
  DEPLOY_INSTRUCTIONS.md
  restore-all-repos.sh

Google Drive/DEV_REPOS_BACKUP_C2_20260302/
  saturno-bonus.bundle
  astra-command-center.bundle
  titan-forge.bundle
  de-aqui-a-saturno.bundle
  nexus-capture.bundle
  saturno-movement-studio.bundle
  saturno-branding-assets.bundle
  content-beast.bundle
  sm-app-copy-v1.bundle
  VB-COMMAND-CENTER.bundle
  victory-belt-cc.bundle
```

---

## DRIVE STATUS

| Drive | Total | Used | Free |
|-------|-------|------|------|
| G-DRIVE ArmorATD | 4.5TB | 2.3TB | 2.2TB |
| SSK Drive | 477GB | 476GB | FULL |
| T7 | Video courses | NTFS READ-ONLY | — |

---

*"We are finally cleaning up the engines!" — Gabo, March 3, 2026*

---

## UPDATE — C1 Session Close-Out (March 3, evening)

### Additional backups on G-DRIVE:
```
/Volumes/G-DRIVE ArmorATD/
  DOWNLOADS_BACKUP_2026-03-03/    <- ~/Downloads/ full copy (54GB)
  DESKTOP_BACKUP_2026-03-03/      <- ~/Desktop/ full copy (7GB)
  README.md                        <- Storage README with full map
```

### Master docs (available on all machines via iCloud):
```
iCloud/ASTRA_INTERNAL_TRANSFER/
  MASTER_BACKUP_LOCATIONS.md       <- Every backup, every duplicate, every location
  README_C2_SUPABASE_BACKEND.md    <- Supabase backend plan for C2
  README_FOR_SSK_DRIVE.md          <- Drop on SSK when plugged in
  README_FOR_GOOGLE_DRIVE.md       <- Already placed as README_STORAGE.md
  README_FOR_ICLOUD.md             <- Already placed as README_STORAGE.md
  README_FOR_DROPBOX.md            <- Reference for unlinking
  README_FOR_ONEDRIVE.md           <- Reference for unlinking
  README_FOR_T7.md                 <- T7 is NTFS read-only, reference only
  UNIVERSAL_README_TEMPLATE.md     <- Header template for all READMEs
```

### Computer codes (CANNON):
| C1 | iMac | /Users/Gabosaturno |
| C2 | MacBook Pro 16 | /Users/gabosaturno |

### Gabo action items:
1. Set VAULT_PASSWORD + ADMIN_PASSWORD in Vercel
2. Unlink Dropbox + OneDrive (backups on G-DRIVE)
3. Create Supabase project for C2 backend
4. Post goes live at bonus.saturnomovement.com
