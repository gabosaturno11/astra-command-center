#!/usr/bin/env zsh
# SATURNO ECOSYSTEM BUG HUNTER — 5 HOUR AUTONOMOUS SCRIPT
# Keeps machine awake with caffeinate, recursively scans ALL repos for bugs
# Output: ~/dev/astra-command-center/logs/BUG_HUNT_REPORT_$(date).md
#
# Usage: bash ~/dev/astra-command-center/logs/bug-hunter-5h.sh

set -euo pipefail

REPORT="$HOME/dev/astra-command-center/logs/BUG_HUNT_REPORT_$(date +%Y%m%d_%H%M%S).md"
REPOS_DIR="$HOME/dev"
START_TIME=$(date +%s)
DURATION=18000  # 5 hours in seconds

# Start caffeinate in background (prevent sleep for 5h)
caffeinate -dims -t $DURATION &
CAFF_PID=$!
echo "Caffeinate started (PID: $CAFF_PID) for 5 hours"

# Cleanup on exit
cleanup() {
  kill $CAFF_PID 2>/dev/null || true
  echo ""
  echo "Bug hunt completed. Report saved to: $REPORT"
}
trap cleanup EXIT

# Initialize report
cat > "$REPORT" << 'HEADER'
# SATURNO ECOSYSTEM BUG HUNT REPORT
HEADER
echo "## Generated: $(date)" >> "$REPORT"
echo "## Duration: 5 hours" >> "$REPORT"
echo "" >> "$REPORT"
echo "---" >> "$REPORT"
echo "" >> "$REPORT"

log() {
  echo "$1" >> "$REPORT"
}

section() {
  echo "" >> "$REPORT"
  echo "## $1" >> "$REPORT"
  echo "" >> "$REPORT"
}

subsection() {
  echo "" >> "$REPORT"
  echo "### $1" >> "$REPORT"
  echo "" >> "$REPORT"
}

found_bug() {
  echo "- **BUG:** $1" >> "$REPORT"
  BUG_COUNT=$((BUG_COUNT + 1))
}

found_warning() {
  echo "- **WARNING:** $1" >> "$REPORT"
  WARN_COUNT=$((WARN_COUNT + 1))
}

BUG_COUNT=0
WARN_COUNT=0

# ============================================================
# PHASE 1: REPO INVENTORY AND GIT STATUS
# ============================================================
section "PHASE 1: REPO INVENTORY AND GIT STATUS"

