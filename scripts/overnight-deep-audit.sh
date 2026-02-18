#!/bin/bash
###############################################################################
# SATURNO OVERNIGHT DEEP AUDIT
#
# Runs for HOURS. Scans EVERYTHING. Goes deep (maxdepth 15).
# Covers all 3 hard drives, all cloud storage, every corner.
#
# RUN THIS AND GO TO SLEEP:
#   nohup bash ~/dev/astra-command-center/scripts/overnight-deep-audit.sh > /tmp/overnight-audit.log 2>&1 &
#
# CHECK PROGRESS:
#   tail -f /tmp/overnight-audit.log
#
# OUTPUT:
#   ~/dev/astra-command-center/logs/OVERNIGHT_DEEP_AUDIT_<timestamp>.md
#   ~/dev/astra-command-center/logs/raw/  (individual scan results)
#
# DOES NOT MOVE, DELETE, OR MODIFY ANYTHING. READ-ONLY.
###############################################################################

set -uo pipefail

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="$HOME/dev/astra-command-center/logs"
RAW_DIR="$REPORT_DIR/raw"
REPORT="$REPORT_DIR/OVERNIGHT_DEEP_AUDIT_${TIMESTAMP}.md"

mkdir -p "$RAW_DIR"

log() { echo "[$(date '+%H:%M:%S')] $1"; }

log "OVERNIGHT DEEP AUDIT STARTED"
log "Report: $REPORT"
log "This will take several hours. Go to sleep."
echo ""

###############################################################################
# SCAN LOCATIONS — ALL OF THEM
###############################################################################

declare -a LOCATIONS=(
  "MACINTOSH-HD-HOME|$HOME|10"
  "DEV-CANONICAL|$HOME/dev|8"
  "DESKTOP|$HOME/Desktop|10"
  "DOWNLOADS|$HOME/Downloads|8"
  "PROJECTS|$HOME/Projects|8"
  "DOCUMENTS|$HOME/Documents|8"
  "GDRIVE-ARMOR|/Volumes/G-DRIVE ArmorATD|15"
  "SSK-DRIVE|/Volumes/SSK Drive|15"
  "T7-DRIVE|/Volumes/T7|10"
  "GDRIVE-GABO|$HOME/Library/CloudStorage/GoogleDrive-gabo@saturnomovement.com|10"
  "GDRIVE-REACH|$HOME/Library/CloudStorage/GoogleDrive-reach@saturnomovement.com|10"
  "GDRIVE-ACADEMY|$HOME/Library/CloudStorage/GoogleDrive-smacademycontent@gmail.com|8"
  "ONEDRIVE|$HOME/Library/CloudStorage/OneDrive-Personal|10"
  "ICLOUD|$HOME/Library/Mobile Documents/com~apple~CloudDocs|10"
)

###############################################################################
# PHASE 1: COMPLETE DIRECTORY TREE (top 3 levels of every location)
###############################################################################

log "========== PHASE 1: DIRECTORY TREES =========="

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"
  outfile="$RAW_DIR/tree_${label}.txt"

  if [ ! -d "$path" ]; then
    echo "NOT FOUND: $path" > "$outfile"
    continue
  fi

  log "Phase 1: Tree of $label"

  # Get folder sizes at depth 1
  echo "=== $label: $path ===" > "$outfile"
  echo "" >> "$outfile"
  echo "--- Top-level folder sizes ---" >> "$outfile"
  du -sh "$path"/*/ 2>/dev/null >> "$outfile"
  echo "" >> "$outfile"
  echo "--- Full tree (depth 4) ---" >> "$outfile"
  find "$path" -maxdepth 4 -type d 2>/dev/null | sed "s|$HOME|~|g" >> "$outfile"
  echo "" >> "$outfile"

  log "  Done: $(wc -l < "$outfile" | tr -d ' ') lines"
done

###############################################################################
# PHASE 2: EVERY GIT REPO (deep scan, maxdepth 15)
###############################################################################

log "========== PHASE 2: ALL GIT REPOS (DEEP) =========="

GIT_REPORT="$RAW_DIR/all_git_repos.txt"
echo "# ALL GIT REPOSITORIES FOUND ON SYSTEM" > "$GIT_REPORT"
echo "# Scanned: $(date)" >> "$GIT_REPORT"
echo "" >> "$GIT_REPORT"

TOTAL_REPOS=0

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"

  if [ ! -d "$path" ]; then
    continue
  fi

  # Skip scanning $HOME root — we scan sub-locations individually
  if [ "$label" = "MACINTOSH-HD-HOME" ]; then
    continue
  fi

  log "Phase 2: Git repos in $label (maxdepth $maxd)"

  echo "=== $label ===" >> "$GIT_REPORT"

  find "$path" -maxdepth "$maxd" -name ".git" -type d 2>/dev/null | while read gitdir; do
    repo_dir=$(dirname "$gitdir")

    # Skip node_modules
    [[ "$repo_dir" == *"node_modules"* ]] && continue

    remote=$(git -C "$repo_dir" remote get-url origin 2>/dev/null || echo "NO_REMOTE")
    branch=$(git -C "$repo_dir" branch --show-current 2>/dev/null || echo "DETACHED")
    last_commit_date=$(git -C "$repo_dir" log -1 --format="%ci" 2>/dev/null || echo "NONE")
    last_commit_msg=$(git -C "$repo_dir" log -1 --format="%s" 2>/dev/null | head -c 60 || echo "NONE")
    commit_count=$(git -C "$repo_dir" rev-list --count HEAD 2>/dev/null || echo "0")

    # Uncommitted changes
    dirty=$(git -C "$repo_dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

    # Has vercel?
    has_vercel="no"
    vercel_team=""
    if [ -f "$repo_dir/.vercel/project.json" ]; then
      has_vercel="yes"
      org_id=$(python3 -c "import json; print(json.load(open('$repo_dir/.vercel/project.json')).get('orgId','?'))" 2>/dev/null || echo "?")
      case "$org_id" in
        *"YCIw2FmaDtxX1WbiH71bgOB5"*) vercel_team="CURRENT" ;;
        *"rxSMDebAUcjEhVoqXEVo6G2C"*) vercel_team="OLD" ;;
        *) vercel_team="UNKNOWN" ;;
      esac
    fi

    # Disk size of repo (excluding .git)
    repo_size=$(du -sh "$repo_dir" 2>/dev/null | cut -f1 || echo "?")

    # Has node_modules?
    has_nm="no"
    nm_size=""
    if [ -d "$repo_dir/node_modules" ]; then
      has_nm="yes"
      nm_size=$(du -sh "$repo_dir/node_modules" 2>/dev/null | cut -f1 || echo "?")
    fi

    short_dir=$(echo "$repo_dir" | sed "s|$HOME|~|")
    short_remote=$(echo "$remote" | sed 's|https://github.com/||' | sed 's|git@github.com:||' | sed 's|\.git$||')

    echo "REPO|$short_dir|$short_remote|$branch|$last_commit_date|$last_commit_msg|$commit_count|$dirty|$has_vercel|$vercel_team|$repo_size|$has_nm|$nm_size" >> "$GIT_REPORT"

    TOTAL_REPOS=$((TOTAL_REPOS + 1))
  done

  echo "" >> "$GIT_REPORT"
done

log "Phase 2 complete: $TOTAL_REPOS git repos found"

###############################################################################
# PHASE 3: EVERY VERCEL CONFIG
###############################################################################

log "========== PHASE 3: ALL VERCEL CONFIGS =========="

VERCEL_REPORT="$RAW_DIR/all_vercel_configs.txt"
echo "# ALL VERCEL PROJECT CONFIGS" > "$VERCEL_REPORT"
echo "" >> "$VERCEL_REPORT"

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"

  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue

  log "Phase 3: Vercel configs in $label"

  find "$path" -maxdepth "$maxd" -path "*/.vercel/project.json" -type f 2>/dev/null | while read vfile; do
    project_dir=$(dirname "$(dirname "$vfile")")
    project_id=$(python3 -c "import json; print(json.load(open('$vfile')).get('projectId','?'))" 2>/dev/null || echo "?")
    org_id=$(python3 -c "import json; print(json.load(open('$vfile')).get('orgId','?'))" 2>/dev/null || echo "?")

    team="UNKNOWN"
    case "$org_id" in
      *"YCIw2FmaDtxX1WbiH71bgOB5"*) team="gabriele-saturnos-projects" ;;
      *"rxSMDebAUcjEhVoqXEVo6G2C"*) team="saturno-os-OLD" ;;
    esac

    short_dir=$(echo "$project_dir" | sed "s|$HOME|~|")
    echo "VERCEL|$short_dir|$project_id|$team" >> "$VERCEL_REPORT"
  done
