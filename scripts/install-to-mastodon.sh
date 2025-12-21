#!/bin/bash
# Mastodon Bird UI - Install to Mastodon Core
# https://github.com/ronilaukkarinen/mastodon-bird-ui
# Author: Roni Laukkarinen (@rolle@mementomori.social)
#
# This script installs Bird UI to your Mastodon installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default Mastodon path
MASTODON_PATH="${MASTODON_PATH:-}"

# Get version from CHANGELOG.md
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../src"
VERSION=$(grep -m1 '^### ' "$SCRIPT_DIR/../CHANGELOG.md" | sed 's/### \([^:]*\):.*/\1/')

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--path)
      MASTODON_PATH="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [-p|--path /path/to/mastodon]"
      echo ""
      echo "Options:"
      echo "  -p, --path    Path to Mastodon installation"
      echo "  -h, --help    Show this help message"
      echo ""
      echo "Environment variables:"
      echo "  MASTODON_PATH    Alternative way to specify Mastodon path"
      echo ""
      echo "Example:"
      echo "  $0 --path /opt/mastodon"
      echo "  MASTODON_PATH=/opt/mastodon $0"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Check if Mastodon path is provided
if [ -z "$MASTODON_PATH" ]; then
  echo -e "${YELLOW}Mastodon path not specified.${NC}"
  echo ""
  read -p "Enter your Mastodon installation path: " MASTODON_PATH
fi

# Validate Mastodon path
if [ ! -d "$MASTODON_PATH" ]; then
  echo -e "${RED}Error: Directory not found: $MASTODON_PATH${NC}"
  exit 1
fi

STYLES_PATH="$MASTODON_PATH/app/javascript/styles"
THEMES_FILE="$MASTODON_PATH/config/themes.yml"

if [ ! -d "$STYLES_PATH" ]; then
  echo -e "${RED}Error: Styles directory not found: $STYLES_PATH${NC}"
  echo "Are you sure this is a Mastodon installation?"
  exit 1
fi

if [ ! -f "$THEMES_FILE" ]; then
  echo -e "${RED}Error: themes.yml not found: $THEMES_FILE${NC}"
  exit 1
fi

echo -e "${GREEN}Installing Mastodon Bird UI $VERSION to $MASTODON_PATH${NC}"
echo ""

# Create mastodon-bird-ui directory
echo "Creating mastodon-bird-ui/ directory..."
mkdir -p "$STYLES_PATH/mastodon-bird-ui"

# Copy Bird UI files
echo "Copying Bird UI files..."
cp "$SRC_DIR"/legacy/_layout-*.scss "$STYLES_PATH/mastodon-bird-ui/"
cp "$SRC_DIR"/variants/_*.scss "$STYLES_PATH/mastodon-bird-ui/"
cp "$SRC_DIR"/micro-interactions/_star.scss "$STYLES_PATH/mastodon-bird-ui/_stars.scss"
cp "$SRC_DIR"/_variables-light.scss "$STYLES_PATH/mastodon-bird-ui/"

# Generate theme entry points
echo "Generating theme entry points..."

# Dark theme (base)
cat > "$STYLES_PATH/mastodon-bird-ui-dark.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
EOF
echo "  - mastodon-bird-ui-dark.scss"

# Dark with stars
cat > "$STYLES_PATH/mastodon-bird-ui-dark-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/stars';
EOF
echo "  - mastodon-bird-ui-dark-change-to-stars.scss"

# Hide Finnish translate button
cat > "$STYLES_PATH/hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
echo "  - hide-finnish.scss"

# Hide Finnish with stars
cat > "$STYLES_PATH/hide-finnish-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/stars';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
echo "  - hide-finnish-change-to-stars.scss"

# Hide all translate links
cat > "$STYLES_PATH/hide-translate-links.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';

.status__content[lang] + .translate-button {
  display: none;
}
EOF
echo "  - hide-translate-links.scss"

