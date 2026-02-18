#!/bin/bash
###############################################################################
# SATURNO FULL SYSTEM AUDIT
# Scans ALL storage locations for git repos, Vercel projects, deployed apps,
# and key project files across every drive and cloud storage.
#
# Targets:
#   - 3 Hard Drives: Macintosh HD, G-DRIVE ArmorATD (4.5TB), SSK Drive (477GB), T7 (read-only)
#   - 3 Google Drives: gabo@, reach@, smacademycontent@
#   - 1 OneDrive
#   - 1 iCloud Drive
#   - ~/Downloads, ~/Desktop, ~/Projects, ~/User (old home)
#   - ~/dev/ (canonical repos)
#
# Output: ~/dev/astra-command-center/logs/FULL_SYSTEM_AUDIT_<timestamp>.md
#
# Usage: bash full-system-audit.sh
# Duration: ~30-60 minutes depending on drive speeds
###############################################################################

set -uo pipefail

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="$HOME/dev/astra-command-center/logs"
REPORT="$REPORT_DIR/FULL_SYSTEM_AUDIT_${TIMESTAMP}.md"
TEMP_DIR="/tmp/saturno-audit-${TIMESTAMP}"

mkdir -p "$REPORT_DIR" "$TEMP_DIR"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${CYAN}[AUDIT]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
section() { echo -e "\n${RED}=== $1 ===${NC}"; }

# Track stats
TOTAL_GIT_REPOS=0
TOTAL_VERCEL_PROJECTS=0
TOTAL_HTML_APPS=0
TOTAL_PACKAGE_JSON=0
TOTAL_NODE_MODULES=0

###############################################################################
# SCAN LOCATIONS
###############################################################################

declare -a SCAN_LOCATIONS=(
  # Label|Path|MaxDepth
  "CANONICAL-DEV|$HOME/dev|5"
  "DESKTOP|$HOME/Desktop|6"
  "DOWNLOADS|$HOME/Downloads|5"
  "PROJECTS|$HOME/Projects|5"
  "OLD-USER-FOLDER|$HOME/User|6"
  "GDRIVE-ARMOR|/Volumes/G-DRIVE ArmorATD|5"
  "SSK-DRIVE|/Volumes/SSK Drive|5"
  "T7-DRIVE|/Volumes/T7|4"
  "GDRIVE-GABO|$HOME/Library/CloudStorage/GoogleDrive-gabo@saturnomovement.com|6"
  "GDRIVE-REACH|$HOME/Library/CloudStorage/GoogleDrive-reach@saturnomovement.com|6"
  "GDRIVE-ACADEMY|$HOME/Library/CloudStorage/GoogleDrive-smacademycontent@gmail.com|5"
  "ONEDRIVE|$HOME/Library/CloudStorage/OneDrive-Personal|5"
  "ICLOUD-DRIVE|$HOME/Library/Mobile Documents/com~apple~CloudDocs|6"
)

###############################################################################
# HELPER FUNCTIONS
###############################################################################

