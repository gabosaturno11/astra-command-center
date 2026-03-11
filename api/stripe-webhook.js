/**
 * ASTRA STRIPE WEBHOOK
 * POST /api/stripe-webhook -> receives Stripe webhook events
 *
 * Handles: checkout.session.completed, invoice.paid,
 *          customer.subscription.created/updated/deleted
 *
 * Validates Stripe signature (STRIPE_WEBHOOK_SECRET env var).
 * Stores events in Supabase `stripe_events` table.
 * Falls back to JSON logging if Supabase fails.
 * Returns 200 quickly (Stripe requires fast responses).
 */

var crypto = require('crypto');
var supabaseLib = null;
try { supabaseLib = require('@supabase/supabase-js'); } catch(e) {}

var STRIPE_WEBHOOK_SECRET = process.env.STRIPE_WEBHOOK_SECRET;

var HANDLED_EVENTS = [
  'checkout.session.completed',
  'invoice.paid',
  'customer.subscription.created',
  'customer.subscription.updated',
  'customer.subscription.deleted'
];

// Verify Stripe signature using HMAC-SHA256
function verifyStripeSignature(payload, sigHeader, secret) {
  if (!secret || !sigHeader) return false;
  var parts = {};
  sigHeader.split(',').forEach(function(item) {
    var kv = item.split('=');
    if (kv[0] === 't') parts.t = kv[1];
    if (kv[0] === 'v1') parts.v1 = kv[1];
  });
  if (!parts.t || !parts.v1) return false;
  var signedPayload = parts.t + '.' + payload;
  var expected = crypto.createHmac('sha256', secret).update(signedPayload).digest('hex');
  try {
    return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(parts.v1));
  } catch(e) {
    return false;
  }
}

function getSupabase() {
  var url = process.env.SUPABASE_URL;
  var key = process.env.SUPABASE_SERVICE_KEY || process.env.SUPABASE_ANON_KEY;
  if (!supabaseLib || !url || !key) return null;
  return supabaseLib.createClient(url, key);
}

function extractEventData(event) {
  var type = event.type;
  var obj = event.data && event.data.object ? event.data.object : {};
  var email = null;
  var amount = null;
  var currency = null;
  var product = null;
  var status = null;

  if (type === 'checkout.session.completed') {
    email = obj.customer_email || obj.customer_details && obj.customer_details.email || null;
    amount = obj.amount_total || null;
    currency = obj.currency || null;
    product = obj.metadata && obj.metadata.product || null;
    status = obj.payment_status || 'completed';
  } else if (type === 'invoice.paid') {
    email = obj.customer_email || null;
    amount = obj.amount_paid || null;
    currency = obj.currency || null;
    product = obj.lines && obj.lines.data && obj.lines.data[0] && obj.lines.data[0].description || null;
    status = 'paid';
  } else if (type.startsWith('customer.subscription.')) {
    email = obj.metadata && obj.metadata.email || null;
    amount = obj.plan && obj.plan.amount || null;
    currency = obj.plan && obj.plan.currency || obj.currency || null;
    product = obj.plan && obj.plan.nickname || obj.metadata && obj.metadata.product || null;
    status = obj.status || type.split('.').pop();
  }

  return {
    id: event.id,
    event_type: type,
    customer_email: email,
    amount: amount,
    currency: currency,
    product: product,
    status: status,
    metadata: JSON.stringify({
      stripe_event_id: event.id,
      object_id: obj.id || null,
      customer_id: obj.customer || null,
      livemode: event.livemode || false
    }),
    created_at: new Date(event.created * 1000).toISOString()
  };
}

// Need raw body for signature verification
module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Stripe-Signature');

  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ ok: false, error: 'POST only' });

  try {
    // Read raw body for signature verification
    var rawBody = '';
    if (typeof req.body === 'string') {
      rawBody = req.body;
    } else if (Buffer.isBuffer(req.body)) {
      rawBody = req.body.toString('utf8');
    } else if (req.body && typeof req.body === 'object') {
      rawBody = JSON.stringify(req.body);
    } else {
      // Read from stream
      var chunks = [];
      await new Promise(function(resolve, reject) {
        req.on('data', function(chunk) { chunks.push(chunk); });
        req.on('end', resolve);
        req.on('error', reject);
      });
      rawBody = Buffer.concat(chunks).toString('utf8');
    }

    // Verify Stripe signature if secret is configured
    var sigHeader = req.headers['stripe-signature'] || '';
    if (STRIPE_WEBHOOK_SECRET) {
      if (!verifyStripeSignature(rawBody, sigHeader, STRIPE_WEBHOOK_SECRET)) {
        console.error('[stripe-webhook] Signature verification failed');
        return res.status(400).json({ ok: false, error: 'Invalid signature' });
      }
    }

    // Parse the event
    var event;
    try {
      event = typeof rawBody === 'string' ? JSON.parse(rawBody) : rawBody;
    } catch(e) {
      return res.status(400).json({ ok: false, error: 'Invalid JSON' });
    }

    if (!event || !event.type || !event.id) {
      return res.status(400).json({ ok: false, error: 'Invalid event payload' });
    }

    // Only process events we care about
    if (HANDLED_EVENTS.indexOf(event.type) === -1) {
      return res.status(200).json({ ok: true, skipped: true, type: event.type });
    }

    var row = extractEventData(event);

    // Try to store in Supabase
    var stored = false;
    var sb = getSupabase();
    if (sb) {
      try {
        var result = await sb.from('stripe_events').upsert(row, { onConflict: 'id' });
        if (result.error) {
          console.error('[stripe-webhook] Supabase error:', result.error.message);
        } else {
          stored = true;
        }
      } catch(e) {
        console.error('[stripe-webhook] Supabase exception:', e.message);
      }
    }

    // Fallback: log to console if Supabase failed
    if (!stored) {
      console.log('[stripe-webhook] Event (fallback log):', JSON.stringify(row));
    }

    // Return 200 quickly
    return res.status(200).json({
      ok: true,
      event_id: event.id,
      type: event.type,
      stored: stored
    });

  } catch(e) {
    console.error('[stripe-webhook] Unhandled error:', e.message);
    // Still return 200 so Stripe doesn't retry unnecessarily
    return res.status(200).json({ ok: true, error: e.message });
  }
};

module.exports.config = {
  api: { bodyParser: false }
};