done

###############################################################################
# PHASE 4: EVERY HTML FILE WITH SCRIPTS (apps, tools, dashboards)
###############################################################################

log "========== PHASE 4: ALL HTML APPS =========="

HTML_REPORT="$RAW_DIR/all_html_apps.txt"
echo "# ALL HTML APPS (with <script> tags)" > "$HTML_REPORT"
echo "" >> "$HTML_REPORT"

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"

  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue

  log "Phase 4: HTML apps in $label"

  find "$path" -maxdepth "$maxd" -name "*.html" -type f -size +1k 2>/dev/null | while read htmlfile; do
    [[ "$htmlfile" == *"node_modules"* ]] && continue
    [[ "$htmlfile" == *".git/"* ]] && continue

    # Check for script tags
    has_script=$(grep -c "<script" "$htmlfile" 2>/dev/null || echo "0")
    [ "$has_script" -eq 0 ] 2>/dev/null && continue

    size=$(stat -f%z "$htmlfile" 2>/dev/null || echo "0")
    title=$(grep -o '<title>[^<]*</title>' "$htmlfile" 2>/dev/null | head -1 | sed 's/<[^>]*>//g' || echo "")
    [ -z "$title" ] && title="NO_TITLE"

    short_file=$(echo "$htmlfile" | sed "s|$HOME|~|")
    echo "HTML|$short_file|$size|$has_script|$title" >> "$HTML_REPORT"
  done
done

###############################################################################
# PHASE 5: ALL NODE_MODULES (reclaimable space)
###############################################################################

log "========== PHASE 5: ALL NODE_MODULES =========="

NM_REPORT="$RAW_DIR/all_node_modules.txt"
echo "# ALL NODE_MODULES DIRECTORIES" > "$NM_REPORT"
echo "" >> "$NM_REPORT"

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"

  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue

  log "Phase 5: node_modules in $label"

  find "$path" -maxdepth "$maxd" -name "node_modules" -type d -prune 2>/dev/null | while read nmdir; do
    size=$(du -sh "$nmdir" 2>/dev/null | cut -f1 || echo "?")
    short_dir=$(echo "$nmdir" | sed "s|$HOME|~|")
    echo "NM|$short_dir|$size" >> "$NM_REPORT"
  done
done

###############################################################################
# PHASE 6: EVERY PACKAGE.JSON (Node.js projects)
###############################################################################

log "========== PHASE 6: ALL PACKAGE.JSON =========="

PKG_REPORT="$RAW_DIR/all_package_json.txt"
echo "# ALL PACKAGE.JSON FILES" > "$PKG_REPORT"
echo "" >> "$PKG_REPORT"

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"

  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue

  log "Phase 6: package.json in $label"

  find "$path" -maxdepth "$maxd" -name "package.json" -not -path "*/node_modules/*" -type f 2>/dev/null | while read pkgfile; do
    dir=$(dirname "$pkgfile")
    name=$(python3 -c "import json; print(json.load(open('$pkgfile')).get('name','?'))" 2>/dev/null || echo "?")
    version=$(python3 -c "import json; print(json.load(open('$pkgfile')).get('version','?'))" 2>/dev/null || echo "?")
    short_dir=$(echo "$dir" | sed "s|$HOME|~|")
    echo "PKG|$short_dir|$name|$version" >> "$PKG_REPORT"
  done
done

###############################################################################
# PHASE 7: PROJECT NAME DEEP SEARCH (files AND directories)
###############################################################################

log "========== PHASE 7: PROJECT NAME SEARCHES =========="

