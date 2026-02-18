/**
 * ASTRA QUERY API
 * POST /api/query  -> query the workspace state
 *
 * Queries:
 *   { type: 'specs' }              -> all living docs / specs
 *   { type: 'bottlenecks' }        -> items tagged 'bottleneck' or in bottleneck sections
 *   { type: 'kb', project?: id }   -> knowledge base items (optionally filtered by project)
 *   { type: 'tasks', status?: s }  -> tasks (optionally filtered by status)
 *   { type: 'search', q: string }  -> full-text search across all items
 *   { type: 'projects' }           -> all projects with stats
 *
 * Storage: Reads from Vercel Blob (same state as /api/state)
 */
import { list } from '@vercel/blob';

const STATE_FILENAME = 'astra-workspace-state.json';

function cors(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

async function getState() {
  const token = process.env.BLOB_READ_WRITE_TOKEN;
  if (!token) return null;

  try {
    const { blobs } = await list({ prefix: STATE_FILENAME, token });
    if (blobs.length === 0) return null;
    const response = await fetch(blobs[0].url);
    if (!response.ok) return null;
    return await response.json();
  } catch (e) {
    return null;
  }
}

function searchText(items, query) {
  const q = query.toLowerCase();
  return items.filter(item => {
    const text = JSON.stringify(item).toLowerCase();
    return text.includes(q);
  });
}

export default async function handler(req, res) {
  cors(res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ ok: false, error: 'POST only' });

  const state = await getState();
  if (!state) {
    return res.status(200).json({
      ok: true,
      results: [],
      _note: 'No state saved yet. Save workspace state first via POST /api/state'
    });
  }

  const { type, q, project, status } = req.body;

  switch (type) {
    case 'specs': {
      const specs = state.specs || [];
      return res.status(200).json({ ok: true, count: specs.length, results: specs });
    }

    case 'bottlenecks': {
      const bottlenecks = [];
      // Search KB items tagged bottleneck
      (state.knowledgeBase || []).forEach(kb => {
        if ((kb.tags || []).some(t => t.toLowerCase().includes('bottleneck') || t.toLowerCase().includes('blocker'))) {
          bottlenecks.push({ source: 'kb', ...kb });
        }
      });
      // Search specs for bottleneck sections
      (state.specs || []).forEach(spec => {
        (spec.sections || []).forEach(sec => {
          if (sec.title && sec.title.toLowerCase().includes('bottleneck')) {
            bottlenecks.push({ source: 'spec', specId: spec.id, specTitle: spec.title, ...sec });
          }
        });
      });
      // Search tasks tagged bottleneck
      (state.items || []).filter(i => i.type === 'task').forEach(task => {
        if ((task.tags || []).some(t => t.toLowerCase().includes('bottleneck') || t.toLowerCase().includes('blocker'))) {
          bottlenecks.push({ source: 'task', ...task });
        }
      });
      return res.status(200).json({ ok: true, count: bottlenecks.length, results: bottlenecks });
    }

    case 'kb': {
      let kb = state.knowledgeBase || [];
      if (project) kb = kb.filter(k => k.projectId === project);
      return res.status(200).json({ ok: true, count: kb.length, results: kb });
    }

    case 'tasks': {
      let tasks = (state.items || []).filter(i => i.type === 'task');
      if (status) tasks = tasks.filter(t => t.status === status);
      return res.status(200).json({ ok: true, count: tasks.length, results: tasks });
    }

    case 'projects': {
      const projects = state.projects || [];
      const enriched = projects.map(p => {
        const tasks = (state.items || []).filter(i => i.type === 'task' && i.projectId === p.id);
        const kb = (state.knowledgeBase || []).filter(k => k.projectId === p.id);
        const specs = (state.specs || []).filter(s => s.projectId === p.id);
        return {
          ...p,
          taskCount: tasks.length,
          completedTasks: tasks.filter(t => t.status === 'done').length,
          kbCount: kb.length,
          specCount: specs.length
        };
      });
      return res.status(200).json({ ok: true, count: enriched.length, results: enriched });
    }

    case 'search': {
      if (!q) return res.status(400).json({ ok: false, error: 'q is required for search' });
      const results = [];
      // Search items
      searchText(state.items || [], q).forEach(i => results.push({ source: 'item', ...i }));
      // Search KB
      searchText(state.knowledgeBase || [], q).forEach(k => results.push({ source: 'kb', ...k }));
      // Search specs
      (state.specs || []).forEach(spec => {
        if (JSON.stringify(spec).toLowerCase().includes(q.toLowerCase())) {
          results.push({ source: 'spec', id: spec.id, title: spec.title, sectionCount: (spec.sections || []).length });
        }
      });
      // Search projects
      searchText(state.projects || [], q).forEach(p => results.push({ source: 'project', ...p }));
      return res.status(200).json({ ok: true, count: results.length, results });
    }

    default:
      return res.status(400).json({ ok: false, error: `Unknown query type: ${type}. Use: specs, bottlenecks, kb, tasks, projects, search` });
  }
}
