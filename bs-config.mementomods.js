// Browsersync configuration for proxying mementomori.social
const { createProxyMiddleware, responseInterceptor } = require('http-proxy-middleware');
const variant = process.env.VARIANT;
const cssFile = variant || 'mastodon-bird-ui';
const theme = variant || 'mastodon-bird-ui-dark';

const proxy = createProxyMiddleware({
  target: 'https://mementomori.social',
  changeOrigin: true,
  secure: true,
  selfHandleResponse: true,
  on: {
    proxyRes: responseInterceptor(async (responseBuffer, proxyRes, req, res) => {
      // Only modify HTML responses
      const contentType = proxyRes.headers['content-type'] || '';
      if (contentType.includes('text/html')) {
        let html = responseBuffer.toString('utf8');
        // Inject CSS and script before </head>
        const injection = `
    <link rel="stylesheet" href="/mastodon-bird-ui/${cssFile}.css">
    <script>
      (function() {
        document.documentElement.dataset.userTheme = '${theme}';
        window.addEventListener('load', function() {
          setTimeout(function() {
            document.documentElement.dataset.userTheme = '${theme}';
          }, 100);
        });
      })();
    </script>
`;
        html = html.replace(/<\/head>/i, injection + '</head>');
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
  port: 3999,
  files: ['dist/**/*.css'],
  open: false,
  notify: true,
  logLevel: 'info',
  logPrefix: 'Bird UI (mementomods)',
  reloadDelay: 0,
  reloadDebounce: 500,
  injectChanges: true,
  watchEvents: ['change'],
  ignore: ['node_modules', '.git', '*.map'],
};