SEARCH_TERMS=(
  "victory-belt"
  "titan-forge"
  "saturno-bonus"
  "saturno-vault"
  "saturno-hub"
  "astra"
  "nexus-capture"
  "andy-strength"
  "andy-guide"
  "andy-deploy"
  "traveling-os"
  "muscle-up"
  "de-aqui"
  "bonus-vault"
  "command-center"
  "solar-system"
  "interactive-toc"
  "saturno-beast"
  "saturno-os"
  "saturno-movement"
  "saturn-forge"
  "bonus-page"
  "VB-COMMAND"
  "calisthenics-hub"
  "kortex"
  "writing-hub"
  "sm-app"
  "sm-website"
  "saturno-command"
  "saturno-writting"
  "saturno-forge"
  "monster-movement"
  "saturno-newsletter"
  "toc-editor"
)

SEARCH_REPORT="$RAW_DIR/all_project_searches.txt"
echo "# PROJECT NAME SEARCH RESULTS" > "$SEARCH_REPORT"
echo "" >> "$SEARCH_REPORT"

for term in "${SEARCH_TERMS[@]}"; do
  log "Phase 7: Searching '$term'"

  echo "=== $term ===" >> "$SEARCH_REPORT"

  for loc in "${LOCATIONS[@]}"; do
    IFS='|' read -r label path maxd <<< "$loc"

    [ ! -d "$path" ] && continue
    [ "$label" = "MACINTOSH-HD-HOME" ] && continue

    # Directories
    find "$path" -maxdepth "$maxd" -iname "*${term}*" -type d 2>/dev/null | while read match; do
      [[ "$match" == *"node_modules"* ]] && continue
      [[ "$match" == *".git/"* ]] && continue
      short=$(echo "$match" | sed "s|$HOME|~|")
      echo "DIR|$label|$short" >> "$SEARCH_REPORT"
    done

    # Files (skip .git internals, node_modules, .DS_Store)
    find "$path" -maxdepth "$maxd" -iname "*${term}*" -type f 2>/dev/null | while read match; do
      [[ "$match" == *"node_modules"* ]] && continue
      [[ "$match" == *".git/"* ]] && continue
      [[ "$match" == *".DS_Store"* ]] && continue
      short=$(echo "$match" | sed "s|$HOME|~|")
      echo "FILE|$label|$short" >> "$SEARCH_REPORT"
    done
  done

  echo "" >> "$SEARCH_REPORT"
done

###############################################################################
# PHASE 8: LARGE FILES (>50MB, potential media/video/archives)
###############################################################################

log "========== PHASE 8: LARGE FILES (>50MB) =========="

LARGE_REPORT="$RAW_DIR/large_files.txt"
echo "# FILES LARGER THAN 50MB" > "$LARGE_REPORT"
echo "" >> "$LARGE_REPORT"

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"

  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue

  log "Phase 8: Large files in $label"

  echo "=== $label ===" >> "$LARGE_REPORT"
  find "$path" -maxdepth "$maxd" -type f -size +50M 2>/dev/null | while read bigfile; do
    [[ "$bigfile" == *"node_modules"* ]] && continue
    [[ "$bigfile" == *".git/objects"* ]] && continue
    size=$(du -sh "$bigfile" 2>/dev/null | cut -f1 || echo "?")
    ext="${bigfile##*.}"
    short=$(echo "$bigfile" | sed "s|$HOME|~|")
    echo "BIG|$size|$ext|$short" >> "$LARGE_REPORT"
  done
  echo "" >> "$LARGE_REPORT"
done

###############################################################################
# PHASE 9: DUPLICATE FILE NAMES (same filename in multiple places)
###############################################################################

log "========== PHASE 9: DUPLICATE DETECTION =========="

DUPES_REPORT="$RAW_DIR/potential_duplicates.txt"
echo "# POTENTIAL DUPLICATE FILES" > "$DUPES_REPORT"
echo "# Files with same name found in multiple locations" >> "$DUPES_REPORT"
echo "" >> "$DUPES_REPORT"

# Collect all index.html locations
echo "=== index.html locations ===" >> "$DUPES_REPORT"
for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"
  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue
  find "$path" -maxdepth "$maxd" -name "index.html" -type f 2>/dev/null | while read f; do
    [[ "$f" == *"node_modules"* ]] && continue
    [[ "$f" == *".git/"* ]] && continue
    size=$(stat -f%z "$f" 2>/dev/null || echo "0")
    short=$(echo "$f" | sed "s|$HOME|~|")
    echo "$size|$short" >> "$DUPES_REPORT"
  done
done

# Collect all CLAUDE.md locations
echo "" >> "$DUPES_REPORT"
echo "=== CLAUDE.md / CLAUDE*.md locations ===" >> "$DUPES_REPORT"
for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"
  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue
  find "$path" -maxdepth "$maxd" -iname "CLAUDE*.md" -type f 2>/dev/null | while read f; do
    [[ "$f" == *"node_modules"* ]] && continue
    [[ "$f" == *".git/"* ]] && continue
    size=$(stat -f%z "$f" 2>/dev/null || echo "0")
    short=$(echo "$f" | sed "s|$HOME|~|")
    echo "$size|$short" >> "$DUPES_REPORT"
  done
done

# Collect all .zip locations
echo "" >> "$DUPES_REPORT"
echo "=== .zip files ===" >> "$DUPES_REPORT"
for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"
  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue
  find "$path" -maxdepth "$maxd" -name "*.zip" -type f 2>/dev/null | while read f; do
    [[ "$f" == *"node_modules"* ]] && continue
    size=$(du -sh "$f" 2>/dev/null | cut -f1 || echo "?")
    short=$(echo "$f" | sed "s|$HOME|~|")
    echo "$size|$short" >> "$DUPES_REPORT"
  done
done

###############################################################################
# PHASE 10: FOLDER SIZE MAP (every top-level folder with size)
###############################################################################

log "========== PHASE 10: FOLDER SIZE MAP =========="

SIZE_REPORT="$RAW_DIR/folder_sizes.txt"
echo "# FOLDER SIZES (sorted by size)" > "$SIZE_REPORT"
echo "" >> "$SIZE_REPORT"