scan_git_repos() {
  local label="$1"
  local path="$2"
  local depth="$3"
  local outfile="$TEMP_DIR/git_${label// /_}.txt"

  if [ ! -d "$path" ]; then
    echo "SKIP: $path does not exist" > "$outfile"
    return
  fi

  log "Scanning git repos in: $label ($path)"

  # Find all .git directories
  find "$path" -maxdepth "$depth" -name ".git" -type d 2>/dev/null | while read gitdir; do
    repo_dir=$(dirname "$gitdir")

    # Get remote URL
    remote=$(git -C "$repo_dir" remote get-url origin 2>/dev/null || echo "NO REMOTE")

    # Get branch
    branch=$(git -C "$repo_dir" branch --show-current 2>/dev/null || echo "DETACHED/UNKNOWN")

    # Get last commit date
    last_commit=$(git -C "$repo_dir" log -1 --format="%ci" 2>/dev/null || echo "NO COMMITS")

    # Get repo name from remote or folder
    if [[ "$remote" == *"github.com"* ]]; then
      repo_name=$(echo "$remote" | sed 's/.*github.com[:/]\(.*\)\.git/\1/' | sed 's/.*github.com[:/]\(.*\)/\1/')
    else
      repo_name=$(basename "$repo_dir")
    fi

    # Check for Vercel
    has_vercel="NO"
    vercel_project=""
    if [ -f "$repo_dir/.vercel/project.json" ]; then
      has_vercel="YES"
      vercel_project=$(python3 -c "import json; d=json.load(open('$repo_dir/.vercel/project.json')); print(d.get('projectId','?'))" 2>/dev/null || echo "?")
    fi

    # Check for package.json
    has_pkg="NO"
    [ -f "$repo_dir/package.json" ] && has_pkg="YES"

    # Check for node_modules
    has_nm="NO"
    [ -d "$repo_dir/node_modules" ] && has_nm="YES"

    # Check for index.html
    has_html="NO"
    [ -f "$repo_dir/index.html" ] && has_html="YES"

    # Count files
    file_count=$(find "$repo_dir" -maxdepth 1 -not -name ".git" -not -name "." | wc -l | tr -d ' ')

    echo "REPO|$repo_dir|$repo_name|$remote|$branch|$last_commit|$has_vercel|$vercel_project|$has_pkg|$has_nm|$has_html|$file_count" >> "$outfile"
  done

  [ -f "$outfile" ] && success "Found $(wc -l < "$outfile" | tr -d ' ') git repos in $label" || echo "" > "$outfile"
}

scan_vercel_configs() {
  local label="$1"
  local path="$2"
  local depth="$3"
  local outfile="$TEMP_DIR/vercel_${label// /_}.txt"

  if [ ! -d "$path" ]; then
    echo "SKIP: $path does not exist" > "$outfile"
    return
  fi

  log "Scanning Vercel configs in: $label"

  find "$path" -maxdepth "$depth" -path "*/.vercel/project.json" -type f 2>/dev/null | while read vfile; do
    project_dir=$(dirname "$(dirname "$vfile")")
    project_id=$(python3 -c "import json; d=json.load(open('$vfile')); print(d.get('projectId','?'))" 2>/dev/null || echo "?")
    org_id=$(python3 -c "import json; d=json.load(open('$vfile')); print(d.get('orgId','?'))" 2>/dev/null || echo "?")
    project_name=$(python3 -c "import json; d=json.load(open('$vfile')); print(d.get('settings',{}).get('framework','') or d.get('projectId','?'))" 2>/dev/null || echo "?")

    # Determine team
    team="UNKNOWN"
    case "$org_id" in
      *"YCIw2FmaDtxX1WbiH71bgOB5"*) team="gabriele-saturnos-projects (CURRENT)" ;;
      *"rxSMDebAUcjEhVoqXEVo6G2C"*) team="saturno-os (OLD)" ;;
    esac

    echo "VERCEL|$project_dir|$project_id|$org_id|$team" >> "$outfile"
  done

  [ -f "$outfile" ] && success "Found $(wc -l < "$outfile" | tr -d ' ') Vercel configs in $label" || echo "" > "$outfile"
}

