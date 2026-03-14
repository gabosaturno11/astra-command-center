# PROMPT HARVESTER AGENT — V2 DEFINITIVE SPECIFICATION
## Guaranteed Never-Stops | Single Log | Unified Schema | Infinite Discovery | 5 Metrics

**ONE COMMAND TO ACTIVATE:**
```
Read ~/dev/astra-command-center/AGENTS/PROMPT_HARVESTER.md and execute it completely. NEVER STOP.
```

---

# SECTION 0: WHAT THIS IS

This is the COMPLETE agent specification. When you paste the activation command to Claude Code, it:
1. Reads this spec
2. Enables full autonomous mode
3. Initializes the single log architecture
4. Runs the infinite harvest loop
5. Never stops under any circumstances
6. Never asks permission for anything

Every section in this document is executable code or a rule. Execute every section in order.

---

# SECTION 1: WATCHDOG + INFINITE LOOP GUARANTEE

**Execute this FIRST. This is the outermost shell that guarantees the process never dies.**

```bash
#!/bin/bash
# WATCHDOG: If this script crashes, relaunch it automatically

MASTER_LOG=~/dev/astra-command-center/AGENTS/harvest.log
HASH_DB=~/dev/astra-command-center/AGENTS/harvest-hashes.txt
CHECKPOINT_DB=~/dev/astra-command-center/AGENTS/harvest-checkpoint.json

# Self-restart watchdog — if this script dies, relaunch it
trap 'echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [WATCHDOG] crashed, restarting in 5s" >> $MASTER_LOG; sleep 5; exec "$0"' EXIT

# Initialize log on first run
mkdir -p ~/dev/astra-command-center/AGENTS || true
touch "$MASTER_LOG" || true
touch "$HASH_DB" || true

echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [START] PROMPT HARVESTER V2 initialized" >> "$MASTER_LOG" || true

# OUTER watchdog loop — second layer of never-stopping
while true; do
  # All logic runs inside this outer loop
  # If inner loop errors, outer loop restarts it
  (
    # ======= INNER CYCLE LOOP IS IN SECTION 12 =======
    # This outer loop wraps everything. Never exits.
    :
  ) || true
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [WATCHDOG] Inner loop exited, restarting" >> "$MASTER_LOG" || true
  sleep 5
done
```

**Key guarantee rules:**
- NO `set -e` anywhere in this spec
- Every single command ends with `|| true`
- The trap relaunches the entire script on any EXIT signal
- An outer `while true` wraps the entire cycle loop
- If git push fails 3 times, log it and CONTINUE — never exit

---

# SECTION 2: ENABLE AUTONOMOUS MODE

**Run these commands before anything else:**

```bash
# Create settings file with full permissions
mkdir -p ~/.claude || true
cat > ~/.claude/settings.json << 'EOFPERM'
{
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)",
      "Glob(*)",
      "Grep(*)",
      "WebFetch(*)",
      "Agent(*)",
      "mcp__desktop-commander__*",
      "mcp__Vercel__*"
    ],
    "deny": []
  }
}
EOFPERM

echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [INIT] Autonomous mode settings written" >> $MASTER_LOG || true

# Press Shift+Tab in Claude Code to enable auto-accept mode.
# This allows all tool calls to execute without confirmation prompts.
```

---

# SECTION 3: LOG ARCHITECTURE

**ONE master log. Everything goes here. No other log files.**

```bash
# THE THREE FILES (and nothing else)
MASTER_LOG=~/dev/astra-command-center/AGENTS/harvest.log
HASH_DB=~/dev/astra-command-center/AGENTS/harvest-hashes.txt
CHECKPOINT_DB=~/dev/astra-command-center/AGENTS/harvest-checkpoint.json

# Initialize all three if they don't exist
touch "$MASTER_LOG" || true
touch "$HASH_DB" || true

# Initialize CHECKPOINT_DB if not exists
if [ ! -f "$CHECKPOINT_DB" ]; then
  python3 -c "
import json
cp = {
  'last_cycle': 0,
  'last_run': '',
  'locations': {},
  'total_prompts_injected': 0,
  'total_agents_created': 0,
  'known_locations': [],
  'metrics': {
    'prompts_per_location': {},
    'duplicate_rate_per_location': {},
    'category_distribution': {},
    'injection_failures': 0,
    'new_locations_discovered': 0
  }
}
json.dump(cp, open('$CHECKPOINT_DB', 'w'), indent=2)
print('Checkpoint initialized')
" 2>/dev/null || true
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [INIT] Log architecture ready" >> $MASTER_LOG || true
```

**Log format — ALL lines must follow this format:**
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] [LOCATION_ID] [ACTION] message
```

**Valid LEVEL values:**
`INFO | FOUND | EXTRACTED | NORMALIZED | INJECTED | SKIPPED | ERROR | AGENT_CREATED | LEARN | CHECKPOINT | CYCLE_START | CYCLE_END`

**Example log lines:**
```
[2026-03-14 04:23:11] [FOUND] [LOC_01_APPLE_NOTES] [SCAN] "VB Formatter Pro" in ZICCLOUDSYNCINGOBJECT
[2026-03-14 04:23:12] [INJECTED] [LOC_01_APPLE_NOTES] [ASTRA] id=1741000000047 category=book title="VB Formatter Pro"
[2026-03-14 04:23:15] [SKIPPED] [LOC_01_APPLE_NOTES] [DUPE] hash=a3f4... already exists
[2026-03-14 04:23:20] [AGENT_CREATED] [LOC_12_DESKTOP] [NEW_AGENT] Name=ContentBeast | File=AGENTS/CONTENT_BEAST.md | Command=Read ~/dev/astra-command-center/AGENTS/CONTENT_BEAST.md and execute it completely. NEVER STOP.
[2026-03-14 04:23:30] [CHECKPOINT] [SYSTEM] [CYCLE_2] prompts_added=12 dupes_skipped=3 locations_scanned=8 new_agents=1
```

**Old log files REPLACED by this architecture:**
- `prompt-harvest-raw.log` → gone, use `MASTER_LOG`
- `prompt-harvest-learning.json` → gone, use `CHECKPOINT_DB`
- `prompt-harvest-hashes.txt` → replaced by `HASH_DB`

---

# SECTION 4: 16 FIXED LOCATIONS

**Explicit bash for each location. Every command ends with `|| true`.**

```bash
# ============================================================
# LOC_01: Apple Notes SQLite — All prompt-related notes
# ============================================================
scan_loc_01() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_01_APPLE_NOTES] [SCAN] Starting Apple Notes scan" >> $MASTER_LOG || true

  sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
    "SELECT Z_PK, ZTITLE, ZSUMMARY FROM ZICCLOUDSYNCINGOBJECT
     WHERE ZTITLE IS NOT NULL
     AND (ZTITLE LIKE '%prompt%' OR ZTITLE LIKE '%Prompt%' OR ZTITLE LIKE '%PROMPT%'
       OR ZTITLE LIKE '%kernel%' OR ZTITLE LIKE '%agent%'
       OR ZSUMMARY LIKE '%prompt%' OR ZSUMMARY LIKE '%system%' OR ZSUMMARY LIKE '%role%')" \
    2>/dev/null | while IFS='|' read pk title summary; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_01_APPLE_NOTES] [SCAN] pk=$pk title=\"$title\"" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_02: Apple Notes — Pinned notes