for loc in "${LOCATIONS[@]}"; do
  IFS='|' read -r label path maxd <<< "$loc"

  [ ! -d "$path" ] && continue
  [ "$label" = "MACINTOSH-HD-HOME" ] && continue

  log "Phase 10: Folder sizes in $label"

  echo "=== $label ===" >> "$SIZE_REPORT"
  du -sh "$path"/*/ 2>/dev/null | sort -rh | sed "s|$HOME|~|g" >> "$SIZE_REPORT"
  echo "" >> "$SIZE_REPORT"
done

###############################################################################
# PHASE 11: GITHUB REPOS (both accounts via gh CLI)
###############################################################################

log "========== PHASE 11: GITHUB REPOS =========="

GH_REPORT="$RAW_DIR/github_repos.txt"
echo "# ALL GITHUB REPOSITORIES" > "$GH_REPORT"
echo "" >> "$GH_REPORT"

if command -v gh &> /dev/null; then
  # gabosaturno11 — primary account (19+ repos)
  log "Phase 11: Fetching gabosaturno11 repos from GitHub"
  echo "=== gabosaturno11 ===" >> "$GH_REPORT"
  gh api "users/gabosaturno11/repos?per_page=100&sort=updated" --jq '.[] | "GH|gabosaturno11|\(.name)|\(.html_url)|\(.homepage // "none")|\(.has_pages)|\(.size)KB|\(.updated_at)|\(.pushed_at)|\(.default_branch)|\(.description // "none")"' 2>/dev/null >> "$GH_REPORT" || echo "ERROR: Could not fetch gabosaturno11 repos" >> "$GH_REPORT"
  echo "" >> "$GH_REPORT"

  # gabosaturno03 — legacy account (6+ repos)
  log "Phase 11: Fetching gabosaturno03 repos from GitHub"
  echo "=== gabosaturno03 ===" >> "$GH_REPORT"
  gh api "users/gabosaturno03/repos?per_page=100&sort=updated" --jq '.[] | "GH|gabosaturno03|\(.name)|\(.html_url)|\(.homepage // "none")|\(.has_pages)|\(.size)KB|\(.updated_at)|\(.pushed_at)|\(.default_branch)|\(.description // "none")"' 2>/dev/null >> "$GH_REPORT" || echo "ERROR: Could not fetch gabosaturno03 repos" >> "$GH_REPORT"
  echo "" >> "$GH_REPORT"

  # Check for GitHub Pages deployments
  log "Phase 11: Checking GitHub Pages deployments"
  echo "=== GITHUB PAGES DEPLOYMENTS ===" >> "$GH_REPORT"

  # gabosaturno11 repos with pages enabled
  gh api "users/gabosaturno11/repos?per_page=100" --jq '.[] | select(.has_pages == true) | "PAGES|gabosaturno11|\(.name)|https://gabosaturno11.github.io/\(.name)/|\(.updated_at)"' 2>/dev/null >> "$GH_REPORT" || true

  # gabosaturno03 repos with pages enabled
  gh api "users/gabosaturno03/repos?per_page=100" --jq '.[] | select(.has_pages == true) | "PAGES|gabosaturno03|\(.name)|https://gabosaturno03.github.io/\(.name)/|\(.updated_at)"' 2>/dev/null >> "$GH_REPORT" || true

  echo "" >> "$GH_REPORT"
else
  echo "ERROR: gh CLI not installed. Cannot fetch GitHub repos." >> "$GH_REPORT"
fi

###############################################################################
# PHASE 12: VERCEL DEPLOYMENTS (all projects via vercel CLI)
###############################################################################

log "========== PHASE 12: VERCEL DEPLOYMENTS =========="

VERCEL_DEPLOY_REPORT="$RAW_DIR/vercel_deployments.txt"
echo "# ALL VERCEL PROJECTS AND DEPLOYMENTS" > "$VERCEL_DEPLOY_REPORT"
echo "" >> "$VERCEL_DEPLOY_REPORT"

if command -v vercel &> /dev/null; then
  # List all projects from current team
  log "Phase 12: Listing all Vercel projects"
  echo "=== VERCEL PROJECTS (gabriele-saturnos-projects) ===" >> "$VERCEL_DEPLOY_REPORT"
  vercel project ls 2>/dev/null >> "$VERCEL_DEPLOY_REPORT" || echo "ERROR: Could not list Vercel projects" >> "$VERCEL_DEPLOY_REPORT"
  echo "" >> "$VERCEL_DEPLOY_REPORT"

  # Try the old team too
  echo "=== VERCEL PROJECTS (saturno-os - OLD TEAM) ===" >> "$VERCEL_DEPLOY_REPORT"
  vercel project ls --scope saturno-os 2>/dev/null >> "$VERCEL_DEPLOY_REPORT" || echo "Could not access saturno-os team (may need auth)" >> "$VERCEL_DEPLOY_REPORT"
  echo "" >> "$VERCEL_DEPLOY_REPORT"

  # Get domains for each known project
  log "Phase 12: Checking domains and aliases"
  echo "=== VERCEL DOMAINS ===" >> "$VERCEL_DEPLOY_REPORT"
  vercel domains ls 2>/dev/null >> "$VERCEL_DEPLOY_REPORT" || echo "No custom domains found" >> "$VERCEL_DEPLOY_REPORT"
  echo "" >> "$VERCEL_DEPLOY_REPORT"
else
  echo "ERROR: vercel CLI not installed. Cannot fetch Vercel deployments." >> "$VERCEL_DEPLOY_REPORT"
fi

###############################################################################
# PHASE 13: DEEP REPO ANALYSIS (README, structure, file types)
###############################################################################

log "========== PHASE 13: DEEP REPO ANALYSIS =========="

DEEP_REPORT="$RAW_DIR/deep_repo_analysis.txt"
echo "# DEEP REPOSITORY ANALYSIS" > "$DEEP_REPORT"
echo "# Every repo: README content, folder structure, file types, config files" >> "$DEEP_REPORT"
echo "" >> "$DEEP_REPORT"

grep "^REPO|" "$RAW_DIR/all_git_repos.txt" 2>/dev/null | while IFS='|' read -r type dir remote branch date msg commits dirty vercel team size has_nm nm_size; do
  # Expand ~ back to $HOME
  full_dir=$(echo "$dir" | sed "s|^~|$HOME|")

  [ ! -d "$full_dir" ] && continue

  echo "================================================================" >> "$DEEP_REPORT"
  echo "REPO: $dir" >> "$DEEP_REPORT"
  echo "Remote: $remote" >> "$DEEP_REPORT"
  echo "Branch: $branch | Commits: $commits | Dirty files: $dirty" >> "$DEEP_REPORT"
  echo "Last commit: $date — $msg" >> "$DEEP_REPORT"
  echo "Size: $size | Vercel: $vercel ($team) | node_modules: $has_nm ($nm_size)" >> "$DEEP_REPORT"
  echo "" >> "$DEEP_REPORT"

  # Folder structure (depth 3, no node_modules/.git)
  echo "--- STRUCTURE ---" >> "$DEEP_REPORT"
  find "$full_dir" -maxdepth 3 -not -path "*/node_modules/*" -not -path "*/.git/*" -not -name ".DS_Store" 2>/dev/null | sed "s|$full_dir|.|" | sort >> "$DEEP_REPORT"
  echo "" >> "$DEEP_REPORT"

  # README content
  for readme_file in README.md readme.md README README.txt; do
    if [ -f "$full_dir/$readme_file" ]; then
      echo "--- README ($readme_file) ---" >> "$DEEP_REPORT"
      head -100 "$full_dir/$readme_file" 2>/dev/null >> "$DEEP_REPORT"
      readme_lines=$(wc -l < "$full_dir/$readme_file" 2>/dev/null | tr -d ' ')
      [ "$readme_lines" -gt 100 ] && echo "[... truncated, $readme_lines total lines]" >> "$DEEP_REPORT"
      echo "" >> "$DEEP_REPORT"
      break
    fi
  done

  # CLAUDE.md content (if exists)
  if [ -f "$full_dir/CLAUDE.md" ]; then
    echo "--- CLAUDE.md ---" >> "$DEEP_REPORT"
    head -50 "$full_dir/CLAUDE.md" 2>/dev/null >> "$DEEP_REPORT"
    claude_lines=$(wc -l < "$full_dir/CLAUDE.md" 2>/dev/null | tr -d ' ')
    [ "$claude_lines" -gt 50 ] && echo "[... truncated, $claude_lines total lines]" >> "$DEEP_REPORT"
    echo "" >> "$DEEP_REPORT"
  fi

  # Package.json info
  if [ -f "$full_dir/package.json" ]; then
    echo "--- PACKAGE.JSON ---" >> "$DEEP_REPORT"
    python3 -c "
import json
with open('$full_dir/package.json') as f:
    d = json.load(f)
print(f'Name: {d.get(\"name\",\"?\")}')
print(f'Version: {d.get(\"version\",\"?\")}')
print(f'Description: {d.get(\"description\",\"?\")}')
deps = d.get('dependencies',{})
devdeps = d.get('devDependencies',{})
print(f'Dependencies: {len(deps)}')
for k,v in list(deps.items())[:20]:
    print(f'  {k}: {v}')
if len(deps) > 20:
    print(f'  ... and {len(deps)-20} more')
print(f'DevDependencies: {len(devdeps)}')
scripts = d.get('scripts',{})
print(f'Scripts: {list(scripts.keys())}')
" 2>/dev/null >> "$DEEP_REPORT" || echo "Could not parse package.json" >> "$DEEP_REPORT"
    echo "" >> "$DEEP_REPORT"
  fi

  # Vercel.json info
  if [ -f "$full_dir/vercel.json" ]; then
    echo "--- VERCEL.JSON ---" >> "$DEEP_REPORT"
    cat "$full_dir/vercel.json" 2>/dev/null >> "$DEEP_REPORT"
    echo "" >> "$DEEP_REPORT"
  fi

  # File type breakdown
  echo "--- FILE TYPES ---" >> "$DEEP_REPORT"
  find "$full_dir" -maxdepth 5 -type f -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -20 >> "$DEEP_REPORT"
  echo "" >> "$DEEP_REPORT"

  # Git log (last 10 commits)
  echo "--- LAST 10 COMMITS ---" >> "$DEEP_REPORT"
  git -C "$full_dir" log --oneline -10 2>/dev/null >> "$DEEP_REPORT" || echo "No commits" >> "$DEEP_REPORT"
  echo "" >> "$DEEP_REPORT"

  # Uncommitted changes
  if [ "$dirty" -gt 0 ] 2>/dev/null; then
    echo "--- UNCOMMITTED CHANGES ---" >> "$DEEP_REPORT"
    git -C "$full_dir" status --short 2>/dev/null | head -30 >> "$DEEP_REPORT"
    echo "" >> "$DEEP_REPORT"
  fi

  echo "" >> "$DEEP_REPORT"
done

###############################################################################
# PHASE 14: DEEP FOLDER ANALYSIS (non-git folders with structure)
###############################################################################

log "========== PHASE 14: DEEP FOLDER ANALYSIS =========="

FOLDER_DEEP="$RAW_DIR/deep_folder_analysis.txt"
echo "# DEEP FOLDER ANALYSIS (non-git top-level folders)" > "$FOLDER_DEEP"
echo "" >> "$FOLDER_DEEP"

# Analyze top-level folders on each drive
for drive_label in "GDRIVE-ARMOR" "SSK-DRIVE" "T7-DRIVE"; do
  case "$drive_label" in
    "GDRIVE-ARMOR") drive_path="/Volumes/G-DRIVE ArmorATD" ;;
    "SSK-DRIVE") drive_path="/Volumes/SSK Drive" ;;
    "T7-DRIVE") drive_path="/Volumes/T7" ;;
  esac

  [ ! -d "$drive_path" ] && continue

  log "Phase 14: Deep analysis of $drive_label"

  echo "================================================================" >> "$FOLDER_DEEP"
  echo "DRIVE: $drive_label ($drive_path)" >> "$FOLDER_DEEP"
  echo "" >> "$FOLDER_DEEP"

  # Each top-level folder
  for folder in "$drive_path"/*/; do
    [ ! -d "$folder" ] && continue
    fname=$(basename "$folder")

    # Skip hidden folders
    [[ "$fname" == .* ]] && continue
    [[ "$fname" == '$RECYCLE.BIN' ]] && continue
    [[ "$fname" == "System Volume Information" ]] && continue

    folder_size=$(du -sh "$folder" 2>/dev/null | cut -f1 || echo "?")
    file_count=$(find "$folder" -maxdepth 8 -type f 2>/dev/null | wc -l | tr -d ' ')
    dir_count=$(find "$folder" -maxdepth 8 -type d 2>/dev/null | wc -l | tr -d ' ')

    echo "--- $fname ($folder_size, $file_count files, $dir_count dirs) ---" >> "$FOLDER_DEEP"

    # Structure depth 3
    find "$folder" -maxdepth 3 -type d -not -path "*/node_modules/*" -not -path "*/.git/*" -not -name ".DS_Store" 2>/dev/null | sed "s|$folder|  |" | sort >> "$FOLDER_DEEP"
    echo "" >> "$FOLDER_DEEP"

    # README if exists
    for readme_file in README.md readme.md README; do
      if [ -f "$folder/$readme_file" ]; then
        echo "  README:" >> "$FOLDER_DEEP"
        head -30 "$folder/$readme_file" 2>/dev/null | sed 's/^/    /' >> "$FOLDER_DEEP"
        echo "" >> "$FOLDER_DEEP"
        break
      fi
    done

    # File type breakdown
    echo "  File types:" >> "$FOLDER_DEEP"
    find "$folder" -maxdepth 8 -type f -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | sed 's/^/    /' >> "$FOLDER_DEEP"
    echo "" >> "$FOLDER_DEEP"
  done
