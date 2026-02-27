/**
 * ASTRA REPOS API
 * GET  /api/repos -> list all connected repos with status
 * POST /api/repos/ping -> repo pings ASTRA to report status
 *
 * Central registry of all Saturno ecosystem repos.
 * Each repo can ping ASTRA to report its health.
 */
import { put, list } from '@vercel/blob';

const REPOS_FILE = 'repos-registry.json';

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

// Hardcoded repo registry — the canonical list
const REPO_REGISTRY = [
  {
    id: 'astra-command-center',
    name: 'ASTRA Command Center',
    path: '~/dev/astra-command-center/',
    liveUrl: 'https://astra-command-center-sigma.vercel.app',
    github: 'gabosaturno11/astra-command-center',
    role: 'backend-hub',
    description: 'Central hub — backend, KB, pipeline, voice, projects',
    hasApi: true,
    apiEndpoints: ['/api/capture', '/api/transcribe', '/api/pipeline', '/api/state', '/api/query', '/api/transcripts', '/api/health', '/api/repos'],
  },
  {
    id: 'saturno-bonus',
    name: 'Saturno Bonus',
    path: '~/dev/saturno-bonus/',
    liveUrl: 'https://saturno-bonus-omega.vercel.app',
    github: 'gabosaturno11/saturno-bonus',
    role: 'customer-facing',
    description: 'Bonus page — customer content, tools, music, PDFs',
    hasApi: true,
    apiEndpoints: ['/api/verify', '/api/admin-verify', '/api/config', '/api/brevo-subscribe'],
  },
  {
    id: 'titan-forge',
    name: 'Titan Forge',
    path: '~/dev/titan-forge/',
    liveUrl: 'https://titan-forge-ten.vercel.app',
    github: 'gabosaturno11/titan-forge',
    role: 'internal-tools',
    description: 'Internal tools — writer, batch generator, onboarding',
    hasApi: true,
    apiEndpoints: ['/api/verify', '/api/admin-verify', '/api/config', '/api/brevo-subscribe'],
  },
  {
    id: 'de-aqui-a-saturno',
    name: 'De Aqui a Saturno',
    path: '~/dev/de-aqui-a-saturno/',
    liveUrl: 'https://de-aqui-a-saturno-jet.vercel.app',
    github: 'gabosaturno11/de-aqui-a-saturno',
    role: 'experience',
    description: 'Valentine\'s experience — Vimeo videos, interactive',
    hasApi: false,
    apiEndpoints: [],
  },
  {
    id: 'nexus-capture',
    name: 'Nexus Capture',
    path: '~/dev/nexus-capture/',
    liveUrl: null,
    github: 'gabosaturno11/nexus-capture',
    role: 'extension',
    description: 'Chrome extension + floating bar + system-wide capture + TTS',
    hasApi: false,
    apiEndpoints: [],
    tools: ['capture-highlight.sh', 'create-sound.sh', 'open-nexus-bar.sh', 'floating-bar.html'],
  },
];

async function getRegistry(token) {
  try {
    const { blobs } = await list({ prefix: REPOS_FILE, token });
    if (blobs.length === 0) return {};
    const response = await fetch(blobs[0].url);
    if (!response.ok) return {};
    return await response.json();
  } catch (e) {
    return {};
  }
}

function checkAuth(req) {
  const ADMIN_PASSWORD = process.env.ASTRA_ADMIN_PASSWORD;
  if (!ADMIN_PASSWORD) return false;
  const authHeader = req.headers.authorization || '';
  const bearerToken = authHeader.replace(/^Bearer\s+/i, '');
  return bearerToken === ADMIN_PASSWORD;
}

export default async function handler(req, res) {
  cors(res);
  if (req.method === 'OPTIONS') return res.status(204).end();

  // Auth required — exposes repo names, URLs, paths
  if (!checkAuth(req)) {
    return res.status(401).json({ ok: false, error: 'Unauthorized' });
  }

  const token = process.env.BLOB_READ_WRITE_TOKEN;

  if (req.method === 'GET') {
    // Return full registry with last-ping status
    let pingData = {};
    if (token) {
      pingData = await getRegistry(token);
    }

    const repos = REPO_REGISTRY.map(repo => ({
      ...repo,
      lastPing: pingData[repo.id]?.lastPing || null,
      pingStatus: pingData[repo.id]?.status || 'unknown',
      pingMessage: pingData[repo.id]?.message || null,
    }));

    return res.status(200).json({ ok: true, repos, count: repos.length });
  }

  if (req.method === 'POST') {
    // Repo pings ASTRA to register itself
    const { repoId, status, message, version } = req.body || {};

    if (!repoId) {
      return res.status(400).json({ ok: false, error: 'repoId is required' });
    }

    const known = REPO_REGISTRY.find(r => r.id === repoId);
    if (!known) {
      return res.status(400).json({ ok: false, error: `Unknown repo: ${repoId}` });
    }

    if (!token) {
      return res.status(200).json({ ok: true, stored: false, message: 'No blob token — ping acknowledged but not stored' });
    }

    try {
      const registry = await getRegistry(token);
      registry[repoId] = {
        lastPing: new Date().toISOString(),
        status: status || 'online',
        message: message || null,
        version: version || null,
      };

      await put(REPOS_FILE, JSON.stringify(registry, null, 2), {
        access: 'public', addRandomSuffix: false, token,
      });

      return res.status(200).json({ ok: true, stored: true, repoId });
    } catch (e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  return res.status(405).json({ ok: false, error: 'GET or POST only' });
}