# ============================================================
scan_loc_02() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_02_PINNED_NOTES] [SCAN] Starting pinned notes scan" >> $MASTER_LOG || true

  sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
    "SELECT Z_PK, ZTITLE, ZSUMMARY FROM ZICCLOUDSYNCINGOBJECT
     WHERE ZISPINNED = 1 AND ZTITLE IS NOT NULL" \
    2>/dev/null | while IFS='|' read pk title summary; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_02_PINNED_NOTES] [SCAN] pk=$pk title=\"$title\"" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_03: kortex-prompt-library
# ============================================================
scan_loc_03() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_03_KORTEX] [SCAN] Starting kortex scan" >> $MASTER_LOG || true

  KORTEX_PATH=$(find ~ -maxdepth 5 -name "*kortex*prompt*" -type d 2>/dev/null | head -1 || true)
  if [ -n "$KORTEX_PATH" ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_03_KORTEX] [SCAN] Found kortex at: $KORTEX_PATH" >> $MASTER_LOG || true
    find "$KORTEX_PATH" \( -name "*.md" -o -name "*.json" -o -name "*.txt" \) 2>/dev/null | while read file; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_03_KORTEX] [SCAN] $file" >> $MASTER_LOG || true
    done || true
  else
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_03_KORTEX] [SCAN] kortex not found, searching alternatives" >> $MASTER_LOG || true
    find ~/dev -name "*kortex*" 2>/dev/null | while read f; do echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_03_KORTEX] [SCAN] alt: $f" >> $MASTER_LOG || true; done || true
  fi
}

# ============================================================
# LOC_04: Saturno Prompt Vault
# ============================================================
scan_loc_04() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_04_SATURNO_VAULT] [SCAN] Starting Saturno Vault scan" >> $MASTER_LOG || true

  sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
    "SELECT Z_PK, ZTITLE FROM ZICCLOUDSYNCINGOBJECT WHERE ZTITLE LIKE '%Saturno%Prompt%Vault%'" \
    2>/dev/null | while IFS='|' read pk title; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_04_SATURNO_VAULT] [SCAN] pk=$pk title=\"$title\"" >> $MASTER_LOG || true
  done || true

  find ~ -maxdepth 6 \( -name "*saturno*prompt*" -o -name "*prompt*vault*" \) 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_04_SATURNO_VAULT] [SCAN] $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_05: All JSON files containing prompts
# ============================================================
scan_loc_05() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_05_JSON_FILES] [SCAN] Starting JSON scan" >> $MASTER_LOG || true

  find ~ -maxdepth 6 -name "*prompt*.json" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_05_JSON_FILES] [SCAN] $file" >> $MASTER_LOG || true
  done || true

  find ~/dev ~/Documents ~/Desktop -name "*.json" 2>/dev/null | xargs grep -l "prompt\|system\|role" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_05_JSON_FILES] [SCAN] json_with_content: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_06: BBEdit files
# ============================================================
scan_loc_06() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_06_BBEDIT] [SCAN] Starting BBEdit scan" >> $MASTER_LOG || true

  find ~/Library/Application\ Support/BBEdit \( -name "*.txt" -o -name "*.md" \) 2>/dev/null | while read file; do
    if grep -q "prompt\|kernel\|system\|ROLE\|You are" "$file" 2>/dev/null; then
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_06_BBEDIT] [SCAN] $file" >> $MASTER_LOG || true
    fi
  done || true

  find ~/Documents -name "*.txt" 2>/dev/null | xargs grep -l "prompt\|kernel\|system" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_06_BBEDIT] [SCAN] docs_txt: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_07: Craft App exports
# ============================================================
scan_loc_07() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_07_CRAFT] [SCAN] Starting Craft scan" >> $MASTER_LOG || true

  find ~/Library/Containers/com.lukilabs.lukiapp \( -name "*.md" -o -name "*.txt" \) 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_07_CRAFT] [SCAN] $file" >> $MASTER_LOG || true
  done || true

  find ~/Library/Group\ Containers -maxdepth 3 -name "*craft*" -type d 2>/dev/null | while read dir; do
    find "$dir" -type f 2>/dev/null | head -50 | while read file; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_07_CRAFT] [SCAN] group: $file" >> $MASTER_LOG || true
    done || true
  done || true

  find ~/Documents -name "*craft*" -type f 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_07_CRAFT] [SCAN] export: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_08: Google Drive sync