for repo in "$REPOS_DIR"/*/; do
  repo_name=$(basename "$repo")
  if [ -d "$repo/.git" ]; then
    subsection "$repo_name"

    # Git status
    cd "$repo"
    git_st=$(git status --porcelain 2>/dev/null || echo "ERROR")
    if [ -n "$git_st" ] && [ "$git_st" != "ERROR" ]; then
      found_warning "$repo_name has uncommitted changes:"
      echo '```' >> "$REPORT"
      echo "$git_st" >> "$REPORT"
      echo '```' >> "$REPORT"
    else
      log "- Clean working tree"
    fi

    # Check if behind remote
    git fetch origin 2>/dev/null || true
    behind=$(git rev-list HEAD..origin/main --count 2>/dev/null || echo "0")
    ahead=$(git rev-list origin/main..HEAD --count 2>/dev/null || echo "0")
    if [ "$behind" -gt 0 ] 2>/dev/null; then
      found_warning "$repo_name is $behind commits BEHIND origin/main"
    fi
    if [ "$ahead" -gt 0 ] 2>/dev/null; then
      found_warning "$repo_name is $ahead commits AHEAD of origin/main (not pushed)"
    fi

    # Check for large files
    large_files=$(find . -not -path './.git/*' -type f -size +5M 2>/dev/null | head -20)
    if [ -n "$large_files" ]; then
      found_warning "$repo_name has files > 5MB:"
      echo '```' >> "$REPORT"
      echo "$large_files" | while read f; do
        size=$(du -h "$f" 2>/dev/null | cut -f1)
        echo "  $size  $f"
      done >> "$REPORT"
      echo '```' >> "$REPORT"
    fi

    cd "$REPOS_DIR"
  fi
done

# ============================================================
# PHASE 2: DEAD LINKS AND STALE URLS
# ============================================================
section "PHASE 2: DEAD LINKS AND STALE URLS"

# Known stale patterns
STALE_PATTERNS=(
  "saturno-bonus-omega.vercel.app"
  "titan-forge.vercel.app/"
  "localhost:3000"
  "localhost:3001"
  "http://localhost"
  "placeholder.com"
  "example.com"
  "TODO"
  "FIXME"
  "HACK"
  "XXX"
)

for repo in "$REPOS_DIR"/*/; do
  repo_name=$(basename "$repo")
  if [ -d "$repo/.git" ]; then
    for pattern in "${STALE_PATTERNS[@]}"; do
      matches=$(grep -r --include="*.html" --include="*.js" --include="*.json" --include="*.md" --include="*.css" -l "$pattern" "$repo" 2>/dev/null | grep -v node_modules | grep -v .git | grep -v package-lock || true)
      if [ -n "$matches" ]; then
        found_bug "Stale pattern '$pattern' found in $repo_name:"
        echo "$matches" | while read f; do
          count=$(grep -c "$pattern" "$f" 2>/dev/null || echo "0")
          echo "  - $f ($count occurrences)" >> "$REPORT"
        done
      fi
    done
  fi
done

# ============================================================
# PHASE 3: AUTH AND SECURITY AUDIT
# ============================================================
section "PHASE 3: AUTH AND SECURITY AUDIT"

# Check for hardcoded secrets
SECRET_PATTERNS=(
  "sk-[a-zA-Z0-9]"
  "Bearer [a-zA-Z0-9]"
  "password.*=.*['\"]"
  "api[_-]?key.*=.*['\"]"
  "secret.*=.*['\"]"
  "token.*=.*['\"]"
)

