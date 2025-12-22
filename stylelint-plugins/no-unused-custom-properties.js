/**
 * Custom Stylelint plugin to detect unused CSS custom properties
 * Checks if custom properties defined in SCSS are used in compiled CSS
 */
const stylelint = require('stylelint');
const fs = require('fs');
const path = require('path');

const ruleName = 'plugin/no-unused-custom-properties';
const messages = stylelint.utils.ruleMessages(ruleName, {
  unused: (prop) => `Unused custom property "${prop}" is defined but never used`,
});

// Cache for CSS file content
let cssVarUsageCache = null;
let cacheTimestamp = 0;

function getUsedVarsFromCSS(cssFiles) {
  const now = Date.now();
  // Cache for 5 seconds to avoid re-reading files on every lint
  if (cssVarUsageCache && now - cacheTimestamp < 5000) {
    return cssVarUsageCache;
  }

  const usedVars = new Set();
  const varUsageRegex = /var\(\s*(--[\w-]+)/g;

  for (const cssFile of cssFiles) {
    try {
      const fullPath = path.resolve(process.cwd(), cssFile);
      if (fs.existsSync(fullPath)) {
        const content = fs.readFileSync(fullPath, 'utf8');
        let match;
        while ((match = varUsageRegex.exec(content)) !== null) {
          usedVars.add(match[1]);
        }
      }
    } catch (err) {
      // Silently ignore read errors
    }
  }

  cssVarUsageCache = usedVars;
  cacheTimestamp = now;
  return usedVars;
}

const ruleFunction = (primaryOption, secondaryOptions, context) => {
  return (root, result) => {
    const validOptions = stylelint.utils.validateOptions(
      result,
      ruleName,
      {
        actual: primaryOption,
        possible: [true],
      },
      {
        actual: secondaryOptions,
        possible: {
          cssFiles: [(value) => Array.isArray(value) || typeof value === 'string'],
          ignorePattern: [(value) => typeof value === 'string' || value instanceof RegExp],
        },
        optional: true,
      }
    );

    if (!validOptions || !primaryOption) return;

    // Get CSS files to check for usage
    const cssFiles = secondaryOptions?.cssFiles
      ? [].concat(secondaryOptions.cssFiles)
      : ['dist/mastodon-bird-ui.css'];

    // Get ignore pattern
    const ignorePattern = secondaryOptions?.ignorePattern
      ? new RegExp(secondaryOptions.ignorePattern)
      : null;

    // Get all var() usages from CSS files
    const usedVars = getUsedVarsFromCSS(cssFiles);

    // Find all custom property definitions in this file
    root.walkDecls((decl) => {
      if (!decl.prop.startsWith('--')) return;

      const propName = decl.prop;

      // Skip if matches ignore pattern
      if (ignorePattern && ignorePattern.test(propName)) return;

      // Skip Mastodon semantic tokens (they're used by Mastodon itself)
      if (propName.startsWith('--color-') && propName.includes('-primary')) return;
      if (propName.startsWith('--color-') && propName.includes('-secondary')) return;

      // Check if this custom property is used anywhere
      if (!usedVars.has(propName)) {
        stylelint.utils.report({
          message: messages.unused(propName),
          node: decl,
          result,
          ruleName,
        });
      }
    });
  };
};

ruleFunction.ruleName = ruleName;
ruleFunction.messages = messages;

module.exports = stylelint.createPlugin(ruleName, ruleFunction);
