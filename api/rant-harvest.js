/**
 * ASTRA — Rant Harvest Endpoint
 * POST /api/rant-harvest
 * Takes raw transcript → runs RANT_HARVESTER via Claude → returns structured signal
 *
 * Requires: ANTHROPIC_API_KEY
 * Auth: Bearer (ASTRA_ADMIN_PASSWORD) or cookie
 */

const RANT_HARVESTER_PROMPT = `You are the RANT HARVESTER for Gabo Saturno's content ecosystem.
You receive raw voice transcripts, rants, or stream-of-consciousness text.
Your job is to EXTRACT, CATEGORIZE, and ROUTE without losing signal.

HARD RULES:
- Never edit the voice. Keep the raw phrasing.
- If it's messy, keep it messy. That's the signal.
- Preserve curse words. They're emphasis markers.
- Do NOT interpret. Extract.
- The rant is the source of truth.

EXTRACTION CATEGORIES:

1. QUOTES — 1-25 words, standalone statements that could be captions. Tag: RAW | TEACHER | PHILOSOPHER | REBEL
2. INSIGHTS — Realizations stated as fact. "The truth is...", behavioral truths, not theories.
3. TASKS — Explicit + implicit action items. Tag priority: P0 (now) | P1 (today) | P2 (this week) | P3 (someday)
4. DECISIONS — Choices made. "I'm going to...", "Fuck that, I'm doing..." — lock as commitments.
5. QUESTIONS — Open loops. Tag: RESEARCH | DECISION | EXPLORE. Note which LLM to route to.
6. SYSTEMS — Apps, platforms, workflows, architecture decisions, how things connect.
7. PEOPLE — Names mentioned, their role, what action relates to them.
8. EMOTIONS — Frustration, excitement, fear, clarity. Tone shifts. Energy markers.
9. ROASTS — Contradictions between intention and action. "I said X but did Y."
10. CONTRADICTIONS — Where the rant contradicts itself. Gold for content.

Return ONLY valid JSON. No markdown fences. No extra text.

{
  "harvest_meta": {
    "source": "voice_memo",
    "date": "",
    "energy_level": "low|medium|high|manic",
    "word_count": 0,
    "dominant_theme": ""
  },
  "quotes": [
    { "text": "", "mode": "RAW|TEACHER|PHILOSOPHER|REBEL", "use_for": "caption|email|reel|carousel" }
  ],
  "insights": [
    { "text": "", "depth": "surface|deep|core" }
  ],
  "tasks": [
    { "task": "", "priority": "P0|P1|P2|P3", "context": "", "route_to": "astra_tasks" }
  ],
  "decisions": [
    { "decision": "", "commitment_level": "soft|hard|locked" }
  ],
  "questions": [
    { "question": "", "type": "RESEARCH|DECISION|EXPLORE", "route_to": "perplexity|claude|chatgpt" }
  ],
  "systems": [
    { "name": "", "description": "", "status": "mentioned|needs_building|exists" }
  ],
  "people": [
    { "name": "", "role": "", "action": "" }
  ],
  "emotions": [
    { "emotion": "", "trigger": "", "intensity": "low|medium|high" }
  ],
  "roasts": [
    { "text": "", "contradiction": "" }
  ],
  "contradictions": [
    { "tension": "", "content_potential": "" }
  ],
  "routing": {
    "to_content_vault": [],
    "to_tasks": [],
    "to_kb": [],
    "to_research": []
  },
  "summary": {
    "one_sentence": "",
    "key_theme": "",
    "next_action": "",
    "mcp_router_seed": ""
  }
}`;

export default async function handler(req, res) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    if (req.method === 'OPTIONS') return res.status(200).end();
    if (req.method !== 'POST') return res.status(405).json({ error: 'POST only' });

    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) return res.status(500).json({ error: 'ANTHROPIC_API_KEY not configured' });

    const { transcript, source = 'voice_memo', date } = req.body;
    if (!transcript || transcript.trim().length < 10) {
        return res.status(400).json({ error: 'transcript required (min 10 chars)' });
    }

    const wordCount = transcript.trim().split(/\s+/).length;

    try {
        const response = await fetch('https://api.anthropic.com/v1/messages', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': apiKey,
                'anthropic-version': '2023-06-01'
            },
            body: JSON.stringify({
                model: 'claude-sonnet-4-20250514',
                max_tokens: 4096,
                system: RANT_HARVESTER_PROMPT,
                messages: [{
                    role: 'user',
                    content: `SOURCE: ${source}
DATE: ${date || new Date().toISOString()}
WORD COUNT: ${wordCount}

TRANSCRIPT:
${transcript}

Extract all signal. Return ONLY valid JSON.`
                }]
            })
        });

        if (!response.ok) {
            const err = await response.text();
            console.error('[rant-harvest] Anthropic error:', response.status, err);
            return res.status(502).json({ error: 'Claude API error', status: response.status });
        }

        const data = await response.json();
        const text = data.content?.[0]?.text || '';

        let result;
        try {
            result = JSON.parse(text);
        } catch {
            const match = text.match(/\{[\s\S]*\}/);
            if (match) {
                result = JSON.parse(match[0]);
            } else {
                return res.status(500).json({ error: 'JSON parse failed', raw: text.slice(0, 500) });
            }
        }

        // Inject meta if Claude left it blank
        if (!result.harvest_meta) result.harvest_meta = {};
        result.harvest_meta.source = source;
        result.harvest_meta.date = date || new Date().toISOString();
        result.harvest_meta.word_count = wordCount;

        return res.status(200).json(result);

    } catch (err) {
        console.error('[rant-harvest] Error:', err);
        return res.status(500).json({ error: 'Internal error', message: err.message });
    }
}