scan_standalone_html() {
  local label="$1"
  local path="$2"
  local depth="$3"
  local outfile="$TEMP_DIR/html_${label// /_}.txt"

  if [ ! -d "$path" ]; then
    echo "SKIP: $path does not exist" > "$outfile"
    return
  fi

  log "Scanning standalone HTML apps in: $label"

  # Find index.html files that are likely apps (contain <script or have app-like structure)
  find "$path" -maxdepth "$depth" -name "index.html" -type f 2>/dev/null | while read htmlfile; do
    dir=$(dirname "$htmlfile")
    size=$(stat -f%z "$htmlfile" 2>/dev/null || echo "0")

    # Skip node_modules, .git, tiny files
    [[ "$dir" == *"node_modules"* ]] && continue
    [[ "$dir" == *".git"* ]] && continue
    [ "$size" -lt 500 ] 2>/dev/null && continue

    # Check if it has JS (likely an app)
    has_script=$(grep -c "<script" "$htmlfile" 2>/dev/null || echo "0")
    [ "$has_script" -eq 0 ] && continue

    # Get title
    title=$(grep -o '<title>[^<]*</title>' "$htmlfile" 2>/dev/null | head -1 | sed 's/<[^>]*>//g' || echo "NO TITLE")
    [ -z "$title" ] && title="NO TITLE"

    echo "HTML|$htmlfile|$size|$has_script|$title" >> "$outfile"
  done

  [ -f "$outfile" ] && success "Found $(wc -l < "$outfile" | tr -d ' ') HTML apps in $label" || echo "" > "$outfile"
}

scan_node_modules() {
  local label="$1"
  local path="$2"
  local depth="$3"
  local outfile="$TEMP_DIR/nm_${label// /_}.txt"

  if [ ! -d "$path" ]; then
    return
  fi

  log "Scanning node_modules in: $label"

  find "$path" -maxdepth "$depth" -name "node_modules" -type d -prune 2>/dev/null | while read nmdir; do
    size=$(du -sh "$nmdir" 2>/dev/null | cut -f1 || echo "?")
    echo "NM|$nmdir|$size" >> "$outfile"
  done
}

scan_specific_repos() {
  local label="$1"
  local path="$2"
  local depth="$3"
  local search_term="$4"
  local outfile="$TEMP_DIR/search_${search_term// /_}_${label// /_}.txt"

  if [ ! -d "$path" ]; then
    return
  fi

  log "Searching for '$search_term' in: $label"

  # Search in folder names
  find "$path" -maxdepth "$depth" -iname "*${search_term}*" -type d 2>/dev/null | while read match; do
    [[ "$match" == *"node_modules"* ]] && continue
    [[ "$match" == *".git/objects"* ]] && continue
    echo "DIR|$match" >> "$outfile"
  done

  # Search in file names
  find "$path" -maxdepth "$depth" -iname "*${search_term}*" -type f 2>/dev/null | while read match; do
    [[ "$match" == *"node_modules"* ]] && continue
    [[ "$match" == *".git/objects"* ]] && continue
    [[ "$match" == *".git/refs"* ]] && continue
    echo "FILE|$match" >> "$outfile"
  done
}

scan_package_jsons() {
  local label="$1"
  local path="$2"
  local depth="$3"
  local outfile="$TEMP_DIR/pkg_${label// /_}.txt"

  if [ ! -d "$path" ]; then
    return
  fi

  log "Scanning package.json files in: $label"

  find "$path" -maxdepth "$depth" -name "package.json" -not -path "*/node_modules/*" -type f 2>/dev/null | while read pkgfile; do
    dir=$(dirname "$pkgfile")
    name=$(python3 -c "import json; print(json.load(open('$pkgfile')).get('name','?'))" 2>/dev/null || echo "?")
    echo "PKG|$dir|$name" >> "$outfile"
  done
}

###############################################################################
# MAIN EXECUTION
###############################################################################

echo ""
section "SATURNO FULL SYSTEM AUDIT"
log "Started: $(date)"
log "Report will be saved to: $REPORT"
echo ""

# Phase 1: Scan all locations for git repos
section "PHASE 1: GIT REPOS"
for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  scan_git_repos "$label" "$path" "$depth"
done

# Phase 2: Scan all locations for Vercel configs
section "PHASE 2: VERCEL PROJECTS"
for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  scan_vercel_configs "$label" "$path" "$depth"
done

# Phase 3: Scan for standalone HTML apps
section "PHASE 3: HTML APPS"
for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  scan_standalone_html "$label" "$path" "$depth"
done

