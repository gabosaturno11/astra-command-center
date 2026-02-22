/**
 * ASTRA PIPELINE API
 * POST /api/pipeline
 *
 * The Saturno Pipeline: audio/text + custom prompt -> Whisper transcription -> AI synthesis -> stored result
 *
 * Accepts:
 *   - multipart/form-data with 'audio' file + 'prompt' field + optional 'source' + 'engine' field
 *   - OR application/json with { text, prompt, source, engine }
 *
 * Engine options:
 *   - "openai" (default): GPT-4o-mini via OpenAI API
 *   - "claude": Claude Sonnet via Anthropic API
 *   - "auto": tries Claude first (better quality), falls back to OpenAI
 *
 * Flow:
 *   1. If audio: transcribe via Whisper (always OpenAI)
 *   2. Run transcript (or text) through selected AI engine with user's custom prompt
 *   3. Store everything in ASTRA backend (Vercel Blob)
 *   4. Return { ok, transcript, synthesis, pipelineId, engine }
 *
 * Requires: OPENAI_API_KEY and/or ANTHROPIC_API_KEY env var
 * Optional: BLOB_READ_WRITE_TOKEN for persistent storage
 */
import { put, list } from '@vercel/blob';

const PIPELINE_INDEX = 'pipeline-index.json';
const ADMIN_PASSWORD = process.env.ASTRA_ADMIN_PASSWORD;

function checkAuth(req, res) {
  if (!ADMIN_PASSWORD) { res.status(503).json({ ok: false, error: 'ASTRA_ADMIN_PASSWORD not configured' }); return false; }
  const auth = req.headers.authorization;
  if (!auth || auth !== `Bearer ${ADMIN_PASSWORD}`) { res.status(401).json({ ok: false, error: 'Unauthorized' }); return false; }
  return true;
}

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

export const config = {
  api: { bodyParser: false },
};

async function parseBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on('data', chunk => chunks.push(chunk));
    req.on('end', () => resolve(Buffer.concat(chunks)));
    req.on('error', reject);
  });
}

function extractMultipartFields(buffer, contentType) {
  const boundary = contentType.split('boundary=')[1];
  if (!boundary) return null;

  const body = buffer.toString('binary');
  const parts = body.split('--' + boundary);
  const fields = {};

  for (const part of parts) {
    if (part === '' || part === '--\r\n' || part === '--') continue;
    const headerEnd = part.indexOf('\r\n\r\n');
    if (headerEnd === -1) continue;

    const headers = part.substring(0, headerEnd);
    const content = part.substring(headerEnd + 4).replace(/\r\n$/, '');

    const nameMatch = headers.match(/name="([^"]+)"/);
    if (!nameMatch) continue;
    const name = nameMatch[1];

    if (name === 'audio' || name === 'file') {
      const filenameMatch = headers.match(/filename="([^"]+)"/);
      const ctMatch = headers.match(/Content-Type:\s*(.+)/i);
      fields._audio = {
        data: Buffer.from(content, 'binary'),
        filename: filenameMatch ? filenameMatch[1] : 'audio.webm',
        contentType: ctMatch ? ctMatch[1].trim() : 'audio/webm',
      };
    } else {
      fields[name] = content;
    }
  }
  return fields;
}

async function transcribeAudio(audioFile, openaiKey) {
  const formData = new FormData();
  const audioBlob = new Blob([audioFile.data], { type: audioFile.contentType });
  formData.append('file', audioBlob, audioFile.filename);
  formData.append('model', 'whisper-1');
  formData.append('language', 'en');
  formData.append('response_format', 'verbose_json');

  const res = await fetch('https://api.openai.com/v1/audio/transcriptions', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${openaiKey}` },
    body: formData,
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Whisper error ${res.status}: ${err}`);
  }

  const result = await res.json();
  return { text: result.text || '', duration: result.duration || null };
}

const SYSTEM_PROMPT = `You are ASTRA, Gabo Saturno's AI pipeline processor. You receive transcribed audio or text input along with a custom prompt. Process the input according to the prompt and return a clean, structured result. Be precise, actionable, and match Gabo's style — no fluff, no emojis, direct output.`;

async function synthesizeOpenAI(transcript, prompt, openaiKey) {
  const userMessage = `## Input\n${transcript}\n\n## Prompt\n${prompt}`;

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${openaiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: SYSTEM_PROMPT },
        { role: 'user', content: userMessage },
      ],
      temperature: 0.7,
      max_tokens: 4096,
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`GPT error ${res.status}: ${err}`);
  }

  const result = await res.json();
  return result.choices[0]?.message?.content || '';
}

