// ASTRA Command Center — password protection
// Gabo's private hub. NOT public. NOT visible.
// Password: set ASTRA_ADMIN_PASSWORD in Vercel env vars
// Fallback password: saturno2025 (same as vault)

import { next } from '@vercel/functions';

function getCookie(request, name) {
  var header = request.headers.get('cookie') || '';
  var match = header.match(new RegExp('(?:^|; )' + name + '=([^;]*)'));
  return match ? decodeURIComponent(match[1]) : null;
}

export default function middleware(request) {
  var url = new URL(request.url);

  // Allow API endpoints through (they have their own auth)
  if (url.pathname.startsWith('/api/')) {
    return next();
  }

  // Allow the gate page itself
  if (url.pathname === '/astra-gate.html') {
    return next();
  }

  // Allow static assets needed by gate
  if (url.pathname.match(/\.(png|svg|ico|css|js|woff2?)$/)) {
    return next();
  }

  // Check auth cookie
  var cookie = getCookie(request, 'astra_auth');
  var token = process.env.ASTRA_AUTH_TOKEN || 'astra-fallback-token';

  if (cookie === token) {
    return next();
  }

  // Not authenticated — redirect to gate
  return Response.redirect(new URL('/astra-gate.html', request.url));
}

export var config = {
  matcher: ['/', '/index.html', '/astra-manual.html', '/((?!api|_next|astra-gate).*)'],
};
