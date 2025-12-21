// Browsersync configuration for proxying mastodon.test
// This allows you to develop mastodon-bird-ui CSS while testing against your real Mastodon instance
const variant = process.env.VARIANT || 'mastodon-bird-ui';

module.exports = {
  proxy: 'https://mementomori.test',
  port: 3999,
  files: ['dist/**/*.css'],
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
        return matchedString.replace(/data-user-theme="[^"]*"/, `data-user-theme="${variant}"`);
      },
    },
    {
      // Add data-user-theme if not present
      match: /<html(?![^>]*data-user-theme)([^>]*)>/i,
      fn: function (req, res, matchedString) {
        return matchedString.replace('<html', `<html data-user-theme="${variant}"`);
      },
    },
  ],
  snippetOptions: {
    rule: {
      match: /<\/head>/i,
      fn: function (snippet, match) {
        // Inject CSS and add class/attribute for dev mode
        const cssInjection = `
    <link rel="stylesheet" href="/mastodon-bird-ui/${variant}.css">
    <script>
      (function() {
        var theme = '${variant}';
        document.documentElement.classList.add('mastodon-bird-ui');
        document.documentElement.dataset.userTheme = theme;
        // Override after React hydration
        window.addEventListener('load', function() {
          setTimeout(function() {
            document.documentElement.dataset.userTheme = theme;
          }, 100);
        });
      })();
    </script>
`;
        return cssInjection + snippet + match;
      },
    },
  },
  open: false,
  notify: true,
  logLevel: 'info',
  logPrefix: 'Mastodon Bird UI',
  reloadDelay: 0,
  reloadDebounce: 500,
  injectChanges: true,
  watchEvents: ['change'],
  ignore: ['node_modules', '.git', '*.map'],
};