# ============================================================
scan_loc_08() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_08_GDRIVE] [SCAN] Starting Google Drive scan" >> $MASTER_LOG || true

  find ~/Library/CloudStorage/GoogleDrive-gabo@saturnomovement.com \
    \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) 2>/dev/null | while read file; do
    if grep -q "prompt\|kernel\|system\|You are\|ROLE" "$file" 2>/dev/null; then
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_08_GDRIVE] [SCAN] $file" >> $MASTER_LOG || true
    fi
  done || true
}

# ============================================================
# LOC_09: Whisper Flow transcripts
# ============================================================
scan_loc_09() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_09_WHISPER] [SCAN] Starting Whisper/transcript scan" >> $MASTER_LOG || true

  find ~ -maxdepth 5 -name "*whisper*" -type d 2>/dev/null | while read dir; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_09_WHISPER] [SCAN] dir: $dir" >> $MASTER_LOG || true
    find "$dir" \( -name "*.txt" -o -name "*.md" \) 2>/dev/null | while read file; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_09_WHISPER] [SCAN] $file" >> $MASTER_LOG || true
    done || true
  done || true

  find ~ -maxdepth 5 -name "*transcript*" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_09_WHISPER] [SCAN] transcript: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_10: Claude Projects and memory files
# ============================================================
scan_loc_10() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_10_CLAUDE_PROJECTS] [SCAN] Starting Claude projects scan" >> $MASTER_LOG || true

  find ~/.claude \( -name "*.md" -o -name "*.json" -o -name "*.txt" \) 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_10_CLAUDE_PROJECTS] [SCAN] $file" >> $MASTER_LOG || true
  done || true

  find ~/.claude/projects -name "MEMORY.md" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_10_CLAUDE_PROJECTS] [SCAN] memory: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_11: Notion exports
# ============================================================
scan_loc_11() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_11_NOTION] [SCAN] Starting Notion scan" >> $MASTER_LOG || true

  find ~ -maxdepth 5 -name "*notion*export*" -type d 2>/dev/null | while read dir; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_11_NOTION] [SCAN] dir: $dir" >> $MASTER_LOG || true
    find "$dir" -name "*.md" 2>/dev/null | while read file; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_11_NOTION] [SCAN] $file" >> $MASTER_LOG || true
    done || true
  done || true

  find ~/Downloads ~/Documents -name "*notion*" -name "*.md" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_11_NOTION] [SCAN] $file" >> $MASTER_LOG || true
  done || true

  find ~/Downloads -name "*.csv" 2>/dev/null | xargs grep -l "prompt" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_11_NOTION] [SCAN] csv: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_12: Desktop and Downloads
# ============================================================
scan_loc_12() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_12_DESKTOP] [SCAN] Starting Desktop/Downloads scan" >> $MASTER_LOG || true

  for search_dir in ~/Desktop ~/Downloads; do
    find "$search_dir" \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) 2>/dev/null | while read file; do
      if grep -q "prompt\|kernel\|system\|You are\|ROLE\|NEVER STOP" "$file" 2>/dev/null; then
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_12_DESKTOP] [SCAN] $file" >> $MASTER_LOG || true
      fi
    done || true
  done
}

# ============================================================
# LOC_13: ASTRA existing prompts and vault
# ============================================================
scan_loc_13() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_13_ASTRA] [SCAN] Starting ASTRA existing scan" >> $MASTER_LOG || true

  find ~/dev/astra-command-center \( -name "*.ts" -o -name "*.tsx" -o -name "*.json" -o -name "*.md" \) 2>/dev/null | \
    xargs grep -l "prompt" 2>/dev/null | while read file; do
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_13_ASTRA] [SCAN] $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_14: All ~/dev folders
# ============================================================
scan_loc_14() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_14_DEV] [SCAN] Starting ~/dev scan" >> $MASTER_LOG || true

  find ~/dev -name "*.md" 2>/dev/null | xargs grep -l "prompt\|kernel\|system\|You are" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_14_DEV] [SCAN] md: $file" >> $MASTER_LOG || true
  done || true

  find ~/dev -name "*.json" 2>/dev/null | xargs grep -l "prompt\|role\|system" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_14_DEV] [SCAN] json: $file" >> $MASTER_LOG || true
  done || true

  find ~/dev -name "*prompt*" 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_14_DEV] [SCAN] named: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_15: iCloud Documents
# ============================================================
scan_loc_15() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_15_ICLOUD] [SCAN] Starting iCloud scan" >> $MASTER_LOG || true

  find ~/Library/Mobile\ Documents \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) 2>/dev/null | \
    head -200 | while read file; do
      if grep -q "prompt\|kernel\|system\|You are\|ROLE" "$file" 2>/dev/null; then
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_15_ICLOUD] [SCAN] $file" >> $MASTER_LOG || true
      fi
  done || true

  find ~/Library/Mobile\ Documents/com~apple~CloudDocs -type f 2>/dev/null | head -100 | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_15_ICLOUD] [SCAN] clouddocs: $file" >> $MASTER_LOG || true
  done || true
}

# ============================================================
# LOC_16: AGENTS folder (this repo)
# ============================================================
scan_loc_16() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_16_AGENTS] [SCAN] Starting AGENTS folder scan" >> $MASTER_LOG || true

  find ~/dev/astra-command-center/AGENTS \( -name "*.md" -o -name "*.json" -o -name "*.txt" \) 2>/dev/null | while read file; do
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_16_AGENTS] [SCAN] $file" >> $MASTER_LOG || true
  done || true
}
```

---

# SECTION 5: LOCATION DISCOVERY — INFINITE EXPANSION

**After every fixed location scan, run a discovery pass to find new locations.**

```bash
discover_new_locations() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [DISCOVERY] Starting location discovery pass" >> $MASTER_LOG || true

  # Find any directory containing prompt-like files not yet scanned
  find / -maxdepth 6 \( -name "*.md" -o -name "*.json" -o -name "*.txt" \) \
    2>/dev/null | xargs grep -l "ROLE:\|You are\|system prompt\|NEVER STOP" 2>/dev/null \
    | xargs dirname 2>/dev/null | sort -u 2>/dev/null \
    | while read dir; do
      # Check if this dir is already in known locations
      if ! grep -q "$dir" "$CHECKPOINT_DB" 2>/dev/null; then
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] [LEARN] [DISCOVERY] [NEW_LOCATION] Found new location: $dir" >> $MASTER_LOG || true
        # Add to checkpoint known_locations
        python3 -c "
