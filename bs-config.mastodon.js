// Browsersync configuration for proxying mastodon.social
const { createProxyMiddleware, responseInterceptor } = require('http-proxy-middleware');
const variant = process.env.VARIANT || 'mastodon-bird-ui';

const proxy = createProxyMiddleware({
  target: 'https://mastodon.social',
  changeOrigin: true,
  secure: true,
  selfHandleResponse: true,
  on: {
    proxyRes: responseInterceptor(async (responseBuffer, proxyRes, req, res) => {
      // Only modify HTML responses
      const contentType = proxyRes.headers['content-type'] || '';
      if (contentType.includes('text/html')) {
        let html = responseBuffer.toString('utf8');
        // Inject CSS before </head>
        html = html.replace(
          /<\/head>/i,
          `<link rel="stylesheet" href="/mastodon-bird-ui/${variant}.css">\n</head>`
        );
        return html;
      }
      // Return unchanged for non-HTML (JSON, etc.)
      return responseBuffer;
    }),
  },
});

module.exports = {
  server: {
    baseDir: '.',
    middleware: [proxy],
  },
  serveStatic: [
    {
      route: '/mastodon-bird-ui',
      dir: 'dist',
    },
  ],
  port: 3998,
  files: ['dist/**/*.css'],
  open: false,
  notify: true,
  logLevel: 'info',
  logPrefix: 'Bird UI (mastodon.social)',
  reloadDelay: 0,
  reloadDebounce: 500,
  injectChanges: true,
  watchEvents: ['change'],
  ignore: ['node_modules', '.git', '*.map'],
};