done

# Same for cloud drives
for cloud_label in "GDRIVE-GABO" "GDRIVE-REACH" "GDRIVE-ACADEMY" "ONEDRIVE" "ICLOUD"; do
  case "$cloud_label" in
    "GDRIVE-GABO") cloud_path="$HOME/Library/CloudStorage/GoogleDrive-gabo@saturnomovement.com" ;;
    "GDRIVE-REACH") cloud_path="$HOME/Library/CloudStorage/GoogleDrive-reach@saturnomovement.com" ;;
    "GDRIVE-ACADEMY") cloud_path="$HOME/Library/CloudStorage/GoogleDrive-smacademycontent@gmail.com" ;;
    "ONEDRIVE") cloud_path="$HOME/Library/CloudStorage/OneDrive-Personal" ;;
    "ICLOUD") cloud_path="$HOME/Library/Mobile Documents/com~apple~CloudDocs" ;;
  esac

  [ ! -d "$cloud_path" ] && continue

  log "Phase 14: Deep analysis of $cloud_label"

  echo "================================================================" >> "$FOLDER_DEEP"
  echo "CLOUD: $cloud_label" >> "$FOLDER_DEEP"
  echo "" >> "$FOLDER_DEEP"

  # Top-level size
  echo "Total size: $(du -sh "$cloud_path" 2>/dev/null | cut -f1 || echo '?')" >> "$FOLDER_DEEP"
  echo "" >> "$FOLDER_DEEP"

  # Each top-level folder
  for folder in "$cloud_path"/*/; do
    [ ! -d "$folder" ] && continue
    fname=$(basename "$folder")
    [[ "$fname" == .* ]] && continue

    folder_size=$(du -sh "$folder" 2>/dev/null | cut -f1 || echo "?")
    file_count=$(find "$folder" -maxdepth 6 -type f 2>/dev/null | wc -l | tr -d ' ')

    echo "--- $fname ($folder_size, $file_count files) ---" >> "$FOLDER_DEEP"

    # Structure depth 3
    find "$folder" -maxdepth 3 -type d -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | sed "s|$folder|  |" | sort >> "$FOLDER_DEEP"
    echo "" >> "$FOLDER_DEEP"

    # File types
    echo "  File types:" >> "$FOLDER_DEEP"
    find "$folder" -maxdepth 6 -type f -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | sed 's/^/    /' >> "$FOLDER_DEEP"
    echo "" >> "$FOLDER_DEEP"
  done
done

# Desktop and Downloads deep analysis
for local_label in "DESKTOP" "DOWNLOADS" "PROJECTS"; do
  case "$local_label" in
    "DESKTOP") local_path="$HOME/Desktop" ;;
    "DOWNLOADS") local_path="$HOME/Downloads" ;;
    "PROJECTS") local_path="$HOME/Projects" ;;
  esac

  [ ! -d "$local_path" ] && continue

  log "Phase 14: Deep analysis of $local_label"

  echo "================================================================" >> "$FOLDER_DEEP"
  echo "LOCAL: $local_label ($local_path)" >> "$FOLDER_DEEP"
  echo "" >> "$FOLDER_DEEP"

  echo "Total size: $(du -sh "$local_path" 2>/dev/null | cut -f1 || echo '?')" >> "$FOLDER_DEEP"
  echo "" >> "$FOLDER_DEEP"

  for folder in "$local_path"/*/; do
    [ ! -d "$folder" ] && continue
    fname=$(basename "$folder")
    [[ "$fname" == .* ]] && continue

    folder_size=$(du -sh "$folder" 2>/dev/null | cut -f1 || echo "?")
    file_count=$(find "$folder" -maxdepth 6 -type f 2>/dev/null | wc -l | tr -d ' ')

    echo "--- $fname ($folder_size, $file_count files) ---" >> "$FOLDER_DEEP"

    find "$folder" -maxdepth 3 -type d -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | sed "s|$folder|  |" | sort >> "$FOLDER_DEEP"
    echo "" >> "$FOLDER_DEEP"

    echo "  File types:" >> "$FOLDER_DEEP"
    find "$folder" -maxdepth 6 -type f -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | sed 's/^/    /' >> "$FOLDER_DEEP"
    echo "" >> "$FOLDER_DEEP"
  done