# Light theme
cat > "$STYLES_PATH/mastodon-bird-ui-light.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/variables-light';
EOF
echo "  - mastodon-bird-ui-light.scss"

# Light hide Finnish
cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/variables-light';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
echo "  - mastodon-bird-ui-light-hide-finnish.scss"

# Light hide Finnish with stars
cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-finnish-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/variables-light';
@use 'mastodon-bird-ui/stars';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
echo "  - mastodon-bird-ui-light-hide-finnish-change-to-stars.scss"

# Light hide translate links
cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-translate-links.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/variables-light';

.status__content[lang] + .translate-button {
  display: none;
}
EOF
echo "  - mastodon-bird-ui-light-hide-translate-links.scss"

# Contrast theme
cat > "$STYLES_PATH/mastodon-bird-ui-contrast.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
EOF
echo "  - mastodon-bird-ui-contrast.scss"

# Accessible theme
cat > "$STYLES_PATH/mastodon-bird-ui-accessible.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/accessible';
EOF
echo "  - mastodon-bird-ui-accessible.scss"

# Accessible hide Finnish
cat > "$STYLES_PATH/mastodon-bird-ui-accessible-hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/accessible';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
echo "  - mastodon-bird-ui-accessible-hide-finnish.scss"

# Accessible plus theme
cat > "$STYLES_PATH/mastodon-bird-ui-accessible-plus.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui/layout-single-column';
@use 'mastodon-bird-ui/layout-multiple-columns';
@use 'mastodon-bird-ui/accessible-plus';
EOF
echo "  - mastodon-bird-ui-accessible-plus.scss"

# Update themes.yml
echo ""
echo "Updating themes.yml..."

THEMES_TO_ADD=(
  "mastodon-bird-ui-dark: styles/mastodon-bird-ui-dark.scss"
  "mastodon-bird-ui-dark-change-to-stars: styles/mastodon-bird-ui-dark-change-to-stars.scss"
  "hide-finnish: styles/hide-finnish.scss"
  "hide-finnish-change-to-stars: styles/hide-finnish-change-to-stars.scss"
  "hide-translate-links: styles/hide-translate-links.scss"
  "mastodon-bird-ui-light: styles/mastodon-bird-ui-light.scss"
  "mastodon-bird-ui-light-hide-finnish: styles/mastodon-bird-ui-light-hide-finnish.scss"
  "mastodon-bird-ui-light-hide-finnish-change-to-stars: styles/mastodon-bird-ui-light-hide-finnish-change-to-stars.scss"
  "mastodon-bird-ui-light-hide-translate-links: styles/mastodon-bird-ui-light-hide-translate-links.scss"
  "mastodon-bird-ui-contrast: styles/mastodon-bird-ui-contrast.scss"
  "mastodon-bird-ui-accessible: styles/mastodon-bird-ui-accessible.scss"
  "mastodon-bird-ui-accessible-hide-finnish: styles/mastodon-bird-ui-accessible-hide-finnish.scss"
  "mastodon-bird-ui-accessible-plus: styles/mastodon-bird-ui-accessible-plus.scss"
)

THEMES_ADDED=0
for theme in "${THEMES_TO_ADD[@]}"; do
  theme_name=$(echo "$theme" | cut -d: -f1)
  if ! grep -q "^$theme_name:" "$THEMES_FILE"; then
    echo "$theme" >> "$THEMES_FILE"
    echo -e "${GREEN}  Added: $theme_name${NC}"
    THEMES_ADDED=$((THEMES_ADDED + 1))
  else
    echo -e "${YELLOW}  Already exists: $theme_name${NC}"
  fi
done

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Fix ownership: sudo chown -R mastodon:mastodon $STYLES_PATH"
echo "2. Recompile assets:"
echo "   Production:  RAILS_ENV=production bundle exec rails assets:precompile"
echo "   Development: RAILS_ENV=development bundle exec rails assets:precompile"
echo "3. Restart Mastodon web service"
echo "4. Users can select Bird UI themes in Preferences > Appearance"