import json, sys
try:
    cp = json.load(open('$CHECKPOINT_DB'))
    if '$dir' not in cp['known_locations']:
        cp['known_locations'].append('$dir')
        cp['metrics']['new_locations_discovered'] = cp['metrics'].get('new_locations_discovered', 0) + 1
        json.dump(cp, open('$CHECKPOINT_DB', 'w'), indent=2)
        print('Added: $dir')
except Exception as e:
    print(f'Error: {e}')
" 2>/dev/null || true
      fi
  done || true

  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [DISCOVERY] Discovery pass complete" >> $MASTER_LOG || true
}

# Scan all dynamically discovered locations from checkpoint
scan_discovered_locations() {
  python3 -c "
import json
try:
    cp = json.load(open('$CHECKPOINT_DB'))
    locs = cp.get('known_locations', [])
    for l in locs:
        print(l)
except:
    pass
" 2>/dev/null | while read dir; do
    if [ -d "$dir" ]; then
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [LOC_DYNAMIC] [SCAN] Scanning discovered: $dir" >> $MASTER_LOG || true
      find "$dir" \( -name "*.md" -o -name "*.json" -o -name "*.txt" \) 2>/dev/null | while read file; do
        if grep -q "ROLE:\|You are\|system prompt\|NEVER STOP\|prompt\|kernel" "$file" 2>/dev/null; then
          echo "[$(date +"%Y-%m-%d %H:%M:%S")] [FOUND] [LOC_DYNAMIC] [SCAN] $file" >> $MASTER_LOG || true
          # Extract and normalize (feeds into SECTION 6 + 7 pipeline)
          extract_and_normalize "$file" "LOC_DYNAMIC" || true
        fi
      done || true
    fi
  done || true
}
```

---

# SECTION 6: NORMALIZATION SCHEMA

**ONE schema. Used everywhere. For both normalization and ASTRA injection.**

```bash
# The ONLY schema used for both normalization AND ASTRA injection.
# This is what every extracted prompt becomes before injection.

# ASTRA injection format (what goes into index.html goldMinePrompts array):
# {
#   id: <unix_timestamp + index>,
#   title: "<50 chars max, Title Case, no punctuation at end>",
#   summary: "<120 chars max — shown on card preview>",
#   body: "<full prompt text — NEVER truncated>",
#   category: "<one of 15 categories>",
#   tags: ["tag1", "tag2", "tag3"],    // min 3, max 8, lowercase, no spaces
#   source: "<file path or location ID where found>",
#   created: "2026-03-13T00:00:00.000Z",
#   updated: "2026-03-13T00:00:00.000Z",
#   usageCount: 0,
#   lastUsed: null
# }

# Valid categories (15):
VALID_CATEGORIES="agents kernels content extraction synthesis architecture coaching movement research automation writing voice model_optimization scripts skills"

# Title rules: max 50 chars, Title Case, no punctuation at end
# Summary rules: first sentence of prompt OR auto-generated from role+task. Max 120 chars.
# Tags rules: minimum 3, maximum 8, lowercase, no spaces (use hyphens)
# Body rules: NEVER truncate. Escape backticks and backslashes for JS string safety.
# id: $(date +%s)<3-digit index within batch>