done

###############################################################################
# PHASE 15: GITHUB PAGES LIVE CHECK (curl each one)
###############################################################################

log "========== PHASE 15: GITHUB PAGES LIVE CHECK =========="

PAGES_REPORT="$RAW_DIR/github_pages_live.txt"
echo "# GITHUB PAGES LIVE STATUS CHECK" > "$PAGES_REPORT"
echo "" >> "$PAGES_REPORT"

if [ -f "$RAW_DIR/github_repos.txt" ]; then
  grep "^PAGES|" "$RAW_DIR/github_repos.txt" 2>/dev/null | while IFS='|' read -r type acct name url updated; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "ERR")
    title=$(curl -s "$url" 2>/dev/null | grep -o '<title>[^<]*</title>' | head -1 | sed 's/<[^>]*>//g' || echo "?")
    size=$(curl -s "$url" 2>/dev/null | wc -c | tr -d ' ')
    echo "LIVE|$acct|$name|$url|$status|$size|$title" >> "$PAGES_REPORT"
    log "  $name: HTTP $status ($size bytes)"
  done
fi

###############################################################################
# COMPILE FINAL REPORT
###############################################################################

log "========== COMPILING FINAL REPORT =========="

cat > "$REPORT" << HEADER
# SATURNO OVERNIGHT DEEP AUDIT
## Complete System Scan

