# Prompt Library

This library organizes reusable prompts by domain for consistent, production-ready outputs.

- Command format: kebab-case (e.g., `extract-movements`).
- Metadata: each prompt includes `command`, `category`, `tags`, and `complexity`.
- Usage: open a prompt `.md`, paste it into your tool, then inject your content under the INPUT section.

Testing workflow
- Try each prompt with sample content from your attachments.
- Evaluate output for fidelity, correctness, and structure.
- Iterate the prompt text (or add variants) when results drift.

Advanced features
- Prompt chaining: run `extract-movements` → feed results to `synthesize-philosophy`.
- Variable injection: replace placeholders like `{{domain}}` before execution.
- Output templates: prefer Markdown or JSON blocks for downstream tooling.
- Usage analytics: track effectiveness manually via PRs/issues or add a script later.

Directory layout
- `content-creation/` — meta and refinement prompts
- `fitness-movement/` — movement extraction and structuring
- `productivity/` — PARA and workflow prompts
- `philosophy-training/` — principles and methodological synthesis
- `development/` — code generation prompts