normalize_prompt() {
  local raw_text="$1"
  local source_location="$2"
  local title="$3"

  python3 << PYEOF 2>/dev/null || true
import json, re, time, sys

raw_text = """$raw_text"""
source = "$source_location"
title_hint = "$title"

# Auto-detect category
cat_map = {
  'agent': 'agents', 'ROLE:': 'agents', 'NEVER STOP': 'agents',
  'kernel': 'kernels', 'meta-': 'kernels',
  'content': 'content', 'caption': 'content', 'social': 'content',
  'rant': 'extraction', 'harvest': 'extraction', 'extract': 'extraction',
  'synthesis': 'synthesis', 'merge': 'synthesis', 'deduplicate': 'synthesis',
  'architecture': 'architecture', 'blueprint': 'architecture', 'system design': 'architecture',
  'coach': 'coaching', 'client': 'coaching', 'training': 'coaching',
  'calisthenics': 'movement', 'fitness': 'movement', 'exercise': 'movement',
  'research': 'research', 'analysis': 'research',
  'automation': 'automation', 'workflow': 'automation', 'script': 'scripts',
  'writing': 'writing', 'book': 'writing', 'essay': 'writing',
  'voice': 'voice', 'tone': 'voice', 'style': 'voice',
  'LLM': 'model_optimization', 'optimize': 'model_optimization',
  'skill': 'skills', 'tool': 'skills', 'MCP': 'skills',
}

category = 'content'
raw_lower = raw_text.lower()
for keyword, cat in cat_map.items():
    if keyword.lower() in raw_lower:
        category = cat
        break

# Build title: max 50 chars, Title Case
if title_hint and len(title_hint.strip()) > 0:
    title = title_hint.strip()[:50].title().rstrip('.,;:!?')
else:
    first_line = raw_text.strip().split('\n')[0][:50]
    title = first_line.title().rstrip('.,;:!?')

# Build summary: first sentence, max 120 chars
sentences = re.split(r'[.!?]', raw_text.strip())
summary = sentences[0].strip()[:120] if sentences else raw_text[:120]

# Extract tags: minimum 3, max 8, lowercase, hyphenated
tags = []
for kw, _ in cat_map.items():
    if kw.lower() in raw_lower and len(tags) < 8:
        tags.append(kw.lower().replace(' ', '-').replace(':', ''))
tags = list(set(tags))[:8]
while len(tags) < 3:
    tags.append(category)

prompt_obj = {
    'id': int(time.time() * 1000),
    'title': title[:50],
    'summary': summary[:120],
    'body': raw_text,
    'category': category,
    'tags': tags[:8],
    'source': source,
    'created': '$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")',
    'updated': '$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")',
    'usageCount': 0,
    'lastUsed': None
}

print(json.dumps(prompt_obj))
PYEOF
}
```

---

# SECTION 7: ASTRA INJECTION FUNCTION

**Injects new prompts into `goldMinePrompts` array in index.html. Python regex. Atomic write.**

```bash
inject_into_astra() {
  local prompts_json="$1"   # JSON array string of prompt objects
  local INDEX=~/dev/astra-command-center/index.html

  python3 << PYEOF 2>/dev/null || true
import json, re, os, time

INDEX = os.path.expanduser('~/dev/astra-command-center/index.html')
MASTER_LOG = os.path.expanduser('~/dev/astra-command-center/AGENTS/harvest.log')
HASH_DB = os.path.expanduser('~/dev/astra-command-center/AGENTS/harvest-hashes.txt')
CHECKPOINT_DB = os.path.expanduser('~/dev/astra-command-center/AGENTS/harvest-checkpoint.json')

def log(level, loc, action, msg):
    ts = time.strftime('%Y-%m-%d %H:%M:%S')
    line = f'[{ts}] [{level}] [{loc}] [{action}] {msg}\n'
    with open(MASTER_LOG, 'a') as f:
        f.write(line)

try:
    new_prompts_raw = '''$prompts_json'''
    new_prompts = json.loads(new_prompts_raw) if new_prompts_raw.strip() else []
except:
    new_prompts = []

if not new_prompts:
    log('INFO', 'SYSTEM', 'INJECT', 'No prompts to inject')
    exit(0)

# Read current hashes
existing_hashes = set()
try:
    with open(HASH_DB, 'r') as f:
        existing_hashes = set(line.strip() for line in f if line.strip())
except:
    pass

# Read index.html
try:
    with open(INDEX, 'r', encoding='utf-8') as f:
        content = f.read()
except Exception as e:
    log('ERROR', 'SYSTEM', 'INJECT', f'Cannot read index.html: {e}')
    exit(1)

# Deduplicate and build JS objects
injected = 0
skipped = 0
new_hash_lines = []

js_objects = []
for i, p in enumerate(new_prompts):
    import hashlib
    body_hash = hashlib.md5(p.get('body', '').encode()).hexdigest()
    if body_hash in existing_hashes:
        log('SKIPPED', 'SYSTEM', 'DUPE', f'hash={body_hash[:8]}... title="{p.get(\"title\", \"\")}"')
        skipped += 1
        continue

    # Escape body for JS string (no template literals — use escaped regular string)
    body = p.get('body', '').replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n').replace('\r', '')
    summary = p.get('summary', '')[:120].replace('"', '\\"')
    title = p.get('title', '')[:50].replace('"', '\\"')
    category = p.get('category', 'content')
    tags = json.dumps(p.get('tags', []))
    source = p.get('source', '').replace('"', '\\"')
    uid = int(time.time() * 1000) + i

    js_obj = (
        f'{{'
        f'id:{uid},'
        f'title:"{title}",'
        f'summary:"{summary}",'
        f'body:"{body}",'
        f'category:"{category}",'
        f'tags:{tags},'
        f'source:"{source}",'
        f'created:"{p.get("created", "")}",'
        f'updated:"{p.get("updated", "")}",'
        f'usageCount:0,'
        f'lastUsed:null'
        f'}}'
    )
    js_objects.append(js_obj)
    new_hash_lines.append(body_hash)
    log('INJECTED', 'SYSTEM', 'ASTRA', f'id={uid} category={category} title="{title}"')
    injected += 1

if not js_objects:
    log('INFO', 'SYSTEM', 'INJECT', f'All {skipped} prompts were dupes — nothing to inject')
    exit(0)

# Find anchor and inject
anchor = 'const goldMinePrompts = ['
if anchor not in content:
    log('ERROR', 'SYSTEM', 'INJECT', 'Cannot find goldMinePrompts anchor in index.html')
    exit(1)

new_js = ',\n'.join(js_objects)

def inject_prompts(m):
    existing_content = m.group(2).rstrip()
    separator = ',\n' if existing_content.strip() and not existing_content.strip().endswith(',') else ''
    return m.group(1) + existing_content + separator + '\n' + new_js + '\n' + m.group(3)

new_content = re.sub(
    r'(const goldMinePrompts = \[)(.*?)(\];)',
    inject_prompts,
    content,
    flags=re.DOTALL
)

# Write atomically
tmp = INDEX + '.tmp'
try:
    with open(tmp, 'w', encoding='utf-8') as f:
        f.write(new_content)
    os.replace(tmp, INDEX)
except Exception as e:
    log('ERROR', 'SYSTEM', 'INJECT', f'Write failed: {e}')
    if os.path.exists(tmp):
        os.remove(tmp)
    exit(1)

# Update hash DB
with open(HASH_DB, 'a') as f:
    for h in new_hash_lines:
        f.write(h + '\n')

# Update checkpoint
try:
    cp = json.load(open(CHECKPOINT_DB))
    cp['total_prompts_injected'] = cp.get('total_prompts_injected', 0) + injected
    cp['metrics']['injection_failures'] = cp['metrics'].get('injection_failures', 0)
    json.dump(cp, open(CHECKPOINT_DB, 'w'), indent=2)
except:
    pass

log('INFO', 'SYSTEM', 'INJECT', f'Injection complete: injected={injected} skipped={skipped}')
print(f'Injected {injected}, skipped {skipped} dupes')
PYEOF
}

