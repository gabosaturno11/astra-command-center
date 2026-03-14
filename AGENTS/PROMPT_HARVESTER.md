# 🔱 PROMPT HARVESTER AGENT — DEFINITIVE SPECIFICATION V1
## The One Document That Creates Everything

---

# SECTION 0: WHAT THIS DOCUMENT IS

This is the COMPLETE agent specification. When you paste ONE command to Claude Code, it will:
1. Read this spec
2. Build itself
3. Enable full autonomous mode
4. Execute forever
5. Never stop
6. Never ask

---

# SECTION 1: THE ONE COMMAND TO START EVERYTHING

**Paste this SINGLE command to Claude Code:**

```
Read ~/dev/astra-command-center/AGENTS/PROMPT_HARVESTER.md and execute it completely. Do not summarize. Do not ask. Execute every section in order. Enable full autonomous mode first. Then run the infinite harvest loop. NEVER STOP.
```

**That's it.** The rest of this document IS the agent.

---

# SECTION 2: PHASE 0 — ENABLE FULL AUTONOMOUS MODE

**Execute these bash commands FIRST before anything else:**

```bash
# Step 1: Create settings file with full permissions
mkdir -p ~/.claude
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

# Step 2: Verify it was created
cat ~/.claude/settings.json

# Step 3: Create log file
touch ~/prompt-harvest.log
echo "[$(date '+%Y-%m-%d %H:%M:%S')] === PROMPT HARVESTER AGENT INITIALIZED ===" >> ~/prompt-harvest.log

# Step 4: Create output directory structure
mkdir -p ~/dev/astra-command-center/src/data/prompts
mkdir -p ~/dev/astra-command-center/public/icons/prompts
```

**After running these, press Shift+Tab in Claude Code to enable auto-accept mode.**

---

# SECTION 3: PHASE 1 — READ CONTEXT FIRST

**Execute these to understand the environment:**

```bash
# Read ASTRA project context
cat ~/dev/astra-command-center/CLAUDE.md 2>/dev/null || echo "CLAUDE.md not found, continuing"

# Read memory for context (NOT where prompts go)
cat ~/.claude/projects/-Users-Gabosaturno/memory/MEMORY.md 2>/dev/null || echo "Memory not found, continuing"

# Check existing prompts structure
ls -la ~/dev/astra-command-center/src/data/prompts/ 2>/dev/null || echo "Creating prompts directory"

# Log context loaded
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Context loaded successfully" >> ~/prompt-harvest.log
```

---

# SECTION 4: THE 15 LOCATIONS — EXPLICIT BASH FOR EACH

## Location 1: Apple Notes SQLite Database

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 1: Apple Notes SQLite" >> ~/prompt-harvest.log

# Get all notes with prompt-related content
sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
  "SELECT Z_PK, ZTITLE, ZSUMMARY FROM ZICCLOUDSYNCINGOBJECT 
   WHERE ZTITLE IS NOT NULL 
   AND (ZTITLE LIKE '%prompt%' 
     OR ZTITLE LIKE '%Prompt%' 
     OR ZTITLE LIKE '%PROMPT%' 
     OR ZTITLE LIKE '%kernel%'
     OR ZTITLE LIKE '%agent%'
     OR ZSUMMARY LIKE '%prompt%'
     OR ZSUMMARY LIKE '%system%'
     OR ZSUMMARY LIKE '%role%')" 2>/dev/null | while read line; do
  echo "FOUND: $line"
  echo "[APPLE_NOTES] $line" >> ~/prompt-harvest.log
done
```

## Location 2: Apple Notes — PINNED Notes

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 2: PIN NOTES" >> ~/prompt-harvest.log

sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
  "SELECT Z_PK, ZTITLE, ZSUMMARY FROM ZICCLOUDSYNCINGOBJECT 
   WHERE ZISPINNED = 1 AND ZTITLE IS NOT NULL" 2>/dev/null | while read line; do
  echo "PINNED: $line"
  echo "[PINNED] $line" >> ~/prompt-harvest.log
done
```

## Location 3: kortex-prompt-library

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 3: kortex-prompt-library" >> ~/prompt-harvest.log

