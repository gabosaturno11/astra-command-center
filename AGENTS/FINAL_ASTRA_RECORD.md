# PROMPT HARVESTER — ASTRA RECORD
## Save this as a KB entry in ASTRA under project: proj_saturno_command
## KB ID: kb_prompt_harvester_agent
## This is for visibility, reuse, and manual recreation. NOT for runtime.

---

**Agent Name:** PROMPT HARVESTER
**Version:** 2.0
**Category:** agents
**Status:** Active
**Created:** 2026-03-14

---

## PURPOSE

Recursively harvests every prompt on the machine, normalizes to a unified schema, injects into ASTRA's prompt vault, detects agent-shaped prompts and creates activation commands, and runs forever without supervision.

---

## WHAT IT DOES

1. Reads 16 seed locations + all dynamically discovered locations
2. Extracts prompt text from each source
3. Normalizes to unified schema (title, summary, body, category, tags, source)
4. Dedupes via MD5 hash (never re-injects same prompt)
5. Injects into ASTRA `index.html` → `goldMinePrompts` array
6. Detects agent specs → creates `AGENTS/<NAME>.md` + activation prompt in ASTRA
7. Discovers new locations every cycle → grows search map permanently
8. Commits + pushes every 2 passes
9. Writes compact handoff before context limit → next session resumes cleanly
10. Tracks yield rate per location → skips low-yield locations every N cycles (never permanently)

---

## LOCATIONS (seed — grows automatically)

| ID | Source | Type |
|----|--------|------|
| LOC_01 | Apple Notes SQLite | sqlite query |
| LOC_02 | Apple Notes Pinned | sqlite query |
| LOC_03 | kortex-prompt-library | find |
| LOC_04 | Saturno Prompt Vault | find |
| LOC_05 | All *prompt*.json files | find |
| LOC_06 | BBEdit documents | grep |
| LOC_07 | Craft App | find |
| LOC_08 | Google Drive | grep |
| LOC_09 | Whisper transcripts | find |
| LOC_10 | Claude Projects ~/.claude | find |
| LOC_11 | Notion exports | find |
| LOC_12 | Desktop | grep |
| LOC_13 | Downloads | grep |
| LOC_14 | ~/dev repos | grep |
| LOC_15 | iCloud Documents | grep |
| LOC_16 | ASTRA repo | grep |
| LOC_DYNAMIC | All discovered locations | auto-expanding |

---

## RULES SUMMARY

- NEVER STOP under any condition
- NEVER ASK for permission
- NEVER treat "spec created" as mission complete
- NEVER use sub-agents if it causes workflow to stop
- NEVER read static engine spec every cycle
- ALWAYS continue after any failure
- ALWAYS dedupe by hash (not by rereading ASTRA)
- ALWAYS inject into `goldMinePrompts` in `index.html`
- ALWAYS commit every 2 passes
- ALWAYS write compact handoff before compaction

---

## LOG LOCATION

```
~/dev/astra-command-center/AGENTS/harvest.log
```

Format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] [LOCATION_ID] [ACTION] message`

---

## CONFIG LOCATION

```
~/dev/astra-command-center/AGENTS/harvester-config.json
```

---

## HASH DB LOCATION

```
~/dev/astra-command-center/AGENTS/harvest-hashes.txt
```

---

## ACTIVATION COMMAND

```
Read ~/dev/astra-command-center/AGENTS/FINAL_STATIC_ENGINE.md and execute it completely. NEVER STOP.
```

---

## ONE-SHOT RECREATION COMMAND

If the agent needs to be rebuilt from scratch:
```
Read ~/dev/astra-command-center/AGENTS/FINAL_STATIC_ENGINE.md — paste its contents into a new Claude Code agent named "Prompt Harvester". Then run it.
```

---

## HOW TO RESUME AFTER COMPACTION

1. Open Claude Code
2. Run agent "Prompt Harvester"
3. Agent reads `harvester-config.json → compact_summary`
4. Resumes from `compact_summary.resume_instruction`
5. No manual steps needed

Manual resume if needed:
```
Read ~/dev/astra-command-center/AGENTS/harvester-config.json. Resume from last_cycle + 1. Process pending_retries first. NEVER STOP.
```

---

## AGENT CHILDREN (populated as harvester runs)

| Agent Name | File | Activation Command | Created |
|-----------|------|--------------------|---------|
| (auto-populated by harvester) | | | |

---

## DISCOVERED IMPROVEMENTS

(auto-populated by harvester as it learns)

---

## SCHEMA VERSION

**v1** — Fields: `id, title, summary, body, category, tags, source, created, updated, usageCount, lastUsed`

---

## OBSOLETE ARTIFACTS (do not use)

- `PROMPT_HARVESTER_AGENT_SPEC.md` — obsolete
- `PROMPT_HARVESTER_QUICKSTART.md` — obsolete
- `PROMPT_HARVESTER_ONE_COMMAND.md` — obsolete
- `PROMPT_HARVESTER_DEFINITIVE_V1.md` — obsolete
- `PROMPT_HARVESTER.md` (v2 rewrite) — superseded by this architecture