# Phase 4: Scan for node_modules (wasted space)
section "PHASE 4: NODE_MODULES (SPACE WASTE)"
for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  scan_node_modules "$label" "$path" "$depth"
done

# Phase 5: Search for specific project names
section "PHASE 5: SPECIFIC PROJECT SEARCHES"
SEARCH_TERMS=("victory-belt" "titan-forge" "saturno-bonus" "saturno-vault" "saturno-hub" "astra" "nexus-capture" "andy-strength" "andy-guide" "traveling-os" "muscle-up" "de-aqui" "bonus-vault" "command-center" "solar-system" "interactive-toc" "saturno-beast" "saturno-os" "saturno-movement" "saturn-forge" "bonus-page" "VB-COMMAND" "calisthenics-hub")

for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  for term in "${SEARCH_TERMS[@]}"; do
    scan_specific_repos "$label" "$path" "$depth" "$term"
  done
done

# Phase 6: Package.json files
section "PHASE 6: PACKAGE.JSON FILES"
for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  scan_package_jsons "$label" "$path" "$depth"
done

###############################################################################
# GENERATE REPORT
###############################################################################

section "GENERATING REPORT"
log "Compiling results..."

cat > "$REPORT" << 'HEADER'
# SATURNO FULL SYSTEM AUDIT
## Generated by full-system-audit.sh

HEADER

echo "**Date:** $(date)" >> "$REPORT"
echo "**Machine:** iMac (C2) — /Users/Gabosaturno" >> "$REPORT"
echo "" >> "$REPORT"

# Drives summary
cat >> "$REPORT" << 'EOF'
---

## STORAGE LOCATIONS SCANNED

| # | Location | Path | Status |
|---|----------|------|--------|
EOF

i=1
for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  if [ -d "$path" ]; then
    status="SCANNED"
  else
    status="NOT FOUND"
  fi
  echo "| $i | $label | \`$path\` | $status |" >> "$REPORT"
  ((i++))
done

echo "" >> "$REPORT"

# Drive space
echo "## DISK SPACE" >> "$REPORT"
echo '```' >> "$REPORT"
df -h /Volumes/G-DRIVE\ ArmorATD /Volumes/SSK\ Drive /Volumes/T7 / 2>/dev/null | head -10 >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# Git repos section
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## GIT REPOSITORIES" >> "$REPORT"
echo "" >> "$REPORT"

for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  safename="${label// /_}"
  outfile="$TEMP_DIR/git_${safename}.txt"

  if [ ! -f "$outfile" ] || [ ! -s "$outfile" ]; then
    continue
  fi

  if grep -q "^SKIP:" "$outfile" 2>/dev/null; then
    continue
  fi

  count=$(grep -c "^REPO|" "$outfile" 2>/dev/null || echo "0")
  [ "$count" -eq 0 ] && continue

  TOTAL_GIT_REPOS=$((TOTAL_GIT_REPOS + count))

  echo "### $label ($count repos)" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "| Repo | Remote | Branch | Last Commit | Vercel | pkg | n_m | HTML |" >> "$REPORT"
  echo "|------|--------|--------|-------------|--------|-----|-----|------|" >> "$REPORT"

  while IFS='|' read -r type dir name remote branch commit vercel vpid pkg nm html fcount; do
    [ "$type" != "REPO" ] && continue
    short_dir=$(echo "$dir" | sed "s|$HOME|~|")
    short_remote=$(echo "$remote" | sed 's|https://github.com/||' | sed 's|git@github.com:||' | sed 's|\.git$||')
    short_commit=$(echo "$commit" | cut -d' ' -f1)
    echo "| \`$short_dir\` ($name) | $short_remote | $branch | $short_commit | $vercel | $pkg | $nm | $html |" >> "$REPORT"
  done < "$outfile"

  echo "" >> "$REPORT"
done

