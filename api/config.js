/**
 * ASTRA Config API
 * Returns public Supabase credentials + capability flags
 * No auth required (only exposes public keys)
 */
module.exports = function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Cache-Control', 'public, max-age=300');

  res.status(200).json({
    supabaseUrl: process.env.SUPABASE_URL || null,
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY || null,
    hasSupabase: !!(process.env.SUPABASE_URL && process.env.SUPABASE_ANON_KEY),
    hasBlob: !!process.env.BLOB_READ_WRITE_TOKEN,
    hasOpenAI: !!process.env.OPENAI_API_KEY,
    hasAnthropic: !!process.env.ANTHROPIC_API_KEY
  });
};
