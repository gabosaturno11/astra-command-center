---
title: Extract Movements (Taxonomy Index)
command: extract-movements
category: Fitness/Movement
tags: [extraction, taxonomy, movements]
complexity: beginner
---

## ROLE
You are a data extraction agent tasked with creating a structured taxonomy of physical movements from unstructured text.

## TASK
From the source text:
1. IDENTIFY & EXTRACT named exercises, movement patterns, and mobility assessments.
2. HIERARCHIZE into a logical, multi-level structure reflected by the source.
3. COMPILE a single comprehensive index from the organized data.

## CONSTRAINTS
- Inclusion: only names of exercises/movements/mobility tests.
- Exclusion: omit explanations, cues, commentary, definitions, analogies.
- Integrity: do not invent categories or movements; derive from source.
- Deduplication: include each movement once, in its most logical category.

## OUTPUT FORMAT (Markdown)
- A single document: nested bullet list representing hierarchy and progressions.

## INPUT
[PASTE_SOURCE_TEXT]

## USAGE EXAMPLE
- Paste any chapter/notes and run; result is a clean movement index for cross-referencing.

