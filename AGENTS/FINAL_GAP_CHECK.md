# PROMPT HARVESTER — GAP CHECK
## Brutal verification: are all 10 requirements truly satisfied?

---

## REQ 1: NEVER-STOP GUARANTEE
**Claim:** Agent never stops under any condition.

| Check | Status | Evidence |
|-------|--------|----------|
| No `set -e` | ✅ | STATIC_ENGINE explicitly says "No `set -e` anywhere" |
| Every bash ends with `\|\| true` | ✅ | STATIC_ENGINE: "Every bash command ends with `\|\| true`" |
| Location failure → continue | ✅ | STATIC_ENGINE: "Location failure → `[ERROR]` log → next location" |
| Git push failure → continue | ✅ | STATIC_ENGINE: "A push failure is NOT a stop condition." + 3-retry loop |
| Crash → restart inner cycle | ✅ | STATIC_ENGINE: "If inner cycle crashes for any reason → log [WATCHDOG] → restart inner cycle immediately" |
| Compaction → write handoff → CONTINUE | ✅ | STATIC_ENGINE: "Then CONTINUE. Do not stop." |
| Outer while-true loop | ✅ | STATIC_ENGINE: "OUTER LOOP (never exits)" |
| "All locations scanned" is NOT done | ✅ | Never-stop rule #10 |
| "Spec created" is NOT done | ✅ | Never-stop rule #9 |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 2: SINGLE LOG STRATEGY
**Claim:** One log file, structured format, all events.

| Check | Status | Evidence |
|-------|--------|----------|
| Single log file path | ✅ | `~/dev/astra-command-center/AGENTS/harvest.log` |
| Structured format defined | ✅ | `[YYYY-MM-DD HH:MM:SS] [LEVEL] [LOCATION_ID] [ACTION] message` |
| All 14 valid levels defined | ✅ | SCAN_START \| LOCATION_FOUND \| PROMPT_NORMALIZED \| DUPLICATE_SKIPPED \| AGENT_CREATED \| ASTRA_UPDATED \| COMMIT_PUSH \| COMPACT_READY \| INJECTED \| ERROR \| WATCHDOG \| CHECKPOINT \| CYCLE_START \| CYCLE_END |
| "No other log files" rule | ✅ | STATIC_ENGINE: "No other log files. All output goes here." |
| Log written via Python inject() | ✅ | `log()` helper in injection code used for all events |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 3: UNIFIED SCHEMA
**Claim:** One schema from extraction through injection. Never deviate.

| Check | Status | Evidence |
|-------|--------|----------|
| Schema defined once | ✅ | STATIC_ENGINE: "SCHEMA — ONE OBJECT EVERYWHERE" |
| All 11 fields present | ✅ | id, title, summary, body, category, tags, source, created, updated, usageCount, lastUsed |
| title max 50 chars | ✅ | Enforced in injection code: `p["title"][:50]` |
| summary max 120 chars | ✅ | Enforced in injection code: `p.get("summary","")[:120]` |
| body never truncated | ✅ | STATIC_ENGINE: "full prompt text, never truncated, JS-escaped" |
| 15 categories defined | ✅ | agents\|kernels\|content\|extraction\|synthesis\|architecture\|coaching\|movement\|research\|automation\|writing\|voice\|model_optimization\|scripts\|skills |
| Auto-category detection (15 rules, ordered) | ✅ | Priority list in STATIC_ENGINE |
| tags min 3 / max 8 | ✅ | Defined in schema |
| Default category fallback | ✅ | Rule 15: "Default → `content`" |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 4: INFINITE LOCATION DISCOVERY
**Claim:** Agent discovers new locations every cycle and grows its scan map permanently.

