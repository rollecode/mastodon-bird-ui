// Browsersync configuration for proxying mastodon.test
// This allows you to develop mastodon-bird-ui CSS while testing against your real Mastodon instance
// VARIANT env var picks the CSS file, e.g. mastodon-bird-ui-accessible
const variant = process.env.VARIANT;
const cssFile = variant || 'mastodon-bird-ui';

module.exports = {
  proxy: {
    target: 'https://mementomori.test',
    proxyOptions: {
      secure: false, // Allow self-signed certificates
    },
    proxyRes: [
      function (proxyRes) {
        // Remove CSP header so Browsersync's injected script can run
        delete proxyRes.headers['content-security-policy'];
      },
    ],
  },
  port: 3999,
  files: ['dist/*.css'],
  https: false,
  serveStatic: [
    {
      route: '/mastodon-bird-ui',
      dir: 'dist',
    },
  ],
  snippetOptions: {
    rule: {
      match: /<\/head>/i,
      fn: function (snippet, match) {
        // Inject CSS before </head>
        const cssInjection = `<link rel="stylesheet" href="/mastodon-bird-ui/${cssFile}.css">\n`;
        return cssInjection + snippet + match;
      },
    },
  },
  open: false,
  notify: true,
  logLevel: 'debug',
  logPrefix: 'Mastodon Bird UI',
  reloadDelay: 0,
  reloadDebounce: 100,
  injectChanges: true,
  watchEvents: ['change', 'add'],
  watchOptions: {
    usePolling: true,
    interval: 500,
  },
  ignore: ['node_modules', '.git', '*.map'],
};
