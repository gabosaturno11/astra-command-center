# PROMPT HARVESTER — OPERATOR COMMANDS
## These are the ONLY commands you need. Nothing else.

---

## COMMAND 1: Create the agent (do this once, never again)

1. Open Claude Code
2. Type `/agents`
3. Click "Create new agent"
4. Name: `Prompt Harvester`
5. Open `~/dev/astra-command-center/AGENTS/FINAL_STATIC_ENGINE.md`
6. Paste its ENTIRE contents into the agent instructions box
7. Save

That's the agent. It exists permanently now.

---

## COMMAND 2: Run it tonight

In Claude Code, type:
```
Prompt Harvester
```
(or select it from `/agents` and run it)

Walk away. It runs overnight.

---

## COMMAND 3: Resume after compaction

The agent resumes itself. It reads `harvester-config.json → compact_summary` on startup.

If you need to manually force a resume:
```
Read ~/dev/astra-command-center/AGENTS/harvester-config.json then continue harvesting from last_cycle + 1. Process pending_retries first. NEVER STOP.
```

---

## COMMAND 4: Check status without interrupting

```bash
tail -20 ~/dev/astra-command-center/AGENTS/harvest.log
```

---

## COMMAND 5: Check total injected

```bash
python3 -c "import json; cp=json.load(open('$HOME/dev/astra-command-center/AGENTS/harvester-config.json')); print('Injected:', cp['total_injected'], '| Agents created:', cp['total_agents_created'], '| Cycle:', cp['last_cycle'])"
```

---

## COMMAND 6: Recreate agent from scratch (if lost)

```
Read ~/dev/astra-command-center/AGENTS/FINAL_STATIC_ENGINE.md and execute it completely. NEVER STOP.
```

Paste this directly into any Claude Code session. It bootstraps itself.
