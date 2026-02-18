/**
 * ASTRA HEALTH CHECK
 * GET /api/health -> returns OK status
 */
export default function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(204).end();

  return res.status(200).json({
    ok: true,
    service: 'astra-command-center',
    version: '2.0.0',
    timestamp: new Date().toISOString()
  });
}
