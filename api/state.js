/**
 * ASTRA STATE API
 * GET  /api/state  -> returns saved workspace state from Vercel Blob
 * POST /api/state  -> saves workspace state to Vercel Blob
 *
 * Storage: Vercel Blob (BLOB_READ_WRITE_TOKEN env var)
 * Fallback: returns empty state if Blob not configured
 */
import { put, list } from '@vercel/blob';

const STATE_FILENAME = 'astra-workspace-state.json';
const ADMIN_PASSWORD = process.env.ASTRA_ADMIN_PASSWORD;

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

async function getState() {
  const token = process.env.BLOB_READ_WRITE_TOKEN;
  if (!token) return { _source: 'none', _error: 'BLOB_READ_WRITE_TOKEN not set' };

  try {
    const { blobs } = await list({ prefix: STATE_FILENAME, token });
    if (blobs.length === 0) return { _source: 'empty' };

    const response = await fetch(blobs[0].url);
    if (!response.ok) return { _source: 'error', _error: response.statusText };

    const state = await response.json();
    return { ...state, _source: 'blob' };
  } catch (e) {
    return { _source: 'error', _error: e.message };
  }
}

async function saveState(state) {
  const token = process.env.BLOB_READ_WRITE_TOKEN;
  if (!token) throw new Error('BLOB_READ_WRITE_TOKEN not configured');

  state._savedAt = new Date().toISOString();
  state._version = (state._version || 0) + 1;

  await put(STATE_FILENAME, JSON.stringify(state), {
    access: 'public',
    addRandomSuffix: false,
    allowOverwrite: true,
    token
  });

  return state;
}

export default async function handler(req, res) {
  cors(res);
  if (req.method === 'OPTIONS') return res.status(204).end();

  if (req.method === 'GET') {
    if (!ADMIN_PASSWORD) return res.status(503).json({ ok: false, error: 'ASTRA_ADMIN_PASSWORD not configured' });
    const auth = req.headers.authorization;
    if (!auth || auth !== `Bearer ${ADMIN_PASSWORD}`) return res.status(401).json({ ok: false, error: 'Unauthorized' });

    const state = await getState();
    res.setHeader('Cache-Control', 'no-cache');
    return res.status(200).json(state);
  }

  if (req.method === 'POST') {
    if (!ADMIN_PASSWORD) {
      return res.status(503).json({ ok: false, error: 'ASTRA_ADMIN_PASSWORD not configured' });
    }
    const auth = req.headers.authorization;
    if (!auth || auth !== `Bearer ${ADMIN_PASSWORD}`) {
      return res.status(401).json({ ok: false, error: 'Unauthorized' });
    }

    const token = process.env.BLOB_READ_WRITE_TOKEN;
    if (!token) {
      return res.status(503).json({
        ok: false,
        error: 'BLOB_READ_WRITE_TOKEN not configured. Add it in Vercel Dashboard > Settings > Environment Variables.'
      });
    }

    try {
      const saved = await saveState(req.body);
      return res.status(200).json({ ok: true, version: saved._version, savedAt: saved._savedAt });
    } catch (e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  return res.status(405).json({ ok: false, error: 'Method not allowed' });
}
