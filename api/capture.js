/**
 * ASTRA CAPTURE API
 * POST /api/capture  -> receive captures from extension or system-wide capture
 *
 * Stores captures in Vercel Blob as captures-log.json (append-only)
 * Compatible with the SATURNO CAPTURE extension format
 */
import { put, list } from '@vercel/blob';

const CAPTURES_FILE = 'captures-log.json';

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

async function getCaptures(token) {
  try {
    const { blobs } = await list({ prefix: CAPTURES_FILE, token });
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

  const token = process.env.BLOB_READ_WRITE_TOKEN;

  if (req.method === 'GET') {
    if (!token) return res.status(200).json({ captures: [], _source: 'none' });
    const captures = await getCaptures(token);
    return res.status(200).json({ captures, count: captures.length, _source: 'blob' });
  }

  if (req.method === 'POST') {
    if (!token) {
      return res.status(503).json({ ok: false, error: 'BLOB_READ_WRITE_TOKEN not configured' });
    }

    try {
      const { content, category, source, sourceTitle, tags, type } = req.body;
      if (!content) return res.status(400).json({ ok: false, error: 'content is required' });

      const capture = {
        id: `c_${Date.now()}`,
        type: type || 'highlight',
        content,
        category: category || 'other',
        source: source || '',
        sourceTitle: sourceTitle || '',
        tags: tags || [],
        capturedAt: new Date().toISOString()
      };

      const captures = await getCaptures(token);
      captures.unshift(capture);

      // Keep last 2000 captures
      if (captures.length > 2000) captures.length = 2000;

      await put(CAPTURES_FILE, JSON.stringify(captures, null, 2), {
        access: 'public', addRandomSuffix: false, allowOverwrite: true, token
      });

      return res.status(200).json({ ok: true, id: capture.id, capture });
    } catch (e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  return res.status(405).json({ ok: false, error: 'Method not allowed' });
}