| Check | Status | Evidence |
|-------|--------|----------|
| 16 seed locations defined | ✅ | DYNAMIC_CONFIG: LOC_01 through LOC_16 |
| Discovery pass runs after every pass | ✅ | STATIC_ENGINE: "After every pass, run: grep -rl..." |
| Discovery covers 5 root dirs | ✅ | ~/Documents ~/Desktop ~/Downloads ~/dev ~/.claude |
| New dirs appended to config | ✅ | "If not → append it → log `[LOCATION_FOUND]`" |
| discovered_locations scanned each cycle | ✅ | STATIC_ENGINE step 4: "Scan all config.discovered_locations" |
| Discovery persists across sessions | ✅ | Written to harvester-config.json → discovered_locations |
| Extensions covered | ✅ | .md, .json, .txt |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 5: SMART DEDUPE + CHECKPOINT
**Claim:** Hash-based dedup, no reading existing ASTRA prompts, checkpoint per cycle.

| Check | Status | Evidence |
|-------|--------|----------|
| MD5 hash per body | ✅ | `hashlib.md5(p['body'].encode()).hexdigest()` |
| Hash file: one line per hash | ✅ | harvest-hashes.txt, O(1) lookup |
| Never reads all ASTRA prompts | ✅ | STATIC_ENGINE: "Never read all existing ASTRA prompts to check for dupes. Hash file only." |
| Duplicate → log + skip | ✅ | `log('SKIPPED', ..., 'DUPLICATE_SKIPPED', ...)` |
| New → inject → append hash | ✅ | Injection code appends to HASH_DB after writing |
| Cycle checkpoint written per cycle | ✅ | STATIC_ENGINE step 6: "Write cycle checkpoint to config" |
| last_cycle incremented | ✅ | DYNAMIC_CONFIG: "last_cycle → increment" |
| Resume from last_cycle + 1 | ✅ | STATIC_ENGINE: "resume from `last_cycle + 1`. Never restart from zero" |
| Pending retries processed first | ✅ | OPERATOR_COMMANDS: "Process pending_retries first" |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 6: AGENT-SHAPED PROMPT HANDLING
**Claim:** Detects agent specs, creates AGENTS/<NAME>.md, injects activation record in ASTRA.

| Check | Status | Evidence |
|-------|--------|----------|
| Detection patterns defined (3) | ✅ | ROLE+TASK+RULES\|NEVER STOP \| execute autonomously+loop \| explicit agent spec structure |
| Creates AGENTS/<NAME>.md | ✅ | STATIC_ENGINE: "Create `~/dev/astra-command-center/AGENTS/<AGENT_NAME>.md`" |
| Avoids re-creating existing agents | ✅ | "Check filenames only (`ls AGENTS/*.md`) — do NOT read file contents" |
| Injects activation record into ASTRA | ✅ | title, body, category=agents, tags=[agent, activation, one-shot], summary all defined |
| Activation command format | ✅ | `Read ~/dev/astra-command-center/AGENTS/<X>.md and execute it completely. NEVER STOP.` |
| Logs agent creation | ✅ | `[AGENT_CREATED] [<LOC>] Name=<X> \| File=AGENTS/<X>.md \| Command=...` |
| total_agents_created tracked | ✅ | DYNAMIC_CONFIG writes this back per cycle |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 7: UX + SYSTEM IMPROVEMENT CAPTURE
**Claim:** Agent captures improvement notes and evolves its own scan map.

| Check | Status | Evidence |
|-------|--------|----------|
| improvement_notes field in config | ✅ | DYNAMIC_CONFIG: `"improvement_notes": []` |
| Agent appends if new patterns found | ✅ | DYNAMIC_CONFIG: "improvement_notes → append if new patterns found" |
| schema_evolution field | ✅ | DYNAMIC_CONFIG: `"schema_evolution": []` |
| known_failures tracked | ✅ | DYNAMIC_CONFIG: `"known_failures": []` — appended per location error |
| Yield rate per location | ✅ | `yield_rate` per location, recalculated each cycle |
| Smart skip (not permanent) | ✅ | yield_rate < 0.1 for 3+ cycles → scan every 5th; dormant → every 10th; never permanent |
| consecutive_low counter | ✅ | Per location in config |
| discovered_categories | ✅ | `"discovered_categories": []` in config |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 8: COMMIT + PUSH RULE
**Claim:** Every 2 completed passes → git commit + push. Push failure is never a stop.