for repo in "$REPOS_DIR"/*/; do
  repo_name=$(basename "$repo")
  if [ -d "$repo/.git" ]; then
    for pattern in "${SECRET_PATTERNS[@]}"; do
      matches=$(grep -rn --include="*.js" --include="*.html" --include="*.json" -E "$pattern" "$repo" 2>/dev/null | grep -v node_modules | grep -v .git | grep -v package-lock | grep -v CLAUDE.md | grep -v gabo-messages | head -10 || true)
      if [ -n "$matches" ]; then
        found_warning "Possible hardcoded secret in $repo_name (pattern: $pattern):"
        echo '```' >> "$REPORT"
        echo "$matches" >> "$REPORT"
        echo '```' >> "$REPORT"
      fi
    done
  fi
done

# Check middleware status for each deployed repo
subsection "Middleware Status"
for repo in astra-command-center saturno-bonus de-aqui-a-saturno titan-forge; do
  if [ -f "$REPOS_DIR/$repo/middleware.js" ]; then
    log "- $repo: middleware.js EXISTS"
  else
    found_bug "$repo: NO middleware.js — potentially unprotected"
  fi
done

# ============================================================
# PHASE 4: VERCEL DEPLOYMENT CHECKS
# ============================================================
section "PHASE 4: LIVE URL HEALTH CHECKS"

check_url() {
  local name="$1" url="$2"
  http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "TIMEOUT")
  if [ "$http_code" = "200" ]; then
    log "- $name ($url): HTTP $http_code OK"
  elif [ "$http_code" = "307" ] || [ "$http_code" = "302" ] || [ "$http_code" = "301" ]; then
    log "- $name ($url): HTTP $http_code (redirect, likely auth gate)"
  elif [ "$http_code" = "TIMEOUT" ]; then
    found_bug "$name ($url): TIMEOUT — site may be down"
  else
    found_warning "$name ($url): HTTP $http_code"
  fi
}

check_url "astra-command-center" "https://astra-command-center-sigma.vercel.app"
check_url "saturno-bonus" "https://bonus.saturnomovement.com"
check_url "de-aqui-a-saturno" "https://de-aqui-a-saturno-jet.vercel.app"
check_url "titan-forge" "https://titan-forge-ten.vercel.app"

# Check API endpoints for ASTRA
subsection "ASTRA API Endpoint Health"
ASTRA_BASE="https://astra-command-center-sigma.vercel.app"
API_ENDPOINTS=("/api/health" "/api/repos" "/api/state" "/api/pipeline" "/api/capture" "/api/transcribe" "/api/transcripts" "/api/query")

for endpoint in "${API_ENDPOINTS[@]}"; do
  http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "${ASTRA_BASE}${endpoint}" 2>/dev/null || echo "TIMEOUT")
  if [ "$http_code" = "200" ]; then
    log "- ${endpoint}: HTTP $http_code OK"
  elif [ "$http_code" = "401" ]; then
    log "- ${endpoint}: HTTP 401 (auth required — expected)"
  elif [ "$http_code" = "405" ]; then
    log "- ${endpoint}: HTTP 405 (method not allowed — needs POST)"
  elif [ "$http_code" = "TIMEOUT" ]; then
    found_bug "${endpoint}: TIMEOUT"
  else
    found_warning "${endpoint}: HTTP $http_code (unexpected)"
  fi
done

# ============================================================
# PHASE 5: HTML/JS BUG PATTERNS
# ============================================================
section "PHASE 5: CODE BUG PATTERNS"

for repo in "$REPOS_DIR"/*/; do
  repo_name=$(basename "$repo")
  if [ -d "$repo/.git" ]; then
    subsection "$repo_name — Code Patterns"

    # Unclosed tags in HTML
    for htmlfile in $(find "$repo" -name "*.html" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null); do
      # Check for console.error left in production
      console_errors=$(grep -c "console\.error" "$htmlfile" 2>/dev/null || echo "0")
      if [ "$console_errors" -gt 5 ]; then
        found_warning "$htmlfile has $console_errors console.error calls"
      fi

      # Check for debugger statements
      debuggers=$(grep -c "debugger" "$htmlfile" 2>/dev/null || echo "0")
      if [ "$debuggers" -gt 0 ]; then
        found_bug "$htmlfile has $debuggers debugger statements left in code"
      fi
    done

    # Check JS files for common issues
    for jsfile in $(find "$repo" -name "*.js" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -name "package-lock.json" 2>/dev/null); do
      # eval() usage
      evals=$(grep -c "eval(" "$jsfile" 2>/dev/null || echo "0")
      if [ "$evals" -gt 0 ]; then
        found_warning "$jsfile uses eval() ($evals times)"
      fi

      # Catch blocks that swallow errors
      empty_catch=$(grep -c "catch.*{.*}" "$jsfile" 2>/dev/null || echo "0")
      if [ "$empty_catch" -gt 3 ]; then
        found_warning "$jsfile has $empty_catch potentially empty catch blocks"
      fi
    done
  fi
done

# ============================================================
# PHASE 6: PACKAGE AND DEPENDENCY AUDIT
# ============================================================
section "PHASE 6: DEPENDENCY AUDIT"

