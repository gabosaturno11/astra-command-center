/**
 * ASTRA UNIVERSAL AI INGEST API
 * POST /api/ingest-ai-response  -> receive AI outputs from any LLM (Perplexity, ChatGPT, Gemini, etc.)
 * GET  /api/ingest-ai-response  -> retrieve ingested responses (with optional filters)
 *
 * Universal inbox for AI-generated content. Any LLM can POST here via
 * Perplexity webhook forwarder, Zapier, Make, or direct API call.
 *
 * Stores in Vercel Blob as ai-inbox.json (append-only, capped at 2000).
 */
import { put, list } from '@vercel/blob';

const INBOX_FILE = 'ai-inbox.json';
const ADMIN_PASSWORD = process.env.ASTRA_ADMIN_PASSWORD;

function checkAuth(req) {
  if (!ADMIN_PASSWORD) return false;
  const auth = req.headers.authorization;
  if (auth && auth === `Bearer ${ADMIN_PASSWORD}`) return true;
  const cookieHeader = req.headers.cookie || '';
  const cookieMatch = cookieHeader.match(/(?:^|; )astra_auth=([^;]*)/);
  const cookieToken = cookieMatch ? decodeURIComponent(cookieMatch[1]) : null;
  const authToken = process.env.ASTRA_AUTH_TOKEN || 'astra-fallback-token';
  if (cookieToken === authToken) return true;
  return false;
}

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

async function getInbox(token) {
  try {
    const { blobs } = await list({ prefix: INBOX_FILE, token });
    if (blobs.length === 0) return [];
    const response = await fetch(blobs[0].url);
    if (!response.ok) return [];
    return await response.json();
  } catch (e) { return []; }
}

// Validate required fields per Perplexity spec
function validatePayload(body) {
  const errors = [];
  if (!body.source_llm || typeof body.source_llm !== 'string') {
    errors.push('source_llm is required (string)');
  }
  if (!body.raw_text || typeof body.raw_text !== 'string') {
    errors.push('raw_text is required (string)');
  }
  if (body.raw_text && body.raw_text.length > 500000) {
    errors.push('raw_text exceeds 500KB limit');
  }
  const validChannels = ['api', 'webhook', 'manual', 'extension', 'zapier', 'make', 'n8n'];
  if (body.channel && !validChannels.includes(body.channel)) {
    errors.push('channel must be one of: ' + validChannels.join(', '));
  }
  return errors;
}

export default async function handler(req, res) {
  cors(res);
  if (req.method === 'OPTIONS') return res.status(204).end();

  const token = process.env.BLOB_READ_WRITE_TOKEN;

  // GET — retrieve inbox items with optional filters
  if (req.method === 'GET') {
    if (!checkAuth(req)) return res.status(401).json({ ok: false, error: 'Unauthorized' });
    if (!token) return res.status(200).json({ items: [], _source: 'none' });

    const inbox = await getInbox(token);

    // Optional query filters
    const source = req.query?.source;
    const space = req.query?.space;
    const status = req.query?.status;
    const limit = parseInt(req.query?.limit) || 50;

    let filtered = inbox;
    if (source) filtered = filtered.filter(i => i.source_llm === source);
    if (space) filtered = filtered.filter(i => i.space_or_project === space);
    if (status) filtered = filtered.filter(i => i.status === status);
    filtered = filtered.slice(0, limit);

    return res.status(200).json({
      ok: true,
      items: filtered,
      total: inbox.length,
      filtered: filtered.length,
      _source: 'blob'
    });
  }

  // POST — ingest a new AI response
  if (req.method === 'POST') {
    if (!checkAuth(req)) return res.status(401).json({ ok: false, error: 'Unauthorized' });
    if (!token) return res.status(503).json({ ok: false, error: 'BLOB_READ_WRITE_TOKEN not configured' });

    try {
      const body = req.body || {};
      const errors = validatePayload(body);
      if (errors.length > 0) {
        return res.status(400).json({ ok: false, errors });
      }

      const item = {
        id: `ai_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`,
        source_llm: body.source_llm,
        space_or_project: body.space_or_project || null,
        thread_id: body.thread_id || null,
        role: body.role || 'assistant',
        channel: body.channel || 'api',
        raw_text: body.raw_text,
        metadata: {
          timestamp: body.metadata?.timestamp || new Date().toISOString(),
          tags: body.metadata?.tags || [],
          priority_hint: body.metadata?.priority_hint || 'normal',
          ...(body.metadata || {})
        },
        // ASTRA-specific fields
        status: 'unread',
        ingested_at: new Date().toISOString(),
        astra_project_id: body.astra_project_id || null,
        processed: false
      };

      const inbox = await getInbox(token);
      inbox.unshift(item);
      if (inbox.length > 2000) inbox.length = 2000;

      await put(INBOX_FILE, JSON.stringify(inbox, null, 2), {
        access: 'public', addRandomSuffix: false, allowOverwrite: true, token
      });

      return res.status(200).json({
        ok: true,
        id: item.id,
        ingested_at: item.ingested_at,
        item
      });
    } catch (e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  // DELETE — mark item as processed or remove
  if (req.method === 'DELETE') {
    if (!checkAuth(req)) return res.status(401).json({ ok: false, error: 'Unauthorized' });
    if (!token) return res.status(503).json({ ok: false, error: 'BLOB_READ_WRITE_TOKEN not configured' });

    try {
      const { id, action } = req.body || {};
      if (!id) return res.status(400).json({ ok: false, error: 'id is required' });

      const inbox = await getInbox(token);
      const idx = inbox.findIndex(i => i.id === id);
      if (idx === -1) return res.status(404).json({ ok: false, error: 'Item not found' });

      if (action === 'archive') {
        inbox[idx].status = 'archived';
        inbox[idx].processed = true;
        inbox[idx].processed_at = new Date().toISOString();
      } else {
        inbox.splice(idx, 1);
      }

      await put(INBOX_FILE, JSON.stringify(inbox, null, 2), {
        access: 'public', addRandomSuffix: false, allowOverwrite: true, token
      });

      return res.status(200).json({ ok: true, action: action || 'deleted', id });
    } catch (e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  return res.status(405).json({ ok: false, error: 'Method not allowed' });
}
