# Voice → PDF Architecture
## March 12, 2026 — Session with Claude (Epistemology Brain)

---

## THE DOMINO: Voice Input

Gabo's entire creative process is verbal. Every product came from a rant.
The bottleneck: voice output evaporates. This architecture captures it.

---

## TWO PARALLEL FLOWS FROM ONE AUDIO

```
Gabo sends WhatsApp voice memo (to client or himself)
                    |
                    v
    Client OS /api/whatsapp.js webhook
    (289 lines, already built — just needs env vars)
                    |
                    v
    Whisper transcription (OpenAI gpt-4o-mini-transcribe)
                    |
          ┌─────────┴─────────┐
          |                   |
          v                   v
   FLOW 1: CLIENT         FLOW 2: COMMUNITY
   (private)              (public)
          |                   |
          v                   v
   P3 Diagnostic         Content Beast Brain
   P4 Cue Engine         (/api/claude-brain)
   P8 Closer             target: email
   (via Claude)          aperture: section
          |                   |
          v                   v
   Supabase               cos_content_queue
   cos_sessions           (Supabase table)
   ai_summaries field          |
          |                   v
          v            Downloads folder (Phase 1)
   Client OS PDF         → ManyChat (Phase 2)
   export                → Instagram captions
          |
          v
   Client portal
   (end of day: PDF ready)
   (end of month: full portfolio)
```

---

## ALSO RUNNING (async, non-blocking)

```
Same audio → ASTRA /api/ingest-ai-response
(if ASTRA_API_URL + ASTRA_ADMIN_PASSWORD set)
→ lands in ASTRA AI Inbox (14th sidebar section)
→ full ecosystem visibility
```

---

## ENV VARS NEEDED (Client OS Vercel)

| Var | Source | Status |
|-----|--------|--------|
| WHATSAPP_ACCESS_TOKEN | Meta Business Manager → WhatsApp → API Setup | PENDING |
| WHATSAPP_VERIFY_TOKEN | Make up any string (use: saturno2025) | PENDING |
| WHATSAPP_PHONE_NUMBER_ID | Meta → Getting Started panel → "From" section | PENDING |
| OPENAI_API_KEY | OpenAI | PENDING |
| ANTHROPIC_API_KEY | Anthropic Console | PENDING |
| SUPABASE_URL | Already set from March 7 | DONE |
| SUPABASE_SERVICE_KEY | Already set from March 7 | DONE |

Optional (for ASTRA forwarding):
- ASTRA_API_URL = https://astra-command-center-sigma.vercel.app
- ASTRA_ADMIN_PASSWORD = (same as ASTRA admin password)

---

## SUPABASE TABLE NEEDED

`cos_content_queue` — stores Content Beast Brain outputs for community content

```sql
create table cos_content_queue (
  id text primary key,
  session_id text,
  source_client text,
  summary text,
  content_html text,
  captions jsonb default '[]',
  next_question text,
  channel text default 'email',
  status text default 'ready',
  created_at timestamptz default now()
);
```

---

## META WEBHOOK SETUP (in Meta Business Manager)

After env vars are set in Vercel:
1. Meta Business Manager → WhatsApp → Configuration → Webhook
2. Callback URL: `https://client-os-omega.vercel.app/api/whatsapp`
3. Verify token: `saturno2025` (or whatever you set as WHATSAPP_VERIFY_TOKEN)
4. Subscribe to: `messages`
5. Click Verify — if env vars are correct, it will pass instantly

---

## THE VISION (Gabo's words, March 12)

> "Imagine being a client and just like your website is building as you're getting coached. That's fucking dope."

> "If I can just fucking speak and that turns into a PDF for a client... I just go for a walk, I answer to my clients, and by the end of the day he literally has a PDF waiting."

> "By the end of the month, he has a complete portfolio. That's how I can charge. Instead of 3k, I could charge 20k a month."

---

## NEXT: HIGHLIGHT → ASTRA (Computer Flow)

Nexus Capture already sends highlights to ASTRA /api/capture.
Missing: routing layer inside ASTRA that classifies and sends to:
- Prompt Vault (if it's a prompt/technique)
- Links section (if it's a URL)
- Content Vault (if it's an idea/caption)
- AI Inbox (everything, as fallback)

This uses the same epistemology classification that powers Content Beast Brain.
(claim | story | protocol | pattern | belief | question | feeling | command)
