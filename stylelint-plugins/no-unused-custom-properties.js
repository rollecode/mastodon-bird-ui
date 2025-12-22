/**
 * Custom Stylelint plugin to detect unused CSS custom properties
 * Checks if custom properties defined in SCSS are used in compiled CSS and SCSS source
 */
const stylelint = require('stylelint');
const fs = require('fs');
const path = require('path');

const ruleName = 'plugin/no-unused-custom-properties';
const messages = stylelint.utils.ruleMessages(ruleName, {
  unused: (prop) => `Unused custom property "${prop}" is defined but never used`,
});

// Cache for var() usages
let varUsageCache = null;
let cacheTimestamp = 0;

// Recursively find files matching extension
function findFiles(dir, ext, files = []) {
  try {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory() && entry.name !== 'node_modules') {
        findFiles(fullPath, ext, files);
      } else if (entry.isFile() && entry.name.endsWith(ext)) {
        files.push(fullPath);
      }
    }
  } catch (err) {
    // Silently ignore errors
  }
  return files;
}

function getUsedVars(cssFiles, scssDir) {
  const now = Date.now();
  // Cache for 5 seconds to avoid re-reading files on every lint
  if (varUsageCache && now - cacheTimestamp < 5000) {
    return varUsageCache;
  }

  const usedVars = new Set();
  const varUsageRegex = /var\(\s*(--[\w-]+)/g;

  // Scan compiled CSS files
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

  // Also scan SCSS source files
  if (scssDir) {
    const scssPath = path.resolve(process.cwd(), scssDir);
    const scssFiles = findFiles(scssPath, '.scss');
    for (const scssFile of scssFiles) {
      try {
        const content = fs.readFileSync(scssFile, 'utf8');
        let match;
        while ((match = varUsageRegex.exec(content)) !== null) {
          usedVars.add(match[1]);
        }
      } catch (err) {
        // Silently ignore read errors
      }
    }
  }

  varUsageCache = usedVars;
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
          scssDir: [(value) => typeof value === 'string'],
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

    // Get SCSS directory to scan
    const scssDir = secondaryOptions?.scssDir || 'src';

    // Get ignore pattern
    const ignorePattern = secondaryOptions?.ignorePattern
      ? new RegExp(secondaryOptions.ignorePattern)
      : null;

    // Get all var() usages from CSS and SCSS files
    const usedVars = getUsedVars(cssFiles, scssDir);

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
