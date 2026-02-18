/**
 * ASTRA TRANSCRIPTS API
 * GET  /api/transcripts         -> list all transcripts
 * POST /api/transcripts         -> add a new transcript
 *
 * Storage: Vercel Blob (BLOB_READ_WRITE_TOKEN env var)
 * Each transcript stored as individual blob: transcripts/{id}.json
 * Index stored as: transcripts-index.json
 */
import { put, list } from '@vercel/blob';

const INDEX_FILE = 'transcripts-index.json';
const ADMIN_PASSWORD = process.env.ASTRA_ADMIN_PASSWORD || 'saturno-admin-2026';

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

async function getIndex(token) {
  try {
    const { blobs } = await list({ prefix: INDEX_FILE, token });
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
    if (!token) return res.status(200).json({ transcripts: [], _source: 'none' });

    const index = await getIndex(token);
    return res.status(200).json({ transcripts: index, _source: 'blob' });
  }

  if (req.method === 'POST') {
    const auth = req.headers.authorization;
    if (!auth || auth !== `Bearer ${ADMIN_PASSWORD}`) {
      return res.status(401).json({ ok: false, error: 'Unauthorized' });
    }

    if (!token) {
      return res.status(503).json({ ok: false, error: 'BLOB_READ_WRITE_TOKEN not configured' });
    }

    try {
      const { text, source, duration, language, tags } = req.body;
      if (!text) return res.status(400).json({ ok: false, error: 'text is required' });

      const id = `t_${Date.now()}`;
      const transcript = {
        id,
        text,
        source: source || 'voice-input',
        duration: duration || null,
        language: language || 'en',
        tags: tags || [],
        createdAt: new Date().toISOString()
      };

      // Save individual transcript
      await put(`transcripts/${id}.json`, JSON.stringify(transcript, null, 2), {
        access: 'public', addRandomSuffix: false, token
      });

      // Update index (prepend)
      const index = await getIndex(token);
      index.unshift({ id, source: transcript.source, preview: text.substring(0, 120), createdAt: transcript.createdAt, tags: transcript.tags });

      // Keep last 500 entries in index
      if (index.length > 500) index.length = 500;

      await put(INDEX_FILE, JSON.stringify(index, null, 2), {
        access: 'public', addRandomSuffix: false, token
      });

      return res.status(200).json({ ok: true, id, transcript });
    } catch (e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  return res.status(405).json({ ok: false, error: 'Method not allowed' });
}
