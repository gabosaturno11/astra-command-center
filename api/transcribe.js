/**
 * ASTRA TRANSCRIBE API
 * POST /api/transcribe -> receive audio blob, transcribe via OpenAI Whisper
 * Accepts: multipart/form-data with 'audio' file field
 * Returns: { ok: true, text, duration }
 * Requires: OPENAI_API_KEY env var
 */
import { put, list } from '@vercel/blob';

const INDEX_FILE = 'transcripts-index.json';
const ADMIN_PASSWORD = process.env.ASTRA_ADMIN_PASSWORD;

function checkAuth(req) {
  if (!ADMIN_PASSWORD) return false;
  // Accept Bearer token (Chrome extension, external calls)
  const auth = req.headers.authorization;
  if (auth && auth === `Bearer ${ADMIN_PASSWORD}`) return true;
  // Accept cookie (requests from ASTRA dashboard after login)
  const cookieHeader = req.headers.cookie || '';
  const cookieMatch = cookieHeader.match(/(?:^|; )astra_auth=([^;]*)/);
  const cookieToken = cookieMatch ? decodeURIComponent(cookieMatch[1]) : null;
  const authToken = process.env.ASTRA_AUTH_TOKEN || 'astra-fallback-token';
  if (cookieToken === authToken) return true;
  return false;
}

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

export const config = { api: { bodyParser: false } };

async function parseMultipart(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on('data', chunk => chunks.push(chunk));
    req.on('end', () => resolve(Buffer.concat(chunks)));
    req.on('error', reject);
  });
}

function extractFileFromBody(buffer, contentType) {
  const boundary = contentType.split('boundary=')[1];
  if (!boundary) return null;
  const body = buffer.toString('binary');
  const parts = body.split('--' + boundary);
  for (const part of parts) {
    if (part.includes('name="audio"') || part.includes('name="file"')) {
      const headerEnd = part.indexOf('\r\n\r\n');
      if (headerEnd === -1) continue;
      const headers = part.substring(0, headerEnd);
      const content = part.substring(headerEnd + 4).replace(/\r\n$/, '');
      const filenameMatch = headers.match(/filename="([^"]+)"/);
      const ctMatch = headers.match(/Content-Type:\s*(.+)/i);
      return {
        data: Buffer.from(content, 'binary'),
        filename: filenameMatch ? filenameMatch[1] : 'audio.webm',
        contentType: ctMatch ? ctMatch[1].trim() : 'audio/webm',
      };
    }
  }
  return null;
}

async function getIndex(token) {
  try {
    const { blobs } = await list({ prefix: INDEX_FILE, token });
    if (blobs.length === 0) return [];
    const response = await fetch(blobs[0].url);
    if (!response.ok) return [];
    return await response.json();
  } catch (e) { return []; }
}

export default async function handler(req, res) {
  cors(res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ ok: false, error: 'POST only' });
  if (!checkAuth(req)) return res.status(401).json({ ok: false, error: 'Unauthorized' });

  const openaiKey = process.env.OPENAI_API_KEY;
  if (!openaiKey) return res.status(503).json({ ok: false, error: 'OPENAI_API_KEY not configured' });

  try {
    const buffer = await parseMultipart(req);
    const contentType = req.headers['content-type'] || '';
    const file = extractFileFromBody(buffer, contentType);
    if (!file || file.data.length === 0) return res.status(400).json({ ok: false, error: 'No audio file received' });

    const prompt = 'Calisthenics, handstand, planche, front lever, muscle up, Gabo Saturno, Saturno Movement, handbalancing, biomechanics';
    const formData = new FormData();
    const audioBlob = new Blob([file.data], { type: file.contentType });
    formData.append('file', audioBlob, file.filename);
    formData.append('model', 'whisper-1');
    formData.append('language', 'en');
    formData.append('prompt', prompt);
    formData.append('response_format', 'verbose_json');

    const whisperRes = await fetch('https://api.openai.com/v1/audio/transcriptions', {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${openaiKey}` },
      body: formData,
    });

    if (!whisperRes.ok) {
      const err = await whisperRes.text();
      return res.status(502).json({ ok: false, error: `Whisper API error: ${whisperRes.status}`, details: err });
    }

    const result = await whisperRes.json();
    const text = result.text || '';
    const duration = result.duration || null;

    const blobToken = process.env.BLOB_READ_WRITE_TOKEN;
    let transcriptId = null;

    if (blobToken && text) {
      try {
        transcriptId = `t_${Date.now()}`;
        const transcript = { id: transcriptId, text, source: 'whisper-api-browser', duration, language: 'en', tags: ['whisper', 'browser-recording'], createdAt: new Date().toISOString() };
        await put(`transcripts/${transcriptId}.json`, JSON.stringify(transcript, null, 2), { access: 'public', addRandomSuffix: false, token: blobToken });
        const index = await getIndex(blobToken);
        index.unshift({ id: transcriptId, source: 'whisper-api-browser', preview: text.substring(0, 120), createdAt: transcript.createdAt, tags: transcript.tags });
        if (index.length > 500) index.length = 500;
        await put(INDEX_FILE, JSON.stringify(index, null, 2), { access: 'public', addRandomSuffix: false, token: blobToken });
      } catch (e) { /* Don't fail if logging fails */ }
    }

    return res.status(200).json({ ok: true, text, duration, transcriptId });
  } catch (e) {
    return res.status(500).json({ ok: false, error: e.message });
  }
}