**Date:** $(date)
**Machine:** iMac (C2) - /Users/Gabosaturno
**Duration:** Started $(date -r "$RAW_DIR/tree_DEV-CANONICAL.txt" '+%H:%M:%S' 2>/dev/null || echo "?") - Ended $(date '+%H:%M:%S')

---

## STORAGE OVERVIEW

\`\`\`
$(df -h / /Volumes/G-DRIVE\ ArmorATD /Volumes/SSK\ Drive /Volumes/T7 2>/dev/null)
\`\`\`

---

## SUMMARY COUNTS

HEADER

# Count everything
git_count=$(grep -c "^REPO|" "$RAW_DIR/all_git_repos.txt" 2>/dev/null || echo "0")
vercel_count=$(grep -c "^VERCEL|" "$RAW_DIR/all_vercel_configs.txt" 2>/dev/null || echo "0")
html_count=$(grep -c "^HTML|" "$RAW_DIR/all_html_apps.txt" 2>/dev/null || echo "0")
nm_count=$(grep -c "^NM|" "$RAW_DIR/all_node_modules.txt" 2>/dev/null || echo "0")
pkg_count=$(grep -c "^PKG|" "$RAW_DIR/all_package_json.txt" 2>/dev/null || echo "0")
large_count=$(grep -c "^BIG|" "$RAW_DIR/large_files.txt" 2>/dev/null || echo "0")
gh11_count=$(grep -c "^GH|gabosaturno11|" "$RAW_DIR/github_repos.txt" 2>/dev/null || echo "0")
gh03_count=$(grep -c "^GH|gabosaturno03|" "$RAW_DIR/github_repos.txt" 2>/dev/null || echo "0")
pages_count=$(grep -c "^PAGES|" "$RAW_DIR/github_repos.txt" 2>/dev/null || echo "0")

cat >> "$REPORT" << EOF
| Metric | Count |
|--------|-------|
| Git Repositories (local) | $git_count |
| GitHub Repos (gabosaturno11) | $gh11_count |
| GitHub Repos (gabosaturno03) | $gh03_count |
| GitHub Pages (live) | $pages_count |
| Vercel Configs (local) | $vercel_count |
| HTML Apps (with JS) | $html_count |
| Node_modules Dirs | $nm_count |
| Package.json Files | $pkg_count |
| Large Files (>50MB) | $large_count |

---

## GIT REPOSITORIES

EOF

# Git repos table
echo "| Location | Remote | Branch | Last Commit | Commits | Dirty | Vercel | Size | node_modules |" >> "$REPORT"
echo "|----------|--------|--------|-------------|---------|-------|--------|------|-------------|" >> "$REPORT"

grep "^REPO|" "$RAW_DIR/all_git_repos.txt" 2>/dev/null | while IFS='|' read -r type dir remote branch date msg commits dirty vercel team size has_nm nm_size; do
  short_date=$(echo "$date" | cut -d' ' -f1)
  nm_info=""
  [ "$has_nm" = "yes" ] && nm_info="$nm_size"
  vercel_info=""
  [ "$vercel" = "yes" ] && vercel_info="$team"
  echo "| \`$dir\` | $remote | $branch | $short_date | $commits | $dirty | $vercel_info | $size | $nm_info |" >> "$REPORT"
done

echo "" >> "$REPORT"

# Vercel configs
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## VERCEL CONFIGS" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Directory | Project ID | Team |" >> "$REPORT"
echo "|-----------|------------|------|" >> "$REPORT"

grep "^VERCEL|" "$RAW_DIR/all_vercel_configs.txt" 2>/dev/null | while IFS='|' read -r type dir pid team; do
  echo "| \`$dir\` | \`$pid\` | $team |" >> "$REPORT"
done

echo "" >> "$REPORT"

# Node modules
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## NODE_MODULES (RECLAIMABLE SPACE)" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Location | Size |" >> "$REPORT"
echo "|----------|------|" >> "$REPORT"

grep "^NM|" "$RAW_DIR/all_node_modules.txt" 2>/dev/null | sort -t'|' -k3 -rh | while IFS='|' read -r type dir size; do
  echo "| \`$dir\` | $size |" >> "$REPORT"
done

echo "" >> "$REPORT"

# Large files
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## LARGE FILES (>50MB)" >> "$REPORT"
echo "" >> "$REPORT"
echo "| Size | Type | Path |" >> "$REPORT"
echo "|------|------|------|" >> "$REPORT"

grep "^BIG|" "$RAW_DIR/large_files.txt" 2>/dev/null | sort -t'|' -k2 -rh | head -200 | while IFS='|' read -r type size ext path; do
  echo "| $size | .$ext | \`$path\` |" >> "$REPORT"
done

echo "" >> "$REPORT"

# Project searches — only show ones with matches
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## PROJECT NAME SEARCH RESULTS" >> "$REPORT"
echo "" >> "$REPORT"

current_term=""
while IFS= read -r line; do
  if [[ "$line" == "=== "* ]]; then
    current_term=$(echo "$line" | sed 's/=== //' | sed 's/ ===//')
    matches=$(grep -c "^[DF]" <<< "$(sed -n "/^=== $current_term ===/,/^===/p" "$RAW_DIR/all_project_searches.txt" 2>/dev/null)" 2>/dev/null || echo "0")
    if [ "$matches" -gt 0 ]; then
      echo "### \`$current_term\` ($matches matches)" >> "$REPORT"
      echo "" >> "$REPORT"
      echo "| Type | Location | Path |" >> "$REPORT"
      echo "|------|----------|------|" >> "$REPORT"
    fi
  elif [[ "$line" == DIR* ]] || [[ "$line" == FILE* ]]; then
    IFS='|' read -r ftype floc fpath <<< "$line"
    echo "| $ftype | $floc | \`$fpath\` |" >> "$REPORT"
  fi
done < "$RAW_DIR/all_project_searches.txt"

echo "" >> "$REPORT"

# GitHub repos
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## GITHUB REPOSITORIES" >> "$REPORT"
echo "" >> "$REPORT"

if [ -f "$RAW_DIR/github_repos.txt" ]; then
  echo "### gabosaturno11" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "| Repo | URL | Homepage | Pages | Size | Last Push | Branch | Description |" >> "$REPORT"
  echo "|------|-----|----------|-------|------|-----------|--------|-------------|" >> "$REPORT"

  grep "^GH|gabosaturno11|" "$RAW_DIR/github_repos.txt" 2>/dev/null | while IFS='|' read -r type acct name url homepage pages size updated pushed branch desc; do
    echo "| $name | $url | $homepage | $pages | $size | $pushed | $branch | $desc |" >> "$REPORT"
  done

  echo "" >> "$REPORT"
  echo "### gabosaturno03" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "| Repo | URL | Homepage | Pages | Size | Last Push | Branch | Description |" >> "$REPORT"
  echo "|------|-----|----------|-------|------|-----------|--------|-------------|" >> "$REPORT"

  grep "^GH|gabosaturno03|" "$RAW_DIR/github_repos.txt" 2>/dev/null | while IFS='|' read -r type acct name url homepage pages size updated pushed branch desc; do
    echo "| $name | $url | $homepage | $pages | $size | $pushed | $branch | $desc |" >> "$REPORT"
  done

  echo "" >> "$REPORT"
  echo "### GitHub Pages (LIVE)" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "| Account | Repo | Live URL | Last Updated |" >> "$REPORT"
  echo "|---------|------|----------|-------------|" >> "$REPORT"

  grep "^PAGES|" "$RAW_DIR/github_repos.txt" 2>/dev/null | while IFS='|' read -r type acct name url updated; do
    echo "| $acct | $name | $url | $updated |" >> "$REPORT"
  done

  echo "" >> "$REPORT"
fi

# Vercel deployments
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## VERCEL PROJECTS AND DEPLOYMENTS" >> "$REPORT"
echo "" >> "$REPORT"
echo '```' >> "$REPORT"
cat "$RAW_DIR/vercel_deployments.txt" 2>/dev/null >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# Folder sizes
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## FOLDER SIZES" >> "$REPORT"
echo "" >> "$REPORT"
echo '```' >> "$REPORT"
cat "$RAW_DIR/folder_sizes.txt" >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# Duplicates
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## DUPLICATE DETECTION" >> "$REPORT"
echo "" >> "$REPORT"
echo '```' >> "$REPORT"
cat "$RAW_DIR/potential_duplicates.txt" >> "$REPORT"
echo '```' >> "$REPORT"

