# CLOUD OFFLOAD SUMMARY — March 3, 2026
## Machine: iMac (C1) — /Users/Gabosaturno

---

## WHAT WAS DONE

All cloud-synced services were backed up to external drives so they can be unsynced from this machine. This eliminates the multi-dimensional sync chaos (Google Drive x3, OneDrive, Dropbox, iCloud all cross-referencing each other with 27-deep folder paths).

---

## BACKUP LOCATIONS

### G-DRIVE ArmorATD (4.5TB, 2.2TB free after offload)

| Folder | Source | Size |
|--------|--------|------|
| `GDRIVE_OFFLOAD_2026-03-03/gabo_saturnomovement_2026-03-03/` | Google Drive (gabo@saturnomovement.com) | 284GB |
| `GDRIVE_OFFLOAD_2026-03-03/reach_saturnomovement_2026-03-03/` | Google Drive (reach@saturnomovement.com) | ~22MB (shortcut files failed, real content on SSK) |
| `GDRIVE_OFFLOAD_2026-03-03/smacademycontent_main_2026-03-03/` | Google Drive (smacademycontent@gmail.com) | ~0B (shortcut files failed, real content on SSK) |
| `GDRIVE_OFFLOAD_2026-03-03/smacademycontent_nov23_2026-03-03/` | Google Drive (smacademycontent Nov snapshot) | 992KB |
| `GDRIVE_OFFLOAD_2026-03-03/smacademycontent_dec15_2026-03-03/` | Google Drive (smacademycontent Dec snapshot) | 567MB |
| `DROPBOX_OFFLOAD_2026-03-03/` | Dropbox (excl. GABRIELE SATURNO/VB folder) | 27GB |
| `ONEDRIVE_OFFLOAD_2026-03-03/` | OneDrive | ~2.9GB |

### SSK Drive (477GB, NOW FULL)

| Folder | Source | Size |
|--------|--------|------|
| `ICLOUD_BACK_UP_03.03.2026/` | iCloud Drive (all folders except _PRIVATE stopped due to full disk) | 207GB |
| `REACH_GDRIVE_OFFLOAD_2026-03-03/` | Google Drive (reach@saturnomovement.com) | 22MB |
| `SMACADEMY_OFFLOAD_2026-03-03/` | Google Drive (smacademycontent@gmail.com, all 3 variants) | ~1.5GB |
| `ONEDRIVE_OFFLOAD_2026-03-03/` | OneDrive | ~2.9GB |

### iCloud — _PRIVATE folder

**LEFT IN iCloud intentionally.** Gabo will move to Norpass Vault (1TB) manually.
The _PRIVATE folder did NOT copy to SSK (disk ran out of space at that point).

---

## TOTALS

| Destination | Data Copied | Space Remaining |
|-------------|-------------|-----------------|
| G-DRIVE ArmorATD | ~312GB | 2.2TB |
| SSK Drive | ~210GB | FULL (636MB) |
| **Grand Total** | **~522GB archived** | |

---

## DEV REPOS BACKUP (also on G-DRIVE)

Created earlier in this session:

| Folder | Contents | Size |
|--------|----------|------|
| `Google Drive/BONUS_SATURNO_C2_TRANSFER/` | saturno-bonus full repo + bundle + deploy script + restore script | 2.2GB |
| `Google Drive/DEV_REPOS_BACKUP_C2_20260302/` | Git bundles for ALL 11 ~/dev/ repos | 1.3GB |

---

## WHAT'S NEXT

1. **Unsync cloud services from this machine:**
   - Google Drive (3 accounts) — System Settings or Google Drive app
   - OneDrive — OneDrive app preferences
   - Dropbox — Dropbox app preferences
   - iCloud Drive — can reduce what syncs in System Settings > Apple ID > iCloud

2. **After unsync:** Reclaim hundreds of GB of local disk space

3. **Weekly maintenance:** Move any new local work back to Google Drive > ASTRA > Local Repos

4. **_PRIVATE:** Gabo moves from iCloud to Norpass Vault 1TB

---

## NOTES

- Google Drive `.gdoc`/`.gsheet` shortcut files can't be rsync'd — they're just cloud pointers, not real files. The actual content is only accessible via Google Drive web or app.
- reach@ and smacademycontent@ main accounts had mostly shortcut files, so the rsync reported 0B. The real files were already on SSK from earlier in the session.
- Dropbox had Google Drive content nested inside it (Notion export with HBS Google Drive). This cross-sync chaos is exactly why we're archiving everything.
- OneDrive had Google Drive paths 27 subfolders deep. Same reason.

---

*Created: March 3, 2026 by Claude Code*
*Session: Cloud offload + bonus page deployment seal*

---

## UPDATE — C1 Session Close-Out (March 3, evening)

### Additional backups completed:
| Folder | Source | Destination | Size |
|--------|--------|-------------|------|
| DOWNLOADS_BACKUP_2026-03-03/ | ~/Downloads/ | G-DRIVE ArmorATD | 54GB |
| DESKTOP_BACKUP_2026-03-03/ | ~/Desktop/ | G-DRIVE ArmorATD | 7GB |

### READMEs placed on every location:
- G-DRIVE: README.md at root
- Google Drive: README_STORAGE.md at root
- iCloud: README_STORAGE.md at root
- All other READMEs staged in iCloud: ASTRA_INTERNAL_TRANSFER/

### Transfer docs for C2:
- README_C2_SUPABASE_BACKEND.md (Supabase backend plan)
- MASTER_BACKUP_LOCATIONS.md (full location table)
- Both in: GDrive CLAUDE_CODE_KERNEL/ + 04_CLAUDE_DOCS/ + BONUS_SATURNO_C2_TRANSFER/ + iCloud ASTRA_INTERNAL_TRANSFER/

### Grand total archived: ~583GB (522GB cloud offload + 61GB Desktop/Downloads)