async function synthesizeClaude(transcript, prompt, anthropicKey) {
  const userMessage = `## Input\n${transcript}\n\n## Prompt\n${prompt}`;

  const res = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': anthropicKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 4096,
      system: SYSTEM_PROMPT,
      messages: [
        { role: 'user', content: userMessage },
      ],
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Claude error ${res.status}: ${err}`);
  }

  const result = await res.json();
  return result.content?.[0]?.text || '';
}

async function synthesize(transcript, prompt, engine) {
  const openaiKey = process.env.OPENAI_API_KEY;
  const anthropicKey = process.env.ANTHROPIC_API_KEY;

  if (engine === 'claude') {
    if (!anthropicKey) throw new Error('ANTHROPIC_API_KEY not configured');
    return { text: await synthesizeClaude(transcript, prompt, anthropicKey), engine: 'claude' };
  }

  if (engine === 'openai') {
    if (!openaiKey) throw new Error('OPENAI_API_KEY not configured');
    return { text: await synthesizeOpenAI(transcript, prompt, openaiKey), engine: 'openai' };
  }

  // auto: try Claude first, fall back to OpenAI
  if (anthropicKey) {
    try {
      return { text: await synthesizeClaude(transcript, prompt, anthropicKey), engine: 'claude' };
    } catch (e) {
      if (openaiKey) {
        return { text: await synthesizeOpenAI(transcript, prompt, openaiKey), engine: 'openai' };
      }
      throw e;
    }
  }

  if (openaiKey) {
    return { text: await synthesizeOpenAI(transcript, prompt, openaiKey), engine: 'openai' };
  }

  throw new Error('No AI API key configured. Set ANTHROPIC_API_KEY and/or OPENAI_API_KEY in Vercel env vars.');
}

async function getPipelineIndex(token) {
  try {
    const { blobs } = await list({ prefix: PIPELINE_INDEX, token });
    if (blobs.length === 0) return [];
    const response = await fetch(blobs[0].url);
    if (!response.ok) return [];
    return await response.json();
  } catch (e) {
    return [];
  }
}

export default async function handler(req, res) {
  cors(res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (!checkAuth(req, res)) return;

  const openaiKey = process.env.OPENAI_API_KEY;
  const anthropicKey = process.env.ANTHROPIC_API_KEY;

  if (!openaiKey && !anthropicKey) {
    return res.status(503).json({
      ok: false,
      error: 'No AI API keys configured. Set OPENAI_API_KEY and/or ANTHROPIC_API_KEY in Vercel Dashboard > Settings > Environment Variables.'
    });
  }

  // GET: retrieve pipeline history + available engines
  if (req.method === 'GET') {
    const token = process.env.BLOB_READ_WRITE_TOKEN;
    const engines = [];
    if (anthropicKey) engines.push('claude');
    if (openaiKey) engines.push('openai');
    if (engines.length > 1) engines.unshift('auto');

    if (!token) return res.status(200).json({ results: [], engines, whisper: !!openaiKey, _source: 'none' });
    const index = await getPipelineIndex(token);
    return res.status(200).json({ ok: true, results: index, count: index.length, engines, whisper: !!openaiKey });
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ ok: false, error: 'GET or POST only' });
  }

  try {
    let transcript = '';
    let prompt = '';
    let source = 'unknown';
    let engine = 'auto';
    let duration = null;
    let inputType = 'text';

    const contentType = req.headers['content-type'] || '';

    if (contentType.includes('multipart/form-data')) {
      const buffer = await parseBody(req);
      const fields = extractMultipartFields(buffer, contentType);

      if (!fields) {
        return res.status(400).json({ ok: false, error: 'Invalid multipart data' });
      }

      prompt = fields.prompt || 'Transcribe and summarize this audio';
      source = fields.source || 'pipeline-upload';
      engine = fields.engine || 'auto';

      if (fields._audio && fields._audio.data.length > 0) {
        inputType = 'audio';
        if (!openaiKey) {
          return res.status(503).json({ ok: false, error: 'Audio transcription requires OPENAI_API_KEY (Whisper)' });
        }
        const whisperResult = await transcribeAudio(fields._audio, openaiKey);
        transcript = whisperResult.text;
        duration = whisperResult.duration;
      } else if (fields.text) {
        transcript = fields.text;
      } else {
        return res.status(400).json({ ok: false, error: 'No audio file or text provided' });
      }
    } else {
      const buffer = await parseBody(req);
      const body = JSON.parse(buffer.toString());
      transcript = body.text || '';
      prompt = body.prompt || 'Summarize this text';
      source = body.source || 'pipeline-text';
      engine = body.engine || 'auto';

      if (!transcript) {
        return res.status(400).json({ ok: false, error: 'text is required' });
      }
    }

    // Run synthesis with selected engine
    const result = await synthesize(transcript, prompt, engine);

    // Store in ASTRA backend
    const blobToken = process.env.BLOB_READ_WRITE_TOKEN;
    let pipelineId = `p_${Date.now()}`;

    if (blobToken) {
      try {
        const entry = {
          id: pipelineId,
          inputType,
          transcript,
          prompt,
          synthesis: result.text,
          engine: result.engine,
          source,
          duration,
          createdAt: new Date().toISOString(),
        };

        await put(`pipeline/${pipelineId}.json`, JSON.stringify(entry, null, 2), {
          access: 'public', addRandomSuffix: false, token: blobToken,
        });

        const index = await getPipelineIndex(blobToken);
        index.unshift({
          id: pipelineId,
          inputType,
          prompt: prompt.substring(0, 100),
          preview: result.text.substring(0, 200),
          engine: result.engine,
          source,
          createdAt: entry.createdAt,
        });
        if (index.length > 500) index.length = 500;

        await put(PIPELINE_INDEX, JSON.stringify(index, null, 2), {
          access: 'public', addRandomSuffix: false, token: blobToken,
        });
      } catch (e) {
        // Don't fail if storage fails
      }
    }

    return res.status(200).json({
      ok: true,
      pipelineId,
      inputType,
      transcript,
      synthesis: result.text,
      engine: result.engine,
      duration,
      source,
    });
  } catch (e) {
    return res.status(500).json({ ok: false, error: e.message });
  }
}