# Deep repo analysis
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## DEEP REPOSITORY ANALYSIS" >> "$REPORT"
echo "" >> "$REPORT"
echo '```' >> "$REPORT"
cat "$RAW_DIR/deep_repo_analysis.txt" 2>/dev/null >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# Deep folder analysis
echo "---" >> "$REPORT"
echo "" >> "$REPORT"
echo "## DEEP FOLDER ANALYSIS" >> "$REPORT"
echo "" >> "$REPORT"
echo '```' >> "$REPORT"
cat "$RAW_DIR/deep_folder_analysis.txt" 2>/dev/null >> "$REPORT"
echo '```' >> "$REPORT"
echo "" >> "$REPORT"

# GitHub Pages live check
if [ -f "$RAW_DIR/github_pages_live.txt" ]; then
  echo "---" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "## GITHUB PAGES LIVE STATUS" >> "$REPORT"
  echo "" >> "$REPORT"
  echo "| Account | Repo | URL | HTTP | Size | Title |" >> "$REPORT"
  echo "|---------|------|-----|------|------|-------|" >> "$REPORT"

  grep "^LIVE|" "$RAW_DIR/github_pages_live.txt" 2>/dev/null | while IFS='|' read -r type acct name url status size title; do
    echo "| $acct | $name | $url | $status | $size | $title |" >> "$REPORT"
  done
  echo "" >> "$REPORT"
fi

# Footer
cat >> "$REPORT" << EOF

---

## RAW DATA FILES

All scan data is saved in individual files at:
\`~/dev/astra-command-center/logs/raw/\`

| File | Content |
|------|---------|
| tree_*.txt | Directory trees for each location |
| all_git_repos.txt | Every git repo with full metadata |
| all_vercel_configs.txt | Every .vercel/project.json |
| all_html_apps.txt | Every HTML file with scripts |
| all_node_modules.txt | Every node_modules with size |
| all_package_json.txt | Every package.json with name/version |
| all_project_searches.txt | 34 project name search results |
| large_files.txt | Files >50MB |
| potential_duplicates.txt | Same-name files in multiple locations |
| folder_sizes.txt | Top-level folder sizes sorted |
| github_repos.txt | All GitHub repos (both accounts) + Pages |
| vercel_deployments.txt | All Vercel projects and domains |
| deep_repo_analysis.txt | Every repo: README, structure, config, commits |
| deep_folder_analysis.txt | Every folder: structure, file types, sizes |
| github_pages_live.txt | Live status check of all GitHub Pages |

---

*Generated by overnight-deep-audit.sh*
*Script: ~/dev/astra-command-center/scripts/overnight-deep-audit.sh*
*Run again anytime: nohup bash ~/dev/astra-command-center/scripts/overnight-deep-audit.sh > /tmp/overnight-audit.log 2>&1 &*
EOF

log "========== AUDIT COMPLETE =========="
log "Report: $REPORT"
log "Report size: $(wc -l < "$REPORT" | tr -d ' ') lines"
log "Raw data: $RAW_DIR/"
log ""
log "SUMMARY:"
log "  Git repos:     $git_count"
log "  Vercel configs: $vercel_count"
log "  HTML apps:     $html_count"
log "  node_modules:  $nm_count"
log "  package.json:  $pkg_count"
log "  Large files:   $large_count"