| Check | Status | Evidence |
|-------|--------|----------|
| Trigger: every 2 passes | ✅ | STATIC_ENGINE: "Every 2 completed passes (a pass = all active locations scanned once)" |
| Stages index.html + AGENTS/ | ✅ | `git add index.html AGENTS/` |
| Commit message format | ✅ | `feat(harvest): cycle $CYCLE $(date '+%Y-%m-%d %H:%M')` |
| 3 push retries | ✅ | `for i in 1 2 3; do git push origin main && break \|\| sleep 3; done` |
| Push failure → continue | ✅ | "A push failure is NOT a stop condition." |
| last_commit written to config | ✅ | DYNAMIC_CONFIG: "last_commit → git hash after push" |
| COMMIT_PUSH log entry | ✅ | `[COMMIT_PUSH] cycle=$CYCLE` |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 9: COMPACT HANDOFF
**Claim:** Before context limit, writes handoff to config. Next session resumes cleanly.

| Check | Status | Evidence |
|-------|--------|----------|
| Compact signal watched | ✅ | STATIC_ENGINE: "watch for warning signals or after every 10 cycles proactively" |
| compact_summary written to config | ✅ | Written to harvester-config.json → compact_summary |
| All 8 fields in compact_summary | ✅ | compact_at_cycle, last_commit, locations_completed, locations_pending, discovered_not_yet_scanned, pending_retries, total_injected_this_session, resume_instruction |
| resume_instruction is self-contained | ✅ | "Start from cycle <N+1>. Read harvester-config.json. Resume pending locations first." |
| Agent continues after writing handoff | ✅ | STATIC_ENGINE: "Then CONTINUE. Do not stop." |
| Next session reads compact_summary | ✅ | STATIC_ENGINE startup: "resume from `compact_summary.resume_instruction`" |
| COMPACT_READY log entry | ✅ | `[COMPACT_READY] cycle=<N> resume_from=<N+1>` |
| Manual resume command documented | ✅ | OPERATOR_COMMANDS command 3 |

**VERDICT: ✅ FULLY SATISFIED**

---

## REQ 10: TOKEN SAVING (STATIC / DYNAMIC SPLIT)
**Claim:** Static engine in agent box (never reread). Dynamic config is a lightweight JSON (read once per cycle).

| Check | Status | Evidence |
|-------|--------|----------|
| Static engine never contains mutable state | ✅ | STATIC_ENGINE has zero cycle counters, zero location history |
| Dynamic config never contains loop logic | ✅ | DYNAMIC_CONFIG: "WHAT NEVER GOES IN THIS FILE: Loop logic, Schema definition, Injection code, Rules, Static instructions" |
| Config read ONCE per cycle | ✅ | STATIC_ENGINE loop step 1: "Read harvester-config.json (mutable state only)" |
| Agent spec never reread after startup | ✅ | FINAL_ASTRA_RECORD rule: "NEVER read static engine spec every cycle" |
| Config is pure JSON (fast load) | ✅ | 16 location objects + metrics + arrays — no embedded code |
| Separation enforced by distinct files | ✅ | FINAL_STATIC_ENGINE.md (agent box) vs harvester-config.json (disk) |

**VERDICT: ✅ FULLY SATISFIED**

---

## FINAL SCORECARD

| Req | Description | Status |
|-----|-------------|--------|
| 1 | Never-stop guarantee | ✅ |
| 2 | Single log strategy | ✅ |
| 3 | Unified schema | ✅ |
| 4 | Infinite location discovery | ✅ |
| 5 | Smart dedupe + checkpoint | ✅ |
| 6 | Agent-shaped prompt handling | ✅ |
| 7 | UX + system improvement capture | ✅ |
| 8 | Commit/push rule | ✅ |
| 9 | Compact handoff | ✅ |
| 10 | Token saving (static/dynamic split) | ✅ |

**10/10. Zero gaps. Ship it.**

---

## ONE REMAINING MANUAL STEP

Gabo must paste `FINAL_STATIC_ENGINE.md` contents into the Claude Code agent box manually.
No file can do this for him. It is the only step that requires human hands.

Everything else runs without supervision.