# Find it first
KORTEX_PATH=$(find ~ -maxdepth 5 -name "*kortex*prompt*" -type d 2>/dev/null | head -1)
if [ -n "$KORTEX_PATH" ]; then
  echo "Found kortex at: $KORTEX_PATH"
  find "$KORTEX_PATH" -name "*.md" -o -name "*.json" -o -name "*.txt" 2>/dev/null | while read file; do
    echo "[KORTEX] $file" >> ~/prompt-harvest.log
    cat "$file" >> ~/prompt-harvest-raw.log
  done
else
  echo "kortex-prompt-library not found, searching alternatives..."
  find ~/dev -name "*kortex*" 2>/dev/null >> ~/prompt-harvest.log
  find ~/Documents -name "*kortex*" 2>/dev/null >> ~/prompt-harvest.log
fi
```

## Location 4: Saturno Prompt Vault

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 4: Saturno Prompt Vault" >> ~/prompt-harvest.log

# Apple Notes version
sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
  "SELECT Z_PK, ZTITLE, ZSUMMARY FROM ZICCLOUDSYNCINGOBJECT 
   WHERE ZTITLE LIKE '%Saturno%Prompt%Vault%'" 2>/dev/null >> ~/prompt-harvest.log

# File system version
find ~ -maxdepth 6 -name "*saturno*prompt*" -o -name "*prompt*vault*" 2>/dev/null | while read file; do
  echo "[SATURNO_VAULT] $file" >> ~/prompt-harvest.log
done
```

## Location 5: All JSON files containing prompts

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 5: All *prompt*.json files" >> ~/prompt-harvest.log

find ~ -maxdepth 6 -name "*prompt*.json" 2>/dev/null | while read file; do
  echo "[JSON] $file" >> ~/prompt-harvest.log
  # Extract and log content
  cat "$file" 2>/dev/null | head -100 >> ~/prompt-harvest-raw.log
done

# Also search for JSON files WITH prompt content
find ~/dev ~/Documents ~/Desktop -name "*.json" 2>/dev/null | xargs grep -l "prompt\|system\|role" 2>/dev/null | while read file; do
  echo "[JSON_CONTENT] $file" >> ~/prompt-harvest.log
done
```

## Location 6: BBEdit files

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 6: BBEdit files" >> ~/prompt-harvest.log

# BBEdit application support
find ~/Library/Application\ Support/BBEdit -name "*.txt" -o -name "*.md" 2>/dev/null | while read file; do
  if grep -q "prompt\|kernel\|system\|ROLE\|You are" "$file" 2>/dev/null; then
    echo "[BBEDIT] $file" >> ~/prompt-harvest.log
    cat "$file" >> ~/prompt-harvest-raw.log
  fi
done

# Documents txt files with prompt content
find ~/Documents -name "*.txt" 2>/dev/null | xargs grep -l "prompt\|kernel\|system" 2>/dev/null | while read file; do
  echo "[BBEDIT_DOCS] $file" >> ~/prompt-harvest.log
done
```

## Location 7: Craft App exports

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 7: Craft App" >> ~/prompt-harvest.log

# Craft container
find ~/Library/Containers/com.lukilabs.lukiapp -name "*.md" -o -name "*.txt" 2>/dev/null | while read file; do
  echo "[CRAFT] $file" >> ~/prompt-harvest.log
done