for repo in "$REPOS_DIR"/*/; do
  repo_name=$(basename "$repo")
  if [ -f "$repo/package.json" ]; then
    subsection "$repo_name"

    # Check for outdated deps
    if [ -f "$repo/node_modules/.package-lock.json" ] || [ -d "$repo/node_modules" ]; then
      cd "$repo"
      outdated=$(npm outdated --json 2>/dev/null | head -50 || echo "{}")
      if [ "$outdated" != "{}" ] && [ -n "$outdated" ]; then
        found_warning "$repo_name has outdated dependencies"
        echo '```json' >> "$REPORT"
        echo "$outdated" | head -30 >> "$REPORT"
        echo '```' >> "$REPORT"
      fi
      cd "$REPOS_DIR"
    else
      log "- $repo_name: node_modules not installed (skipping dep check)"
    fi

    # Check for missing .gitignore entries
    if [ -f "$repo/.gitignore" ]; then
      if ! grep -q "node_modules" "$repo/.gitignore" 2>/dev/null; then
        found_bug "$repo_name .gitignore missing node_modules"
      fi
      if ! grep -q ".env" "$repo/.gitignore" 2>/dev/null; then
        found_warning "$repo_name .gitignore missing .env"
      fi
    else
      found_warning "$repo_name has no .gitignore"
    fi
  fi
done

# ============================================================
# PHASE 7: CROSS-REFERENCE AUDIT
# ============================================================
section "PHASE 7: CROSS-REFERENCE AUDIT"

subsection "KB ID Duplicates in ASTRA"
if [ -f "$REPOS_DIR/astra-command-center/index.html" ]; then
  # Find all KB IDs
  kb_ids=$(grep -oE "id:'[a-z_]+'" "$REPOS_DIR/astra-command-center/index.html" 2>/dev/null | sort | uniq -d)
  if [ -n "$kb_ids" ]; then
    found_bug "Duplicate KB IDs found in ASTRA index.html:"
    echo '```' >> "$REPORT"
    echo "$kb_ids" >> "$REPORT"
    echo '```' >> "$REPORT"
  else
    log "- No duplicate KB IDs found"
  fi
fi

subsection "S.kb vs S.knowledgeBase References"
if [ -f "$REPOS_DIR/astra-command-center/index.html" ]; then
  skb_refs=$(grep -c "S\.kb\." "$REPOS_DIR/astra-command-center/index.html" 2>/dev/null || echo "0")
  skb_push=$(grep -c "S\.kb\.push" "$REPOS_DIR/astra-command-center/index.html" 2>/dev/null || echo "0")
  if [ "$skb_push" -gt 0 ]; then
    found_bug "S.kb.push still used $skb_push times (should be S.knowledgeBase.push)"
  fi
  if [ "$skb_refs" -gt 0 ]; then
    found_warning "S.kb. referenced $skb_refs times (check if these are in strings/comments or actual code)"
  fi
fi

subsection "Stale Omega URL References"
omega_count=$(grep -r "omega" "$REPOS_DIR" --include="*.html" --include="*.js" -l 2>/dev/null | grep -v node_modules | grep -v .git || true)
if [ -n "$omega_count" ]; then
  found_bug "Files still referencing 'omega' (stale URL?):"
  echo "$omega_count" | while read f; do echo "  - $f"; done >> "$REPORT"
fi

# ============================================================
# PHASE 8: DESKTOP HTML FILES AUDIT
# ============================================================
section "PHASE 8: DESKTOP AND LOOSE FILES"

subsection "Desktop HTML Files"
desktop_htmls=$(find "$HOME/Desktop" -name "*.html" -maxdepth 3 2>/dev/null | head -50)
if [ -n "$desktop_htmls" ]; then
  count=$(echo "$desktop_htmls" | wc -l | tr -d ' ')
  log "Found $count HTML files on Desktop:"
  echo '```' >> "$REPORT"
  echo "$desktop_htmls" >> "$REPORT"
  echo '```' >> "$REPORT"
else
  log "- No HTML files found on Desktop"
fi

subsection "Loose Repos on Desktop"
desktop_repos=$(find "$HOME/Desktop" -name ".git" -maxdepth 3 -type d 2>/dev/null)
if [ -n "$desktop_repos" ]; then
  found_warning "Git repos found on Desktop (should be in ~/dev/):"
  echo "$desktop_repos" | while read r; do echo "  - $(dirname "$r")"; done >> "$REPORT"
fi

# ============================================================
# PHASE 9: CHROME EXTENSION AUDIT
# ============================================================
section "PHASE 9: CHROME EXTENSIONS"

CHROME_DIR="$HOME/Library/Application Support/Google/Chrome"
if [ -d "$CHROME_DIR" ]; then
  profiles=$(find "$CHROME_DIR" -maxdepth 1 -type d \( -name "Default" -o -name "Profile*" \) 2>/dev/null)
  for profile in $profiles; do
    profile_name=$(basename "$profile")
    ext_dir="$profile/Extensions"
    if [ -d "$ext_dir" ]; then
      ext_count=$(find "$ext_dir" -maxdepth 1 -type d 2>/dev/null | wc -l)
      ext_count=$((ext_count - 1))
      subsection "Chrome $profile_name: $ext_count extensions"

      for ext in "$ext_dir"/*/; do
        ext_id=$(basename "$ext")
        manifest=$(find "$ext" -name "manifest.json" -maxdepth 2 2>/dev/null | head -1)
        if [ -n "$manifest" ]; then
          name=$(python3 -c "import json; print(json.load(open('$manifest')).get('name','Unknown'))" 2>/dev/null || echo "Unknown")
          log "- $name ($ext_id)"
        fi
      done
    fi
  done