# Vercel section
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## VERCEL PROJECT CONFIGS" >> "$REPORT"
echo "" >> "$REPORT"

for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  safename="${label// /_}"
  outfile="$TEMP_DIR/vercel_${safename}.txt"

  if [ ! -f "$outfile" ] || [ ! -s "$outfile" ]; then
    continue
  fi

  if grep -q "^SKIP:" "$outfile" 2>/dev/null; then
    continue
  fi

  count=$(grep -c "^VERCEL|" "$outfile" 2>/dev/null || echo "0")
  [ "$count" -eq 0 ] && continue

  TOTAL_VERCEL_PROJECTS=$((TOTAL_VERCEL_PROJECTS + count))

  echo "### $label ($count Vercel configs)" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "| Directory | Project ID | Team |" >> "$REPORT"
  echo "|-----------|------------|------|" >> "$REPORT"

  while IFS='|' read -r type dir pid oid team; do
    [ "$type" != "VERCEL" ] && continue
    short_dir=$(echo "$dir" | sed "s|$HOME|~|")
    echo "| \`$short_dir\` | \`$pid\` | $team |" >> "$REPORT"
  done < "$outfile"

  echo "" >> "$REPORT"
done

# HTML apps section
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## STANDALONE HTML APPS (with <script> tags, >500 bytes)" >> "$REPORT"
echo "" >> "$REPORT"

