#!/bin/bash
# Mastodon Bird UI - Install to Mastodon Core
# https://github.com/ronilaukkarinen/mastodon-bird-ui
# Author: Roni Laukkarinen (@rolle@mementomori.social)
#
# This script copies Bird UI files to your Mastodon installation

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

# Check if dist/mastodon-core exists
DIST_DIR="$SCRIPT_DIR/../dist/mastodon-core"

if [ ! -d "$DIST_DIR" ]; then
  echo -e "${YELLOW}dist/mastodon-core not found. Building...${NC}"
  cd "$SCRIPT_DIR/.."
  npm run build:mastodon-core
  cd -
fi

echo -e "${GREEN}This will install Mastodon Bird UI $VERSION to $MASTODON_PATH${NC}"
echo ""

# Copy mastodon-bird-ui folder
echo "Copying mastodon-bird-ui/ to $STYLES_PATH/"
cp -r "$DIST_DIR/mastodon-bird-ui" "$STYLES_PATH/"

# Copy theme entry points
echo "Copying theme entry points..."
for f in "$DIST_DIR"/*.scss; do
  filename=$(basename "$f")
  echo "  - $filename"
  cp "$f" "$STYLES_PATH/"
done

# Check if themes are already in themes.yml
echo ""
echo "Checking themes.yml..."

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
    echo -e "${GREEN}Added: $theme_name${NC}"
    THEMES_ADDED=$((THEMES_ADDED + 1))
  else
    echo -e "${YELLOW}Already exists: $theme_name${NC}"
  fi
done

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""

if [ $THEMES_ADDED -gt 0 ]; then
  echo "Next steps:"
  echo "1. Restart your Mastodon web service"
  echo "2. Recompile assets: RAILS_ENV=production bundle exec rails assets:precompile"
  echo "3. Users can now select Bird UI themes in Preferences > Appearance"
else
  echo "All themes were already installed."
  echo "If you updated Bird UI, recompile assets:"
  echo "RAILS_ENV=production bundle exec rails assets:precompile"
fi
