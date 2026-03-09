/**
 * ASTRA Supabase Sync API
 * GET  /api/supabase-sync         -> load full state from Supabase
 * POST /api/supabase-sync         -> push full state to Supabase
 * POST /api/supabase-sync?entity= -> upsert single entity
 * DELETE /api/supabase-sync       -> delete entity
 */

var supabaseLib = null;
try { supabaseLib = require('@supabase/supabase-js'); } catch(e) {}

var ADMIN_PASSWORD = process.env.ASTRA_ADMIN_PASSWORD;

function checkAuth(req) {
  if (!ADMIN_PASSWORD) return false;
  var auth = req.headers.authorization;
  if (auth && auth === 'Bearer ' + ADMIN_PASSWORD) return true;
  var cookieHeader = req.headers.cookie || '';
  var cookieMatch = cookieHeader.match(/(?:^|; )astra_auth=([^;]*)/);
  var cookieToken = cookieMatch ? decodeURIComponent(cookieMatch[1]) : null;
  var authToken = process.env.ASTRA_AUTH_TOKEN || 'astra-fallback-token';
  if (cookieToken === authToken) return true;
  return false;
}

function getSupabase() {
  var url = process.env.SUPABASE_URL;
  var key = process.env.SUPABASE_SERVICE_KEY || process.env.SUPABASE_ANON_KEY;
  if (!supabaseLib || !url || !key) return null;
  return supabaseLib.createClient(url, key);
}

// Table map: state key -> supabase table
var TABLE_MAP = {
  projects: 'astra_projects',
  content: 'astra_content',
  tasks: 'astra_tasks',
  links: 'astra_links',
  docs: 'astra_docs',
  specs: 'astra_specs',
  knowledgeBase: 'astra_knowledge_base',
  calendar: 'astra_calendar',
  rants: 'astra_rants',
  pipelineResults: 'astra_pipeline_results'
};

// camelCase -> snake_case field mappers per table
function toSnake(obj, table) {
  if (!obj) return obj;
  var mapped = {};
  var keys = Object.keys(obj);
  for (var i = 0; i < keys.length; i++) {
    var k = keys[i];
    var sk = k.replace(/([A-Z])/g, function(m) { return '_' + m.toLowerCase(); });
    // Special mappings
    if (k === 'projectId') sk = 'project_id';
    else if (k === 'createdAt' || k === 'created') sk = 'created_at';
    else if (k === 'updatedAt' || k === 'updated') sk = 'updated_at';
    else if (k === 'completedAt') sk = 'completed_at';
    else if (k === 'readLater') sk = 'read_later';
    mapped[sk] = obj[k];
  }
  return mapped;
}

function toCamel(obj) {
  if (!obj) return obj;
  var mapped = {};
  var keys = Object.keys(obj);
  for (var i = 0; i < keys.length; i++) {
    var k = keys[i];
    var ck = k.replace(/_([a-z])/g, function(m, c) { return c.toUpperCase(); });
    mapped[ck] = obj[k];
  }
  return mapped;
}

async function loadFullState(sb) {
  var state = {};
  var entityKeys = Object.keys(TABLE_MAP);
  for (var i = 0; i < entityKeys.length; i++) {
    var key = entityKeys[i];
    var table = TABLE_MAP[key];
    try {
      var result = await sb.from(table).select('*');
      if (result.error) {
        console.error('Load ' + table + ':', result.error.message);
        state[key] = [];
      } else {
        state[key] = (result.data || []).map(toCamel);
      }
    } catch(e) {
      console.error('Load ' + table + ':', e.message);
      state[key] = [];
    }
  }
  // Whiteboard is a single row
  try {
    var wb = await sb.from('astra_whiteboard').select('*').eq('id', 'main').single();
    state.whiteboard = wb.data ? toCamel(wb.data) : {};
  } catch(e) { state.whiteboard = {}; }
  // Settings
  try {
    var settings = await sb.from('astra_settings').select('*');
    state.settings = {};
    if (settings.data) {
      for (var s = 0; s < settings.data.length; s++) {
        state.settings[settings.data[s].key] = settings.data[s].value;
      }
    }
  } catch(e) { state.settings = {}; }
  return state;
}

async function pushFullState(sb, body) {
  var results = {};
  var entityKeys = Object.keys(TABLE_MAP);
  for (var i = 0; i < entityKeys.length; i++) {
    var key = entityKeys[i];
    var table = TABLE_MAP[key];
    var items = body[key];
    if (!Array.isArray(items)) continue;
    // Upsert all items
    var rows = items.map(function(item) { return toSnake(item, table); });
    if (rows.length === 0) continue;
    try {
      var res = await sb.from(table).upsert(rows, { onConflict: 'id' });
      results[key] = { count: rows.length, error: res.error ? res.error.message : null };
    } catch(e) {
      results[key] = { count: 0, error: e.message };
    }
  }
  // Whiteboard
  if (body.whiteboard) {
    try {
      var wbData = toSnake(body.whiteboard);
      wbData.id = 'main';
      wbData.updated_at = new Date().toISOString();
      await sb.from('astra_whiteboard').upsert(wbData, { onConflict: 'id' });
      results.whiteboard = { ok: true };
    } catch(e) { results.whiteboard = { error: e.message }; }
  }
  return results;
}

module.exports = async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  if (req.method === 'OPTIONS') return res.status(204).end();

  if (!checkAuth(req)) return res.status(401).json({ ok: false, error: 'Unauthorized' });

  var sb = getSupabase();
  if (!sb) {
    return res.status(503).json({
      ok: false,
      error: 'Supabase not configured',
      missing: !process.env.SUPABASE_URL ? 'SUPABASE_URL' : !process.env.SUPABASE_SERVICE_KEY ? 'SUPABASE_SERVICE_KEY' : '@supabase/supabase-js'
    });
  }

  // GET: load full state
  if (req.method === 'GET') {
    try {
      var state = await loadFullState(sb);
      state._source = 'supabase';
      state._loadedAt = new Date().toISOString();
      return res.status(200).json({ ok: true, state: state });
    } catch(e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  // POST: push full state or upsert entity
  if (req.method === 'POST') {
    var entity = req.query.entity;
    if (entity) {
      // Single entity upsert
      var table = TABLE_MAP[entity];
      if (!table) return res.status(400).json({ ok: false, error: 'Unknown entity: ' + entity });
      var row = toSnake(req.body);
      try {
        var result = await sb.from(table).upsert(row, { onConflict: 'id' });
        if (result.error) return res.status(500).json({ ok: false, error: result.error.message });
        return res.status(200).json({ ok: true, entity: entity });
      } catch(e) {
        return res.status(500).json({ ok: false, error: e.message });
      }
    }
    // Full state push
    try {
      var results = await pushFullState(sb, req.body);
      return res.status(200).json({ ok: true, results: results, pushedAt: new Date().toISOString() });
    } catch(e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  // DELETE: remove entity
  if (req.method === 'DELETE') {
    var entityType = req.query.entity;
    var entityId = req.query.id;
    if (!entityType || !entityId) return res.status(400).json({ ok: false, error: 'entity and id required' });
    var table = TABLE_MAP[entityType];
    if (!table) return res.status(400).json({ ok: false, error: 'Unknown entity: ' + entityType });
    try {
      var result = await sb.from(table).delete().eq('id', entityId);
      if (result.error) return res.status(500).json({ ok: false, error: result.error.message });
      return res.status(200).json({ ok: true, deleted: entityId });
    } catch(e) {
      return res.status(500).json({ ok: false, error: e.message });
    }
  }

  return res.status(405).json({ ok: false, error: 'Method not allowed' });
};
