// Browsersync configuration for proxying mastodon.test
// This allows you to develop mastodon-bird-ui CSS while testing against your real Mastodon instance
// VARIANT env var sets both CSS file and theme name (for variant-specific builds like stars, light, accessible)
// For base theme: CSS file is mastodon-bird-ui.css, theme name is mastodon-bird-ui-dark
const variant = process.env.VARIANT;
const cssFile = variant || 'mastodon-bird-ui';
const theme = variant || 'mastodon-bird-ui-dark';

module.exports = {
  proxy: {
    target: 'https://mementomori.test',
    proxyOptions: {
      secure: false, // Allow self-signed certificates
    },
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
  rewriteRules: [
    {
      // Force data-user-theme attribute on html element in the HTML response
      match: /<html([^>]*)data-user-theme="[^"]*"([^>]*)>/i,
      fn: function (req, res, matchedString) {
        return matchedString.replace(/data-user-theme="[^"]*"/, `data-user-theme="${theme}"`);
      },
    },
    {
      // Add data-user-theme if not present
      match: /<html(?![^>]*data-user-theme)([^>]*)>/i,
      fn: function (req, res, matchedString) {
        return matchedString.replace('<html', `<html data-user-theme="${theme}"`);
      },
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