else
  log "- Chrome directory not found"
fi

# ============================================================
# PHASE 10: VERCEL PROJECT CONFIG AUDIT
# ============================================================
section "PHASE 10: VERCEL PROJECT CONFIGS"

for repo in "$REPOS_DIR"/*/; do
  repo_name=$(basename "$repo")
  if [ -d "$repo/.vercel" ]; then
    subsection "$repo_name"
    if [ -f "$repo/.vercel/project.json" ]; then
      log "- Vercel project linked"
      cat "$repo/.vercel/project.json" >> "$REPORT"
      echo "" >> "$REPORT"
    fi
  fi

  # Check for vercel.json config
  if [ -f "$repo/vercel.json" ]; then
    log "- Has vercel.json config"
  fi
done

# ============================================================
# PHASE 11: LIVING DOCS AND KB FRESHNESS
# ============================================================
section "PHASE 11: CLAUDE.md AND CONFIG FRESHNESS"

for repo in "$REPOS_DIR"/*/; do
  repo_name=$(basename "$repo")
  if [ -f "$repo/CLAUDE.md" ]; then
    last_mod=$(stat -f "%Sm" -t "%Y-%m-%d" "$repo/CLAUDE.md" 2>/dev/null || echo "unknown")
    lines=$(wc -l < "$repo/CLAUDE.md" 2>/dev/null || echo "0")
    log "- $repo_name/CLAUDE.md: $lines lines, last modified $last_mod"

    # Check for stale dates
    has_stale_date=$(grep -c "202[0-4]" "$repo/CLAUDE.md" 2>/dev/null || echo "0")
    if [ "$has_stale_date" -gt 0 ]; then
      found_warning "$repo_name/CLAUDE.md may have stale dates (pre-2025 references)"
    fi
  else
    found_warning "$repo_name has no CLAUDE.md"
  fi
done

# ============================================================
# SUMMARY
# ============================================================
section "SUMMARY"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
ELAPSED_MIN=$((ELAPSED / 60))

log "- **Total Bugs Found:** $BUG_COUNT"
log "- **Total Warnings:** $WARN_COUNT"
log "- **Time Elapsed:** ${ELAPSED_MIN} minutes"
log "- **Repos Scanned:** $(ls -d "$REPOS_DIR"/*/.git 2>/dev/null | wc -l | tr -d ' ')"
log ""
log "Report saved to: $REPORT"

echo ""
echo "=========================================="
echo "BUG HUNT COMPLETE"
echo "Bugs: $BUG_COUNT | Warnings: $WARN_COUNT"
echo "Time: ${ELAPSED_MIN} minutes"
echo "Report: $REPORT"
echo "=========================================="
