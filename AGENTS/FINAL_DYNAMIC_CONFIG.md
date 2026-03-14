# PROMPT HARVESTER — DYNAMIC CONFIG
## File: ~/dev/astra-command-center/AGENTS/harvester-config.json
## Agent reads this ONCE per cycle. Writes back at cycle end. Never stores static logic here.

---

## INITIAL STRUCTURE (create this file on first run if missing)

```json
{
  "version": 2,
  "schema_version": 1,
  "last_cycle": 0,
  "last_commit": "",
  "last_run": "",
  "total_injected": 0,
  "total_agents_created": 0,
  "compact_summary": null,

  "locations": {
    "LOC_01_APPLE_NOTES": {
      "type": "sqlite",
      "path": "~/Library/Group Containers/group.com.apple.notes/NoteStore.sqlite",
      "query": "SELECT Z_PK, ZTITLE, ZSUMMARY FROM ZICCLOUDSYNCINGOBJECT WHERE ZTITLE IS NOT NULL AND (ZTITLE LIKE '%prompt%' OR ZTITLE LIKE '%kernel%' OR ZTITLE LIKE '%agent%' OR ZSUMMARY LIKE '%ROLE%' OR ZSUMMARY LIKE '%system%')",
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_02_PINNED_NOTES": {
      "type": "sqlite",
      "path": "~/Library/Group Containers/group.com.apple.notes/NoteStore.sqlite",
      "query": "SELECT Z_PK, ZTITLE, ZSUMMARY FROM ZICCLOUDSYNCINGOBJECT WHERE ZISPINNED = 1 AND ZTITLE IS NOT NULL",
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_03_KORTEX": {
      "type": "find",
      "path": "~",
      "pattern": "*kortex*prompt*",
      "maxdepth": 5,
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_04_SATURNO_VAULT": {
      "type": "find",
      "path": "~",
      "pattern": "*saturno*prompt*vault*",
      "maxdepth": 6,
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_05_PROMPT_JSON": {
      "type": "find",
      "path": "~",
      "pattern": "*prompt*.json",
      "maxdepth": 6,
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_06_BBEDIT": {
      "type": "grep",
      "path": "~/Library/Application Support/BBEdit",
      "extensions": ["txt", "md"],
      "keywords": ["prompt", "kernel", "ROLE", "You are", "system"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_07_CRAFT": {
      "type": "find",
      "path": "~/Library/Containers/com.lukilabs.lukiapp",
      "pattern": "*.md",
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_08_GDRIVE": {
      "type": "grep",
      "path": "~/Library/CloudStorage/GoogleDrive-gabo@saturnomovement.com",
      "extensions": ["md", "txt", "json"],
      "keywords": ["prompt", "kernel", "ROLE", "You are"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_09_WHISPER": {
      "type": "find",
      "path": "~",
      "pattern": "*whisper*",
      "maxdepth": 5,
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_10_CLAUDE_PROJECTS": {
      "type": "find",
      "path": "~/.claude",
      "pattern": "*.md",
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_11_NOTION": {
      "type": "find",
      "path": "~/Downloads",
      "pattern": "*notion*",
      "extensions": ["md", "csv"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_12_DESKTOP": {
      "type": "grep",
      "path": "~/Desktop",
      "extensions": ["md", "txt", "json"],
      "keywords": ["ROLE", "You are", "prompt", "NEVER STOP", "kernel"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_13_DOWNLOADS": {
      "type": "grep",
      "path": "~/Downloads",
      "extensions": ["md", "txt", "json"],
      "keywords": ["ROLE", "You are", "prompt", "NEVER STOP", "kernel"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_14_DEV": {
      "type": "grep",
      "path": "~/dev",
      "extensions": ["md", "json"],
      "keywords": ["prompt", "kernel", "ROLE", "You are", "system"],
      "exclude": ["node_modules", ".git"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_15_ICLOUD": {
      "type": "grep",
      "path": "~/Library/Mobile Documents",
      "extensions": ["md", "txt", "json"],
      "keywords": ["prompt", "kernel", "ROLE", "You are"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    },
    "LOC_16_ASTRA_REPO": {
      "type": "grep",
      "path": "~/dev/astra-command-center",
      "extensions": ["md", "json"],
      "keywords": ["prompt", "kernel", "ROLE"],
      "exclude": ["node_modules", ".git", "AGENTS"],
      "last_scanned": null,
      "prompts_found": 0,
      "consecutive_low": 0,
      "yield_rate": 1.0,
      "status": "active"
    }
  },

  "discovered_locations": [],

  "metrics": {
    "prompts_per_location": {},
    "duplicate_rate_per_location": {},
    "category_distribution": {},
    "injection_failures": 0,
    "new_locations_discovered": 0
  },

  "discovered_categories": [],
  "improvement_notes": [],
  "known_failures": [],
  "pending_retries": [],
  "schema_evolution": []
}
```

---

## WHAT THE AGENT READS FROM THIS FILE PER CYCLE

- `last_cycle` → resume point
- `locations` → which to scan, smart-skip logic
- `discovered_locations` → additional scan targets
- `pending_retries` → files that failed last time, retry first
- `compact_summary` → if set, resume from that state
- `metrics` → yield rates for smart-skip decisions

## WHAT THE AGENT WRITES BACK PER CYCLE

- `last_cycle` → increment
- `last_run` → timestamp
- `last_commit` → git hash after push
- `total_injected` → running total
- `total_agents_created` → running total
- `locations[id].last_scanned` → timestamp
- `locations[id].yield_rate` → recalculated
- `locations[id].consecutive_low` → increment/reset
- `locations[id].prompts_found` → running total
- `discovered_locations` → append new paths found
- `metrics` → update all 5
- `compact_summary` → write before compaction
- `known_failures` → append if location errors
- `improvement_notes` → append if new patterns found

## WHAT NEVER GOES IN THIS FILE

- Loop logic
- Schema definition
- Injection code
- Rules
- Static instructions