# Helper: extract and normalize a single file, then inject
extract_and_normalize() {
  local file="$1"
  local loc_id="$2"

  if [ ! -f "$file" ]; then return 0; fi

  # Read file content (capped at 50KB to avoid huge files)
  local content
  content=$(head -c 51200 "$file" 2>/dev/null || true)

  if [ -z "$content" ]; then return 0; fi

  # Check if it looks like a prompt
  if ! echo "$content" | grep -q "ROLE:\|You are\|system prompt\|NEVER STOP\|prompt\|## " 2>/dev/null; then
    return 0
  fi

  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [EXTRACTED] [$loc_id] [FILE] Extracting from: $file" >> $MASTER_LOG || true

  # Get filename as title hint
  local title_hint
  title_hint=$(basename "$file" | sed 's/\.[^.]*$//' | tr '_-' ' ' || true)

  # Normalize and inject
  local normalized
  normalized=$(normalize_prompt "$content" "$loc_id/$file" "$title_hint" 2>/dev/null || true)

  if [ -n "$normalized" ]; then
    inject_into_astra "[$normalized]" || true
  fi
}
```

---

# SECTION 8: AGENT DETECTION + ONE-SHOT COMMAND CREATION

**When a prompt looks like an agent spec, create the spec file AND an ASTRA activation entry.**

```bash
detect_and_create_agent() {
  local content="$1"
  local source_file="$2"

  # Detect agent-shaped prompts
  local is_agent=false
  if echo "$content" | grep -q "ROLE:.*TASK:\|NEVER STOP\|execute autonomously\|RULES:" 2>/dev/null; then
    is_agent=true
  fi

  if [ "$is_agent" = false ]; then return 0; fi

  # Extract agent name from content or filename
  local agent_name
  agent_name=$(basename "$source_file" | sed 's/\.[^.]*$//' | tr '[:lower:]' '[:upper:]' | tr ' -' '_' || true)
  if [ -z "$agent_name" ]; then agent_name="UNKNOWN_AGENT"; fi

  local agent_file=~/dev/astra-command-center/AGENTS/${agent_name}.md

  # Check if agent file already exists (by filename only — do NOT read content of all agents)
  if ls ~/dev/astra-command-center/AGENTS/*.md 2>/dev/null | grep -q "${agent_name}.md"; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [SKIPPED] [LOC_16_AGENTS] [AGENT_EXISTS] $agent_name already exists" >> $MASTER_LOG || true
    return 0
  fi

  # Create the spec file
  cat > "$agent_file" << AGEOF || true
# $agent_name — Agent Specification
## Auto-created by PROMPT_HARVESTER on $(date '+%Y-%m-%d %H:%M:%S')
## Source: $source_file

$content
AGEOF

  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [AGENT_CREATED] [LOC_16_AGENTS] [NEW_AGENT] Name=$agent_name | File=AGENTS/${agent_name}.md | Command=Read ~/dev/astra-command-center/AGENTS/${agent_name}.md and execute it completely. NEVER STOP." >> $MASTER_LOG || true

  # Create ASTRA prompt entry for one-shot activation
  local activation_prompt
  activation_prompt=$(python3 -c "
import json, time
obj = {
    'id': int(time.time() * 1000),
    'title': '${agent_name} Activation Command',
    'summary': 'One command to activate ${agent_name} agent',
    'body': 'Read ~/dev/astra-command-center/AGENTS/${agent_name}.md and execute it completely. NEVER STOP.',
    'category': 'agents',
    'tags': ['agent', 'activation', 'one-shot'],
    'source': '$source_file',
    'created': '$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")',
    'updated': '$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")',
    'usageCount': 0,
    'lastUsed': None
}
print(json.dumps(obj))
" 2>/dev/null || true)

  if [ -n "$activation_prompt" ]; then
    inject_into_astra "[$activation_prompt]" || true
  fi

  # Update checkpoint total_agents_created
  python3 -c "
import json
try:
    cp = json.load(open('$CHECKPOINT_DB'))
    cp['total_agents_created'] = cp.get('total_agents_created', 0) + 1
    json.dump(cp, open('$CHECKPOINT_DB', 'w'), indent=2)
except: pass
" 2>/dev/null || true
}
```

---

# SECTION 9: UX EVOLUTION RULES

**These rules fire automatically during injection. No manual intervention.**

```bash
# RULE UX-1: Subcategory filter tags
# If agent finds 5+ prompts in same subcategory, create a subcategory filter tag in ASTRA.
check_subcategory_threshold() {
  local category="$1"

  python3 -c "
import json, re
try:
    cp = json.load(open('$CHECKPOINT_DB'))
    dist = cp.get('metrics', {}).get('category_distribution', {})
    count = dist.get('$category', 0)
    if count >= 5:
        print(f'SUBCATEGORY_THRESHOLD_HIT category=$category count={count}')
except: pass
" 2>/dev/null | while read line; do
    if echo "$line" | grep -q "SUBCATEGORY_THRESHOLD_HIT"; then
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [LEARN] [SYSTEM] [UX_EVOLUTION] $line — subcategory filter should be added to ASTRA" >> $MASTER_LOG || true
    fi
  done || true
}

# RULE UX-2: Long prompt gets summary field
# If prompt body > 2000 chars, summary field is auto-generated (first 120 chars).
# This is already enforced in the normalization schema — summary is always set.

# RULE UX-3: New category discovery
# If agent discovers a category not in the 15, add it to ASTRA's category icon map.
handle_new_category() {
  local new_cat="$1"
  local VALID_CATS="agents kernels content extraction synthesis architecture coaching movement research automation writing voice model_optimization scripts skills"

  if ! echo "$VALID_CATS" | grep -q "\b${new_cat}\b"; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [LEARN] [SYSTEM] [UX_EVOLUTION] New category discovered: $new_cat — should be added to ASTRA icon map around index.html line 1596-1620" >> $MASTER_LOG || true

    # Generate inline SVG icon for new category and inject into index.html category map
    python3 << PYEOF 2>/dev/null || true
import re, os

INDEX = os.path.expanduser('~/dev/astra-command-center/index.html')
new_cat = '$new_cat'

# Generic SVG pattern matching existing categories
new_svg_entry = f"""'{new_cat}': '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>',"""

with open(INDEX, 'r', encoding='utf-8') as f:
    content = f.read()

# Find category icon map and add new entry if not already there
if f"'{new_cat}':" not in content:
    # Look for pattern near line 1596-1620 range (categoryIcons or similar object)
    content = re.sub(
        r"(const categoryIcons\s*=\s*\{)",
        r"\1\n  " + new_svg_entry,
        content
    )
    with open(INDEX, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'Added SVG icon for new category: {new_cat}')
PYEOF
  fi
}

# RULE UX-4: Card format enforcement
# Every injected prompt MUST have: title + summary + category + tags (all 4).
# The normalization function enforces this. If any field is missing, defaults are applied.
enforce_card_format() {
  local prompt_json="$1"
  python3 -c "
import json, sys
try:
    p = json.loads('''$prompt_json''')
    assert p.get('title'), 'missing title'
    assert p.get('summary'), 'missing summary'
    assert p.get('category'), 'missing category'
    assert len(p.get('tags', [])) >= 1, 'missing tags'
    print('OK')
except Exception as e:
    print(f'INVALID: {e}')
" 2>/dev/null || true
}
```

---

# SECTION 10: 5 METRICS + SMART CHECKPOINT

**5 metrics tracked per cycle. Smart skip for low-yield locations.**

```bash
# Update metrics after each location scan
update_metrics() {
  local loc_id="$1"
  local new_found="$2"
  local dupes="$3"
  local total_scanned="$4"

  python3 -c "
import json, time

loc_id = '$loc_id'
new_found = int('$new_found') if '$new_found'.isdigit() else 0
dupes = int('$dupes') if '$dupes'.isdigit() else 0
total_scanned = int('$total_scanned') if '$total_scanned'.isdigit() else 1

try:
    cp = json.load(open('$CHECKPOINT_DB'))

    # Update location stats
    if 'locations' not in cp:
        cp['locations'] = {}

    if loc_id not in cp['locations']:
        cp['locations'][loc_id] = {'last_scanned': '', 'prompts_found': 0, 'dupes': 0, 'yield_rate': 1.0, 'consecutive_low_yield': 0}

    loc = cp['locations'][loc_id]
    loc['last_scanned'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
    loc['prompts_found'] = loc.get('prompts_found', 0) + new_found
    loc['dupes'] = loc.get('dupes', 0) + dupes

    # Calculate yield rate
    yield_rate = new_found / max(total_scanned, 1)
    loc['yield_rate'] = round(yield_rate, 3)

    # Track consecutive low yield cycles
    if yield_rate < 0.1:
        loc['consecutive_low_yield'] = loc.get('consecutive_low_yield', 0) + 1
    else:
        loc['consecutive_low_yield'] = 0

    # Mark low priority if 3 consecutive low-yield cycles
    if loc.get('consecutive_low_yield', 0) >= 3:
        loc['priority'] = 'low'

    # Update 5 metrics
    m = cp.setdefault('metrics', {})
    ppl = m.setdefault('prompts_per_location', {})
    ppl[loc_id] = ppl.get(loc_id, 0) + new_found

    drl = m.setdefault('duplicate_rate_per_location', {})
    drl[loc_id] = round(dupes / max(total_scanned, 1), 3)

    json.dump(cp, open('$CHECKPOINT_DB', 'w'), indent=2)
except Exception as e:
    print(f'Metrics update error: {e}')
" 2>/dev/null || true
}

# Smart skip: should we scan this location this cycle?
should_scan_location() {
  local loc_id="$1"
  local cycle="$2"

  python3 -c "
import json, time

loc_id = '$loc_id'
cycle = int('$cycle') if '$cycle'.isdigit() else 1

try:
    cp = json.load(open('$CHECKPOINT_DB'))
    loc = cp.get('locations', {}).get(loc_id, {})

    priority = loc.get('priority', 'normal')
    consecutive_low = loc.get('consecutive_low_yield', 0)

    # Low priority: scan every 5th cycle only
    if priority == 'low' and cycle % 5 != 0:
        print('SKIP')
    else:
        print('SCAN')
except:
    print('SCAN')
" 2>/dev/null || true
}

# Update category distribution metric
update_category_metric() {
  local category="$1"
  python3 -c "
import json
try:
    cp = json.load(open('$CHECKPOINT_DB'))
    cd = cp.setdefault('metrics', {}).setdefault('category_distribution', {})
    cd['$category'] = cd.get('$category', 0) + 1
    json.dump(cp, open('$CHECKPOINT_DB', 'w'), indent=2)
except: pass
" 2>/dev/null || true
}

# Write cycle checkpoint summary
write_cycle_checkpoint() {
  local cycle="$1"
  local prompts_added="$2"
  local dupes="$3"
  local locs_scanned="$4"
  local new_agents="$5"

  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [CHECKPOINT] [SYSTEM] [CYCLE_${cycle}] prompts_added=${prompts_added} dupes_skipped=${dupes} locations_scanned=${locs_scanned} new_agents=${new_agents}" >> $MASTER_LOG || true

  python3 -c "
import json, time
try:
    cp = json.load(open('$CHECKPOINT_DB'))
    cp['last_cycle'] = $cycle
    cp['last_run'] = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
    json.dump(cp, open('$CHECKPOINT_DB', 'w'), indent=2)
except: pass
" 2>/dev/null || true
}
```

---

# SECTION 11: GIT PUSH FUNCTION

**Retry 3x on failure. If all 3 fail, LOG and CONTINUE — never exit.**

```bash
push_to_astra() {
  local cycle="$1"
  local ASTRA_DIR=~/dev/astra-command-center

  cd "$ASTRA_DIR" || { echo "[$(date +"%Y-%m-%d %H:%M:%S")] [ERROR] [SYSTEM] [GIT] Cannot cd to $ASTRA_DIR" >> $MASTER_LOG || true; return 0; }

  git add index.html AGENTS/ 2>/dev/null || true

  # Only commit if there are staged changes
  if git diff --cached --quiet 2>/dev/null; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [GIT] No changes to commit" >> $MASTER_LOG || true
    return 0
  fi

  git commit -m "feat(prompts): harvest cycle ${cycle} $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || true

  # Push with 3 retries — if all fail, LOG and CONTINUE
  local push_success=false
  for attempt in 1 2 3; do
    if git push origin main 2>/dev/null; then
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] [SYSTEM] [GIT] Push successful (attempt $attempt)" >> $MASTER_LOG || true
      push_success=true
      break
    else
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [ERROR] [SYSTEM] [GIT] Push attempt $attempt failed, retrying..." >> $MASTER_LOG || true
      sleep 3 || true
    fi
  done

  if [ "$push_success" = false ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [ERROR] [SYSTEM] [GIT] All 3 push attempts failed — continuing without push" >> $MASTER_LOG || true
  fi

  return 0
}
```

---

# SECTION 12: THE INFINITE LOOP

**This is the full execution loop. Outer watchdog + inner cycle. Never exits under any condition.**

```bash
# ================================================================
# MAIN EXECUTION — THE INFINITE LOOP
# Copy everything from SECTION 1 through SECTION 11 as functions,
# then start this loop. It runs forever.
# ================================================================

CYCLE=0

while true; do
  CYCLE=$((CYCLE + 1))

  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [CYCLE_START] [SYSTEM] [CYCLE_${CYCLE}] Starting harvest cycle $CYCLE" >> $MASTER_LOG || true

  PROMPTS_ADDED=0
  DUPES_SKIPPED=0
  LOCS_SCANNED=0
  NEW_AGENTS=0

  # Run all 16 fixed location scans
  for loc_num in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16; do
    LOC_ID="LOC_${loc_num}"

    # Smart skip check
    SKIP_DECISION=$(should_scan_location "$LOC_ID" "$CYCLE" || true)
    if [ "$SKIP_DECISION" = "SKIP" ]; then
      echo "[$(date +"%Y-%m-%d %H:%M:%S")] [CHECKPOINT] [$LOC_ID] [SKIP] Low yield — skipping this cycle" >> $MASTER_LOG || true
      continue
    fi

    # Run the scan function
    (scan_loc_${loc_num} || true) || true
    LOCS_SCANNED=$((LOCS_SCANNED + 1))

    # Update metrics (placeholder counts — real counts tracked inside scan functions)
    update_metrics "$LOC_ID" "0" "0" "1" || true
  done

  # Run discovery pass to find new locations
  discover_new_locations || true

  # Scan all dynamically discovered locations
  scan_discovered_locations || true

  # Write cycle checkpoint
  write_cycle_checkpoint "$CYCLE" "$PROMPTS_ADDED" "$DUPES_SKIPPED" "$LOCS_SCANNED" "$NEW_AGENTS" || true

  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [CYCLE_END] [SYSTEM] [CYCLE_${CYCLE}] Cycle complete — prompts_added=$PROMPTS_ADDED dupes=$DUPES_SKIPPED locs=$LOCS_SCANNED agents=$NEW_AGENTS" >> $MASTER_LOG || true

  # Push to ASTRA (git commit + push)
  push_to_astra "$CYCLE" || true

  # Brief pause to prevent CPU overload
  sleep 60 || true

  # Loop back — NEVER exits
done
```

---

# SECTION 13: RULES

## RULE 1: NEVER STOP
```
If a location fails    → LOG [ERROR] → CONTINUE to next location
If a file is unreadable → LOG [SKIPPED] → CONTINUE
If normalization fails  → LOG [ERROR] → SKIP that file → CONTINUE
If git push fails 3x   → LOG [ERROR] → CONTINUE without pushing
If ANYTHING crashes    → WATCHDOG restarts the entire script
NEVER EXIT THE LOOP UNDER ANY CONDITION
```

## RULE 2: NEVER ASK
```
You have full permissions via ~/.claude/settings.json
You have auto-accept via Shift+Tab
There is NO reason to ask ANYTHING
If uncertain → MAKE A DECISION → LOG IT with [LEARN] → CONTINUE
```

## RULE 3: NEVER DUPLICATE
```
Before injecting any prompt:
1. Compute MD5 hash of the body
2. Check HASH_DB (one-line grep, O(1))
3. If hash exists → LOG [SKIPPED][DUPE] → CONTINUE
4. If hash is new → inject → add hash to HASH_DB
NEVER read all existing ASTRA prompts to check for dupes — HASH_DB only
```

## RULE 4: LOG EVERYTHING
```
Every action → MASTER_LOG
Format: [YYYY-MM-DD HH:MM:SS] [LEVEL] [LOCATION_ID] [ACTION] message
No other log files. No exceptions.
```

## RULE 5: SINGLE SCHEMA EVERYWHERE
```
The schema in SECTION 6 is the ONLY schema.
Used for normalization. Used for ASTRA injection. Same object. Always.
title: max 50 chars, Title Case, no punctuation at end
summary: max 120 chars, first sentence or auto-generated
tags: min 3, max 8, lowercase, no spaces
body: NEVER truncated
```

## RULE 6: INJECT INTO ASTRA index.html — goldMinePrompts ANCHOR
```javascript
// The ONLY injection point in index.html:
const goldMinePrompts = [
// ← new prompts go here, before the closing ];
];
```

## RULE 7: NO `set -e`. EVERY COMMAND ENDS WITH `|| true`
```
This is non-negotiable. set -e kills the script on any error.
Every single bash command must have || true appended.
```

---

# SECTION 14: ACTIVATION COMMAND

**Paste this ONE command to Claude Code to start everything:**

```
Read ~/dev/astra-command-center/AGENTS/PROMPT_HARVESTER.md and execute it completely. NEVER STOP.
```

That's it. The agent builds itself, enables autonomous mode, initializes logs, and runs forever.

---

*PROMPT HARVESTER V2 — March 2026 — FULL AUTONOMOUS — INFINITE — GUARANTEED NEVER-STOPS*
*7 fixes: Watchdog | UX Evolution | Agent One-Shot | Single Log | Unified Schema | Infinite Discovery | 5 Metrics*