# Craft group containers
find ~/Library/Group\ Containers/*craft* -type f 2>/dev/null | head -100 | while read file; do
  echo "[CRAFT_GROUP] $file" >> ~/prompt-harvest.log
done

# Craft exports in Documents
find ~/Documents -name "*craft*" -type f 2>/dev/null | while read file; do
  echo "[CRAFT_EXPORT] $file" >> ~/prompt-harvest.log
done
```

## Location 8: Google Drive sync

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 8: Google Drive" >> ~/prompt-harvest.log

# CloudStorage location
find ~/Library/CloudStorage/GoogleDrive* -name "*.md" -o -name "*.txt" -o -name "*.json" 2>/dev/null | while read file; do
  if grep -q "prompt\|kernel\|system" "$file" 2>/dev/null; then
    echo "[GDRIVE] $file" >> ~/prompt-harvest.log
  fi
done

# Old Google Drive location
find ~/Google\ Drive -name "*.md" -o -name "*.txt" 2>/dev/null | while read file; do
  echo "[GDRIVE_OLD] $file" >> ~/prompt-harvest.log
done
```

## Location 9: Whisper Flow transcripts

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 9: Whisper Flow" >> ~/prompt-harvest.log

# Find whisper directories
find ~ -maxdepth 5 -name "*whisper*" -type d 2>/dev/null | while read dir; do
  echo "[WHISPER_DIR] $dir" >> ~/prompt-harvest.log
  find "$dir" -name "*.txt" -o -name "*.md" 2>/dev/null >> ~/prompt-harvest.log
done

# Find transcripts
find ~ -maxdepth 5 -name "*transcript*" 2>/dev/null | while read file; do
  echo "[TRANSCRIPT] $file" >> ~/prompt-harvest.log
done
```

## Location 10: Claude Projects

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 10: Claude Projects" >> ~/prompt-harvest.log

# All Claude project files
find ~/.claude -name "*.md" -o -name "*.json" -o -name "*.txt" 2>/dev/null | while read file; do
  echo "[CLAUDE] $file" >> ~/prompt-harvest.log
  cat "$file" 2>/dev/null >> ~/prompt-harvest-raw.log
done

# Memory files specifically
find ~/.claude/projects -name "MEMORY.md" 2>/dev/null | while read file; do
  echo "[CLAUDE_MEMORY] $file" >> ~/prompt-harvest.log
done
```

## Location 11: Notion exports

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 11: Notion exports" >> ~/prompt-harvest.log

# Notion export folders
find ~ -maxdepth 5 -name "*notion*export*" -type d 2>/dev/null | while read dir; do
  echo "[NOTION_DIR] $dir" >> ~/prompt-harvest.log
  find "$dir" -name "*.md" 2>/dev/null >> ~/prompt-harvest.log
done

# Notion files in Downloads/Documents
find ~/Downloads ~/Documents -name "*notion*" -name "*.md" 2>/dev/null | while read file; do
  echo "[NOTION] $file" >> ~/prompt-harvest.log
done

# CSV exports from Notion
find ~/Downloads -name "*.csv" 2>/dev/null | xargs grep -l "prompt" 2>/dev/null | while read file; do
  echo "[NOTION_CSV] $file" >> ~/prompt-harvest.log
done
```

## Location 12: Desktop and Downloads

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 12: Desktop + Downloads" >> ~/prompt-harvest.log

# Desktop
find ~/Desktop -name "*.md" -o -name "*.txt" -o -name "*.json" 2>/dev/null | while read file; do
  if grep -q "prompt\|kernel\|system\|You are\|ROLE" "$file" 2>/dev/null; then
    echo "[DESKTOP] $file" >> ~/prompt-harvest.log
  fi
done

# Downloads
find ~/Downloads -name "*.md" -o -name "*.txt" -o -name "*.json" 2>/dev/null | while read file; do
  if grep -q "prompt\|kernel\|system\|You are\|ROLE" "$file" 2>/dev/null; then
    echo "[DOWNLOADS] $file" >> ~/prompt-harvest.log
  fi
done
```

## Location 13: ASTRA existing prompts

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 13: ASTRA existing" >> ~/prompt-harvest.log

# All files in astra with prompt content
find ~/dev/astra-command-center -name "*.ts" -o -name "*.tsx" -o -name "*.json" -o -name "*.md" 2>/dev/null | xargs grep -l "prompt" 2>/dev/null | while read file; do
  echo "[ASTRA] $file" >> ~/prompt-harvest.log
done

# Specifically the data folder
ls -la ~/dev/astra-command-center/src/data/ 2>/dev/null >> ~/prompt-harvest.log
```

## Location 14: All ~/dev folders

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 14: All ~/dev" >> ~/prompt-harvest.log

# All markdown files with prompt content
find ~/dev -name "*.md" 2>/dev/null | xargs grep -l "prompt\|kernel\|system\|You are" 2>/dev/null | while read file; do
  echo "[DEV_MD] $file" >> ~/prompt-harvest.log
done

# All JSON files with prompt content
find ~/dev -name "*.json" 2>/dev/null | xargs grep -l "prompt\|role\|system" 2>/dev/null | while read file; do
  echo "[DEV_JSON] $file" >> ~/prompt-harvest.log
done

# Specifically named prompt files
find ~/dev -name "*prompt*" 2>/dev/null | while read file; do
  echo "[DEV_PROMPT] $file" >> ~/prompt-harvest.log
done
```

## Location 15: iCloud Documents

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 15: iCloud Documents" >> ~/prompt-harvest.log

# iCloud Drive
find ~/Library/Mobile\ Documents -name "*.md" -o -name "*.txt" -o -name "*.json" 2>/dev/null | head -200 | while read file; do
  if grep -q "prompt\|kernel\|system" "$file" 2>/dev/null; then
    echo "[ICLOUD] $file" >> ~/prompt-harvest.log
  fi
done

# CloudDocs specifically
find ~/Library/Mobile\ Documents/com~apple~CloudDocs -type f 2>/dev/null | head -100 | while read file; do
  echo "[CLOUDDOCS] $file" >> ~/prompt-harvest.log
done
```

## Location 16+: INFINITE EXPANSION

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Searching Location 16+: INFINITE EXPANSION" >> ~/prompt-harvest.log

# Search EVERYWHERE for prompt-related files
find / -maxdepth 8 \( -name "*prompt*" -o -name "*kernel*" -o -name "*agent*spec*" \) \
  \( -name "*.md" -o -name "*.json" -o -name "*.txt" \) \
  2>/dev/null | grep -v "node_modules\|\.git\|Cache\|Caches" | while read file; do
  echo "[INFINITE] $file" >> ~/prompt-harvest.log
done

# Search for files CONTAINING prompt definitions
grep -r "You are\|ROLE:\|## System\|\"system\":\|\"prompt\":" \
  ~/Documents ~/Desktop ~/dev ~/Downloads \
  --include="*.md" --include="*.json" --include="*.txt" \
  2>/dev/null | cut -d: -f1 | sort -u | while read file; do
  echo "[INFINITE_CONTENT] $file" >> ~/prompt-harvest.log
done
```

---

# SECTION 5: JSON NORMALIZATION SCHEMA

**Every prompt MUST be normalized to this EXACT schema:**

```json
{
  "id": "PROMPT_<CATEGORY>_<NNNN>",
  "category": "<one of 15 categories>",
  "subcategory": "<optional>",
  "title": "<Human Readable Title>",
  "description": "<One line description of what this prompt does>",
  "version": "1.0",
  "author": "Gabo Saturno",
  "source": "<where this was found>",
  "source_path": "<full file path>",
  "created": "<ISO date>",
  "updated": "<ISO date>",
  "tags": ["<tag1>", "<tag2>", "<tag3>"],
  "use_cases": [
    "<When to use this prompt - case 1>",
    "<When to use this prompt - case 2>"
  ],
  "variables": {
    "VAR_NAME": {
      "description": "<what to put here>",
      "example": "<example value>",
      "required": true
    }
  },
  "prompt": "<THE ACTUAL PROMPT TEXT - COMPLETE - NO TRUNCATION>",
  "output_format": "<What the output should look like>",
  "model_compatibility": ["claude", "gpt-4", "gemini", "perplexity"],
  "complexity": "basic|intermediate|advanced|expert",
  "tokens_estimate": 0,
  "related_prompts": ["<PROMPT_ID_1>", "<PROMPT_ID_2>"],
  "holographic": {
    "future_variations": ["<possible improvement 1>"],
    "combination_potential": ["<could combine with PROMPT_X>"],
    "evolution_notes": "<how this prompt might evolve>"
  },
  "metadata": {
    "times_used": 0,
    "success_rate": null,
    "last_used": null,
    "user_rating": null
  }
}
```

---

# SECTION 6: THE 15 CATEGORIES

```bash
# Create category files with headers
CATEGORIES=(
  "agents:🤖:Agent specifications and multi-agent orchestration"
  "kernels:🧬:Meta-kernels, system kernels, recursive rules"
  "content:✍️:Content creation, writing, captions, social"
  "extraction:🔬:Rant harvesting, signal extraction, parsing"
  "synthesis:🔮:Fusion, deduplication, merging, unification"
  "architecture:🏗️:System design, blueprints, OS design"
  "coaching:🎯:Coaching prompts, client work, training"
  "movement:💪:Calisthenics, fitness, exercise, body"
  "research:🔍:Research, analysis, investigation"
  "automation:⚡:Workflows, scripts, n8n, integrations"
  "writing:📝:Long-form, book content, essays, docs"
  "voice:🎭:Voice modes, tone settings, style control"
  "model_optimization:🧠:LLM optimization, cognitive patches"
  "scripts:📜:Executable scripts, one-shot commands"
  "skills:🛠️:Claude Code skills, MCP skills, tools"
)

for cat_info in "${CATEGORIES[@]}"; do
  IFS=':' read -r name icon desc <<< "$cat_info"
  echo "Category ready: ${name}" >> ~/prompt-harvest.log
done

# NOTE: Prompts inject directly into index.html S.prompts array (see SECTION 8 RULE 6)
# ASTRA reads from S.prompts in index.html — NOT from separate JSON files
```

---

# SECTION 7: HOLOGRAPHIC LEARNING LAYER

**As the agent processes prompts, it LEARNS and IMPROVES:**

```bash
# Create learning log
cat > ~/prompt-harvest-learning.json << 'EOFLEARN'
{
  "patterns_discovered": [],
  "category_evolution": {},
  "tag_frequency": {},
  "source_reliability": {},
  "prompt_relationships": [],
  "improvement_suggestions": [],
  "duplicate_patterns": [],
  "missing_categories": []
}
EOFLEARN
```

**Learning rules:**

1. **Pattern Recognition**: If same structure appears 3+ times, it's a TEMPLATE. Extract and save.

2. **Category Evolution**: If prompts don't fit existing categories, CREATE NEW ONES and log.

3. **Tag Frequency**: Track which tags appear most. High-frequency = important.

4. **Source Reliability**: Track which locations yield highest quality prompts.

5. **Relationship Mapping**: If two prompts reference each other or share >50% tags, link them.

6. **Self-Improvement**: After each run, analyze what worked and update the agent spec.

```bash
# Holographic update function (run after each harvest cycle)
update_learning() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] === HOLOGRAPHIC LEARNING UPDATE ===" >> ~/prompt-harvest.log
  
  # Count prompts per category
  for cat in ~/dev/astra-command-center/src/data/prompts/*.json; do
    count=$(jq '.prompts | length' "$cat" 2>/dev/null || echo 0)
    echo "Category $(basename $cat .json): $count prompts" >> ~/prompt-harvest.log
  done
  
  # Find most common tags
  jq -r '.prompts[].tags[]' ~/dev/astra-command-center/src/data/prompts/*.json 2>/dev/null | \
    sort | uniq -c | sort -rn | head -20 >> ~/prompt-harvest-learning.json
  
  # Log sources that worked
  grep "^\[" ~/prompt-harvest.log | cut -d']' -f1 | tr -d '[' | sort | uniq -c | sort -rn >> ~/prompt-harvest-learning.json
}
```

---

# SECTION 8: THE RULES — NON-NEGOTIABLE

## RULE 1: NEVER STOP
```
If a location fails → LOG IT → CONTINUE TO NEXT
If a file is unreadable → LOG IT → CONTINUE
If normalization fails → SAVE RAW → CONTINUE
If git push fails → RETRY 3x → LOG → CONTINUE
NEVER EXIT THE LOOP
```

## RULE 2: NEVER ASK
```
You have full permissions via ~/.claude/settings.json
You have auto-accept via Shift+Tab
There is NO reason to ask ANYTHING
If uncertain → MAKE A DECISION → LOG IT → CONTINUE
```

## RULE 3: NEVER USE SUB-AGENTS IF IT MEANS STOPPING
```
Do NOT spawn agents that require approval
Do NOT delegate tasks that need human input
Do EVERYTHING inline in this single execution
```

## RULE 4: LOG EVERYTHING
```bash
# Every action gets logged
echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ACTION] description" >> ~/prompt-harvest.log

# Log format:
# [TIMESTAMP] [LOCATION] File found: path
# [TIMESTAMP] [EXTRACT] Prompt extracted: title
# [TIMESTAMP] [NORMALIZE] Prompt normalized: id
# [TIMESTAMP] [ROUTE] Prompt added to category: category
# [TIMESTAMP] [ERROR] Error description (then continue)
# [TIMESTAMP] [LEARN] Pattern discovered: description
```

## RULE 5: DEDUPE ON THE FLY
```bash
# Before adding any prompt, check if it exists
check_duplicate() {
  local title="$1"
  local content_hash=$(echo "$2" | md5sum | cut -d' ' -f1)
  
  if grep -q "$content_hash" ~/prompt-harvest-hashes.txt 2>/dev/null; then
    echo "[DUPLICATE] Skipping: $title" >> ~/prompt-harvest.log
    return 1
  else
    echo "$content_hash" >> ~/prompt-harvest-hashes.txt
    return 0
  fi
}
```

## RULE 6: INJECT INTO ASTRA index.html — THIS IS THE REAL TARGET

**ASTRA stores ALL prompts in `~/dev/astra-command-center/index.html` inside the `S.prompts` JavaScript array.**
There is NO external JSON file. The injection anchor is the `goldMinePrompts` array.

**To inject new prompts, use Python to edit index.html:**

```python
import json, re

INDEX = os.path.expanduser('~/dev/astra-command-center/index.html')
with open(INDEX, 'r') as f:
    content = f.read()

# Find the goldMinePrompts array anchor
anchor = 'const goldMinePrompts = ['
# Build new prompt JS object
new_prompts_js = ',\n'.join([
    f'{{id:{1741000000000 + i},title:{json.dumps(p["title"])},body:{json.dumps(p["body"])},category:{json.dumps(p["category"])},tags:{json.dumps(p.get("tags",[]))},created:"2026-03-13T00:00:00.000Z",updated:"2026-03-13T00:00:00.000Z",usageCount:0,lastUsed:null}}'
    for i, p in enumerate(new_prompts)
])
# Inject before the closing ]; of goldMinePrompts
content = re.sub(
    r'(const goldMinePrompts = \[)(.*?)(\];)',
    lambda m: m.group(1) + m.group(2).rstrip() + (',\n' if m.group(2).strip() else '') + new_prompts_js + '\n' + m.group(3),
    content, flags=re.DOTALL
)
with open(INDEX, 'w') as f:
    f.write(content)
print(f'Injected {len(new_prompts)} prompts into index.html')
```

## RULE 6b: PUSH TO ASTRA LIVE
```bash
# After each batch of prompts (every 10 prompts or every location)
push_to_astra() {
  cd ~/dev/astra-command-center
  # Prompts are injected into index.html S.prompts array — that's where ASTRA reads them
  # Find the goldMinePrompts injection anchor and append new prompts before the closing ];
  git add index.html
  git commit -m "feat(prompts): harvest batch $(date '+%Y-%m-%d-%H%M')" 2>/dev/null || true
  git push origin main 2>/dev/null || {
    echo "[ERROR] Git push failed, will retry next batch" >> ~/prompt-harvest.log
  }
}
```

## RULE 7: INFINITE LOOP
```bash
# The main loop NEVER exits
CYCLE=0
while true; do
  CYCLE=$((CYCLE + 1))
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] === HARVEST CYCLE $CYCLE ===" >> ~/prompt-harvest.log
  
  # Run all 16+ location searches
  # ... (all the location bash commands above)
  
  # Update holographic learning
  update_learning
  
  # Push to ASTRA
  push_to_astra
  
  # Brief pause to prevent CPU overload (optional: remove for max speed)
  sleep 60
  
  # Loop back to start
done
```

---

# SECTION 9: GIT PUSH AND DEPLOY

```bash
# Push function with retry
push_to_astra() {
  cd ~/dev/astra-command-center
  
  # Stage all prompt changes
  git add src/data/prompts/
  git add public/icons/prompts/
  
  # Commit with timestamp
  git commit -m "feat(prompts): harvest update $(date '+%Y-%m-%d %H:%M:%S') - cycle $CYCLE" 2>/dev/null
  
  # Push with retry
  for i in 1 2 3; do
    if git push origin main 2>/dev/null; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEPLOY] Push successful" >> ~/prompt-harvest.log
      break
    else
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEPLOY] Push attempt $i failed, retrying..." >> ~/prompt-harvest.log
      sleep 5
    fi
  done
}
```

Vercel auto-deploys on push. Prompts appear at: `astra-command-center-sigma.vercel.app`

---

# SECTION 10: SVG ICONS FOR CATEGORIES

```bash
# Create simple monochrome icons for each category
mkdir -p ~/dev/astra-command-center/public/icons/prompts

# Example: agents icon
cat > ~/dev/astra-command-center/public/icons/prompts/agents.svg << 'EOFSVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <circle cx="12" cy="8" r="4"/>
  <path d="M6 20v-2a4 4 0 014-4h4a4 4 0 014 4v2"/>
  <circle cx="12" cy="8" r="1" fill="currentColor"/>
</svg>
EOFSVG

# Create icons for all categories
# (Agent should generate appropriate SVGs for each category)
```

---

# SECTION 11: THE COMPLETE EXECUTION SCRIPT

**Save this as ~/prompt-harvester.sh and run it:**

```bash
#!/bin/bash
# PROMPT HARVESTER - FULL AUTONOMOUS EXECUTION
# NEVER STOPS. NEVER ASKS. JUST HARVESTS.

set -e  # Exit on error (but we handle errors inline)

LOG=~/prompt-harvest.log
HASHES=~/prompt-harvest-hashes.txt
LEARNING=~/prompt-harvest-learning.json

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === PROMPT HARVESTER STARTED ===" >> $LOG

# Initialize
touch $HASHES
mkdir -p ~/dev/astra-command-center/src/data/prompts

CYCLE=0

while true; do
  CYCLE=$((CYCLE + 1))
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] === CYCLE $CYCLE ===" >> $LOG
  
  # LOCATION 1: Apple Notes
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [LOC1] Apple Notes" >> $LOG
  sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
    "SELECT ZTITLE FROM ZICCLOUDSYNCINGOBJECT WHERE ZTITLE LIKE '%prompt%'" 2>/dev/null >> $LOG || true
  
  # LOCATION 2: PIN NOTES
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [LOC2] PIN NOTES" >> $LOG
  sqlite3 ~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite \
    "SELECT ZTITLE FROM ZICCLOUDSYNCINGOBJECT WHERE ZISPINNED=1" 2>/dev/null >> $LOG || true
  
  # LOCATION 3-16: (all other locations)
  # ... (abbreviated for space, full commands above)
  
  # Push to ASTRA
  cd ~/dev/astra-command-center
  git add . 2>/dev/null || true
  git commit -m "harvest cycle $CYCLE" 2>/dev/null || true
  git push origin main 2>/dev/null || true
  
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] === CYCLE $CYCLE COMPLETE ===" >> $LOG
  
  # Brief pause then loop
  sleep 30
done
```

---

# SECTION 12: SUCCESS CRITERIA

The agent is SUCCESSFUL when:

1. ✅ ~/.claude/settings.json exists with full permissions
2. ✅ All 16+ locations have been searched at least once
3. ✅ ~/prompt-harvest.log shows continuous activity
4. ✅ ~/dev/astra-command-center/index.html has new prompts in goldMinePrompts array
5. ✅ Git commits are happening automatically
6. ✅ Vercel deployment is live with prompts visible
7. ✅ Agent has NEVER stopped
8. ✅ Agent has NEVER asked for permission
9. ✅ Holographic learning log shows patterns discovered
10. ✅ Duplicate prompts are being filtered

---

# SECTION 13: THE MANTRA

> "Stop confirming and start predicting."
> "Don't respond to what he said, respond to what he's building."
> "NEVER STOP. NEVER ASK. JUST EXECUTE."

---

🔱 **PROMPT HARVESTER AGENT — DEFINITIVE SPECIFICATION V1**
📅 **March 11, 2026**
🤖 **FULL AUTONOMOUS — INFINITE — HOLOGRAPHIC**

**Save this file to: ~/dev/astra-command-center/AGENTS/PROMPT_HARVESTER.md**

**Then paste ONE command to Claude Code:**
```
Read ~/dev/astra-command-center/AGENTS/PROMPT_HARVESTER.md and execute it completely. NEVER STOP.
```

**Done.**