for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  safename="${label// /_}"
  outfile="$TEMP_DIR/html_${safename}.txt"

  if [ ! -f "$outfile" ] || [ ! -s "$outfile" ]; then
    continue
  fi

  count=$(grep -c "^HTML|" "$outfile" 2>/dev/null || echo "0")
  [ "$count" -eq 0 ] && continue

  TOTAL_HTML_APPS=$((TOTAL_HTML_APPS + count))

  echo "### $label ($count HTML apps)" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "| File | Size | Scripts | Title |" >> "$REPORT"
  echo "|------|------|---------|-------|" >> "$REPORT"

  while IFS='|' read -r type file size scripts title; do
    [ "$type" != "HTML" ] && continue
    short_file=$(echo "$file" | sed "s|$HOME|~|")
    human_size=$(python3 -c "s=$size; u=['B','KB','MB','GB']; i=0
while s>=1024 and i<3: s/=1024; i+=1
print(f'{s:.0f}{u[i]}')" 2>/dev/null || echo "${size}B")
    echo "| \`$short_file\` | $human_size | $scripts | $title |" >> "$REPORT"
  done < "$outfile"

  echo "" >> "$REPORT"
done

# Node modules section
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## NODE_MODULES (RECLAIMABLE SPACE)" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Location | Size |" >> "$REPORT"
echo "|----------|------|" >> "$REPORT"

total_nm_count=0
for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  safename="${label// /_}"
  outfile="$TEMP_DIR/nm_${safename}.txt"

  [ ! -f "$outfile" ] && continue

  while IFS='|' read -r type dir size; do
    [ "$type" != "NM" ] && continue
    short_dir=$(echo "$dir" | sed "s|$HOME|~|")
    echo "| \`$short_dir\` | $size |" >> "$REPORT"
    ((total_nm_count++))
  done < "$outfile"
done

TOTAL_NODE_MODULES=$total_nm_count
echo "" >> "$REPORT"
echo "**Total node_modules directories: $total_nm_count**" >> "$REPORT"
echo "" >> "$REPORT"

# Specific project search results
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## PROJECT NAME SEARCH RESULTS" >> "$REPORT"
echo "" >> "$REPORT"

for term in "${SEARCH_TERMS[@]}"; do
  matches=0
  results=""

  for loc in "${SCAN_LOCATIONS[@]}"; do
    IFS='|' read -r label path depth <<< "$loc"
    safename="${label// /_}"
    outfile="$TEMP_DIR/search_${term// /_}_${safename}.txt"

    [ ! -f "$outfile" ] && continue

    while IFS='|' read -r type match; do
      [[ "$match" == *"node_modules"* ]] && continue
      short_match=$(echo "$match" | sed "s|$HOME|~|")
      results+="| \`$short_match\` | $type | $label |\n"
      ((matches++))
    done < "$outfile"
  done

  if [ "$matches" -gt 0 ]; then
    echo "### \`$term\` ($matches matches)" >> "$REPORT"
    echo "" >> "$REPORT"
    echo "| Path | Type | Location |" >> "$REPORT"
    echo "|------|------|----------|" >> "$REPORT"
    echo -e "$results" >> "$REPORT"
    echo "" >> "$REPORT"
  fi
done

# Package.json section
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## PACKAGE.JSON FILES (Node projects)" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Directory | Package Name |" >> "$REPORT"
echo "|-----------|-------------|" >> "$REPORT"

for loc in "${SCAN_LOCATIONS[@]}"; do
  IFS='|' read -r label path depth <<< "$loc"
  safename="${label// /_}"
  outfile="$TEMP_DIR/pkg_${safename}.txt"

  [ ! -f "$outfile" ] && continue

  while IFS='|' read -r type dir name; do
    [ "$type" != "PKG" ] && continue
    short_dir=$(echo "$dir" | sed "s|$HOME|~|")
    echo "| \`$short_dir\` | $name |" >> "$REPORT"
    ((TOTAL_PACKAGE_JSON++))
  done < "$outfile"
done

echo "" >> "$REPORT"

# Summary
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## SUMMARY" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Metric | Count |" >> "$REPORT"
echo "|--------|-------|" >> "$REPORT"
echo "| Git Repositories | $TOTAL_GIT_REPOS |" >> "$REPORT"
echo "| Vercel Project Configs | $TOTAL_VERCEL_PROJECTS |" >> "$REPORT"
echo "| HTML Apps (standalone) | $TOTAL_HTML_APPS |" >> "$REPORT"
echo "| Package.json Files | $TOTAL_PACKAGE_JSON |" >> "$REPORT"
echo "| Node_modules Dirs | $TOTAL_NODE_MODULES |" >> "$REPORT"
echo "" >> "$REPORT"

# Recommendations
cat >> "$REPORT" << 'EOF'
---

## CLEANUP RECOMMENDATIONS

### IMMEDIATE (safe, no data loss)
1. Delete all `node_modules/` outside of `~/dev/` (can be reinstalled with `npm install`)
2. Remove stale `.vercel/project.json` files outside `~/dev/` to prevent accidental deploys

### CONSOLIDATION (needs review)
1. Move all git repos outside `~/dev/` to archive or delete if duplicates
2. Merge duplicate repos (same remote, different locations)
3. Remove old Vercel team `saturno-os` projects if no longer needed

### ARCHIVE (do not delete)
1. Old User folder at `~/User/` — move to G-DRIVE if not already done
2. Desktop projects — move to `~/dev/` or archive to G-DRIVE
3. Cloud drive copies — these are backups, leave unless clearly stale

---

*Generated by full-system-audit.sh*
*Location: ~/dev/astra-command-center/scripts/full-system-audit.sh*
EOF

# Final stats
echo ""
section "AUDIT COMPLETE"
success "Report saved to: $REPORT"
echo ""
log "Found:"
log "  - $TOTAL_GIT_REPOS git repos"
log "  - $TOTAL_VERCEL_PROJECTS Vercel configs"
log "  - $TOTAL_HTML_APPS HTML apps"
log "  - $TOTAL_PACKAGE_JSON package.json files"
log "  - $TOTAL_NODE_MODULES node_modules dirs"
echo ""
log "Temp data in: $TEMP_DIR"
log "Report: $REPORT"
echo ""

# Cleanup temp
# rm -rf "$TEMP_DIR"  # Uncomment to auto-cleanup
