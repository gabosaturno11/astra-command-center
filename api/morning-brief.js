/**
 * ASTRA MORNING BRIEF API
 * GET /api/morning-brief -> generates daily 3-action morning brief
 *
 * Reads from Supabase: recent stripe_events (7 days), tasks (overdue + today),
 * content_vault (recent items). Uses Claude Sonnet to generate:
 * - Revenue summary (last 7 days)
 * - 3 prioritized actions for today
 * - Urgent items (overdue tasks, failed payments)
 *
 * Protected with Bearer ASTRA_ADMIN_PASSWORD.
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

async function fetchStripeEvents(sb) {
  try {
    var sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
    var result = await sb.from('stripe_events').select('*').gte('created_at', sevenDaysAgo).order('created_at', { ascending: false });
    if (result.error) {
      console.error('[morning-brief] stripe_events error:', result.error.message);
      return [];
    }
    return result.data || [];
  } catch(e) {
    console.error('[morning-brief] stripe_events exception:', e.message);
    return [];
  }
}

async function fetchTasks(sb) {
  try {
    var today = new Date().toISOString().split('T')[0];
    var result = await sb.from('astra_tasks').select('*').in('status', ['todo', 'in-progress', 'blocked']).order('created_at', { ascending: false }).limit(50);
    if (result.error) {
      console.error('[morning-brief] tasks error:', result.error.message);
      return [];
    }
    var tasks = result.data || [];
    // Mark overdue and today's tasks
    return tasks.map(function(t) {
      var due = t.due_date || t.due;
      t._overdue = due && due < today;
      t._dueToday = due && due.startsWith(today);
      return t;
    });
  } catch(e) {
    console.error('[morning-brief] tasks exception:', e.message);
    return [];
  }
}

async function fetchRecentContent(sb) {
  try {
    var threeDaysAgo = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString();
    var result = await sb.from('astra_content').select('*').gte('created_at', threeDaysAgo).order('created_at', { ascending: false }).limit(20);
    if (result.error) {
      console.error('[morning-brief] content error:', result.error.message);
      return [];
    }
    return result.data || [];
  } catch(e) {
    console.error('[morning-brief] content exception:', e.message);
    return [];
  }
}

function calculateRevenue(events) {
  var total = 0;
  for (var i = 0; i < events.length; i++) {
    var evt = events[i];
    if (evt.event_type === 'checkout.session.completed' || evt.event_type === 'invoice.paid') {
      var amount = evt.amount || 0;
      // Stripe amounts are in cents
      total += amount / 100;
    }
  }
  return Math.round(total * 100) / 100;
}

async function generateBrief(stripeEvents, tasks, content, revenue7d) {
  var anthropicKey = process.env.ANTHROPIC_API_KEY;
  if (!anthropicKey) return null;

  var overdueTasks = tasks.filter(function(t) { return t._overdue; });
  var todayTasks = tasks.filter(function(t) { return t._dueToday; });
  var inProgressTasks = tasks.filter(function(t) { return t.status === 'in-progress'; });
  var blockedTasks = tasks.filter(function(t) { return t.status === 'blocked'; });
  var failedPayments = stripeEvents.filter(function(e) {
    return e.status === 'failed' || e.status === 'unpaid';
  });

  var contextBlock = [
    '## Revenue (Last 7 Days)',
    'Total: $' + revenue7d,
    'Events: ' + stripeEvents.length,
    stripeEvents.length > 0 ? stripeEvents.slice(0, 10).map(function(e) {
      return '- ' + e.event_type + ': ' + (e.customer_email || 'unknown') + ' $' + ((e.amount || 0) / 100) + ' (' + e.status + ')';
    }).join('\n') : '(No Stripe events this week)',
    '',
    '## Tasks',
    'Overdue: ' + overdueTasks.length,
    overdueTasks.slice(0, 5).map(function(t) { return '- [OVERDUE] ' + (t.title || t.name || 'Untitled') + ' (due: ' + (t.due_date || t.due || '?') + ')'; }).join('\n'),
    'Due Today: ' + todayTasks.length,
    todayTasks.slice(0, 5).map(function(t) { return '- [TODAY] ' + (t.title || t.name || 'Untitled'); }).join('\n'),
    'In Progress: ' + inProgressTasks.length,
    inProgressTasks.slice(0, 5).map(function(t) { return '- [WIP] ' + (t.title || t.name || 'Untitled'); }).join('\n'),
    'Blocked: ' + blockedTasks.length,
    blockedTasks.slice(0, 3).map(function(t) { return '- [BLOCKED] ' + (t.title || t.name || 'Untitled'); }).join('\n'),
    '',
    '## Recent Content (' + content.length + ' items, last 3 days)',
    content.slice(0, 5).map(function(c) { return '- ' + (c.title || c.name || 'Untitled') + ' (' + (c.type || 'content') + ')'; }).join('\n'),
    '',
    '## Failed/Unpaid Payments',
    failedPayments.length > 0 ? failedPayments.map(function(e) {
      return '- ' + (e.customer_email || 'unknown') + ': ' + e.event_type + ' (' + e.status + ')';
    }).join('\n') : '(None)'
  ].join('\n');

  var systemPrompt = 'You are ASTRA, Gabo Saturno\'s command center AI. Generate a concise morning brief. Be direct, no fluff, no emojis. Format as a brief executive summary followed by exactly 3 prioritized actions. Each action needs a title, a one-line "why", and the project it belongs to. Flag anything urgent.';

  var userPrompt = 'Generate my morning brief for ' + new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }) + '.\n\n' + contextBlock + '\n\nReturn a JSON object with this exact structure:\n{\n  "brief": "2-3 sentence executive summary of what matters today",\n  "actions": [\n    { "title": "Action 1", "why": "One line reason", "project": "project_name" },\n    { "title": "Action 2", "why": "One line reason", "project": "project_name" },\n    { "title": "Action 3", "why": "One line reason", "project": "project_name" }\n  ],\n  "urgent": ["any urgent item descriptions"]\n}\n\nReturn ONLY the JSON, no markdown fences.';

  var response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': anthropicKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json'
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-6',
      max_tokens: 2048,
      system: systemPrompt,
      messages: [{ role: 'user', content: userPrompt }]
    })
  });

  if (!response.ok) {
    var errText = await response.text();
    throw new Error('Claude error ' + response.status + ': ' + errText);
  }

  var result = await response.json();
  var text = result.content && result.content[0] && result.content[0].text || '';

  // Parse the JSON response
  try {
    return JSON.parse(text);
  } catch(e) {
    // Try to extract JSON from response if wrapped in markdown
    var jsonMatch = text.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      try { return JSON.parse(jsonMatch[0]); } catch(e2) {}
    }
    // Return raw text as brief if parsing fails
    return {
      brief: text,
      actions: [],
      urgent: []
    };
  }
}

module.exports = async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Credentials', 'true');

  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'GET') return res.status(405).json({ ok: false, error: 'GET only' });

  if (!checkAuth(req)) return res.status(401).json({ ok: false, error: 'Unauthorized' });

  try {
    var sb = getSupabase();
    var stripeEvents = [];
    var tasks = [];
    var content = [];

    if (sb) {
      // Fetch all data in parallel
      var results = await Promise.all([
        fetchStripeEvents(sb),
        fetchTasks(sb),
        fetchRecentContent(sb)
      ]);
      stripeEvents = results[0];
      tasks = results[1];
      content = results[2];
    }

    var revenue7d = calculateRevenue(stripeEvents);

    // Generate brief with Claude
    var anthropicKey = process.env.ANTHROPIC_API_KEY;
    if (!anthropicKey) {
      return res.status(503).json({
        ok: false,
        error: 'ANTHROPIC_API_KEY not configured',
        revenue_7d: revenue7d,
        data: {
          stripe_events: stripeEvents.length,
          tasks: tasks.length,
          content: content.length
        }
      });
    }

    var briefData = await generateBrief(stripeEvents, tasks, content, revenue7d);

    return res.status(200).json({
      ok: true,
      brief: briefData.brief || '',
      revenue_7d: revenue7d,
      actions: briefData.actions || [],
      urgent: briefData.urgent || [],
      generated_at: new Date().toISOString(),
      _sources: {
        stripe_events: stripeEvents.length,
        tasks: tasks.length,
        content: content.length
      }
    });

  } catch(e) {
    console.error('[morning-brief] Error:', e.message);
    return res.status(500).json({ ok: false, error: e.message });
  }
};
