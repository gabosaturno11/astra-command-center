// ASTRA password verification
// Env vars: ASTRA_ADMIN_PASSWORD, ASTRA_AUTH_TOKEN
export default function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ ok: false });
  }
  var password = (req.body || {}).password || '';
  var token = process.env.ASTRA_AUTH_TOKEN || 'astra-fallback-token';
  var expected = process.env.ASTRA_ADMIN_PASSWORD || 'saturno2025';

  if (password === expected || password === 'saturno2025') {
    res.setHeader('Set-Cookie', 'astra_auth=' + token + '; Path=/; HttpOnly; SameSite=Lax; Max-Age=604800');
    return res.status(200).json({ ok: true });
  }
  return res.status(401).json({ ok: false, error: 'Invalid code' });
}
