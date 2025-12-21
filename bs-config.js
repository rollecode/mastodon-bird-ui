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
  snippetOptions: {
    rule: {
      match: /<\/head>/i,
      fn: function (snippet, match) {
        // Inject CSS file and add mastodon-bird-ui class to html element for dev mode
        const cssInjection = `
    <link rel="stylesheet" href="/mastodon-bird-ui/${variant}.css">
    <script>document.documentElement.classList.add('mastodon-bird-ui');</script>
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
