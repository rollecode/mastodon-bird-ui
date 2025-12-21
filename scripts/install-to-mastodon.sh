#!/bin/bash
# Mastodon Bird UI - Install to Mastodon Core
# https://github.com/ronilaukkarinen/mastodon-bird-ui
# Author: Roni Laukkarinen (@rolle@mementomori.social)
#
# This script installs Bird UI to your Mastodon installation
# Usage: sudo bash scripts/install-to-mastodon.sh --path /opt/mastodon

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
MASTODON_PATH="${MASTODON_PATH:-}"
MAKE_DEFAULT=""
ADD_VARIATIONS=""

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
    -d|--default)
      MAKE_DEFAULT="y"
      shift
      ;;
    -v|--variations)
      ADD_VARIATIONS="y"
      shift
      ;;
    -h|--help)
      echo "Usage: sudo bash $0 [-p|--path /path/to/mastodon] [-d|--default] [-v|--variations]"
      echo ""
      echo "Options:"
      echo "  -p, --path        Path to Mastodon installation"
      echo "  -d, --default     Make Bird UI the default system theme (non-interactive)"
      echo "  -v, --variations  Add theme variations (non-interactive)"
      echo "  -h, --help        Show this help message"
      echo ""
      echo "Environment variables:"
      echo "  MASTODON_PATH    Alternative way to specify Mastodon path"
      echo ""
      echo "Examples:"
      echo "  sudo bash $0 --path /opt/mastodon"
      echo "  sudo bash $0 --path /opt/mastodon --default --variations"
      echo "  MASTODON_PATH=/opt/mastodon sudo bash $0"
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

# Ask about making Bird UI the default system theme (if not set via flag)
if [ -z "$MAKE_DEFAULT" ]; then
  echo -e "${YELLOW}Make Bird UI the default theme for 'Automatic (use system theme)'?${NC}"
  echo "This affects guests, logged out users, and users who haven't chosen a theme."
  read -p "Make Bird UI the default? [y/N]: " MAKE_DEFAULT
  MAKE_DEFAULT=${MAKE_DEFAULT:-n}
fi

# Ask about adding theme variations (if not set via flag)
if [ -z "$ADD_VARIATIONS" ]; then
  echo ""
  echo -e "${YELLOW}Add theme variations (stars, hide-finnish, accessible, etc.)?${NC}"
  echo "These add extra theme options for users to choose from."
  read -p "Add theme variations? [y/N]: " ADD_VARIATIONS
  ADD_VARIATIONS=${ADD_VARIATIONS:-n}
fi

echo ""

# Create mastodon-bird-ui directory structure
echo "Creating mastodon-bird-ui/ directory structure..."
rm -rf "$STYLES_PATH/mastodon-bird-ui"
mkdir -p "$STYLES_PATH/mastodon-bird-ui"
mkdir -p "$STYLES_PATH/mastodon-bird-ui/legacy"
mkdir -p "$STYLES_PATH/mastodon-bird-ui/variants"
mkdir -p "$STYLES_PATH/mastodon-bird-ui/components"

# Copy Bird UI files
echo "Copying Bird UI files (existing files will be replaced)..."
cp "$SRC_DIR"/_index.scss "$STYLES_PATH/mastodon-bird-ui/"
cp "$SRC_DIR"/_tokens.scss "$STYLES_PATH/mastodon-bird-ui/"
cp "$SRC_DIR"/_variables-light.scss "$STYLES_PATH/mastodon-bird-ui/"
cp "$SRC_DIR"/legacy/_layout-*.scss "$STYLES_PATH/mastodon-bird-ui/legacy/"
cp "$SRC_DIR"/variants/_*.scss "$STYLES_PATH/mastodon-bird-ui/variants/"
cp "$SRC_DIR"/components/_*.scss "$STYLES_PATH/mastodon-bird-ui/components/"
cp "$SRC_DIR"/micro-interactions/_star.scss "$STYLES_PATH/mastodon-bird-ui/_stars.scss"

# Make Bird UI the default if requested
if [[ "$MAKE_DEFAULT" =~ ^[Yy]$ ]]; then
  echo ""
  echo "Making Bird UI the default system theme..."

  # Update themes.yml: change default to point to Bird UI
  # First, ensure original Mastodon themes are available as separate options
  if ! grep -q "^mastodon-dark:" "$THEMES_FILE"; then
    echo "mastodon-dark: styles/application.scss" >> "$THEMES_FILE"
    echo -e "${GREEN}  Added: mastodon-dark (original Mastodon dark theme)${NC}"
  fi
  if ! grep -q "^mastodon-light:" "$THEMES_FILE"; then
    echo "mastodon-light: styles/mastodon-light.scss" >> "$THEMES_FILE"
    echo -e "${GREEN}  Added: mastodon-light (original Mastodon light theme)${NC}"
  fi

  # Change default to use Bird UI
  if grep -q "^default: styles/application.scss" "$THEMES_FILE"; then
    sed -i 's|^default: styles/application.scss|default: styles/mastodon-bird-ui-dark.scss|' "$THEMES_FILE"
    echo -e "${GREEN}  Updated: default now uses Bird UI${NC}"
  elif grep -q "^default: styles/mastodon-bird-ui-dark.scss" "$THEMES_FILE"; then
    echo -e "${GREEN}  Default already uses Bird UI${NC}"
  else
    echo -e "${YELLOW}  Warning: default theme has unexpected value, not modified${NC}"
  fi
fi

# Generate theme entry points
echo ""
echo "Generating theme entry points (existing files will be replaced)..."

# Bird UI Dark (always created)
cat > "$STYLES_PATH/mastodon-bird-ui-dark.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
EOF
echo "  - mastodon-bird-ui-dark.scss"

# Bird UI Light (always created)
cat > "$STYLES_PATH/mastodon-bird-ui-light.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';
EOF
echo "  - mastodon-bird-ui-light.scss"

# Theme variations (only if requested)
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  echo ""
  echo "Adding theme variations..."

  # Bird UI Dark with stars
  cat > "$STYLES_PATH/mastodon-bird-ui-dark-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/stars';
EOF
  echo "  - mastodon-bird-ui-dark-change-to-stars.scss"

  # Bird UI Dark - Hide Finnish translate
  cat > "$STYLES_PATH/hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
  echo "  - hide-finnish.scss"

  # Bird UI Dark - Hide Finnish with stars
  cat > "$STYLES_PATH/hide-finnish-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/stars';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
  echo "  - hide-finnish-change-to-stars.scss"

  # Bird UI Dark - Hide all translate links
  cat > "$STYLES_PATH/hide-translate-links.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';

.status__content[lang] + .translate-button {
  display: none;
}
EOF
  echo "  - hide-translate-links.scss"

  # Bird UI Light - Hide Finnish
  cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
  echo "  - mastodon-bird-ui-light-hide-finnish.scss"

  # Bird UI Light - Hide Finnish with stars
  cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-finnish-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';
@use 'mastodon-bird-ui/stars';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
  echo "  - mastodon-bird-ui-light-hide-finnish-change-to-stars.scss"

  # Bird UI Light - Hide translate links
  cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-translate-links.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';

.status__content[lang] + .translate-button {
  display: none;
}
EOF
  echo "  - mastodon-bird-ui-light-hide-translate-links.scss"

  # Bird UI Contrast
  cat > "$STYLES_PATH/mastodon-bird-ui-contrast.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui';
EOF
  echo "  - mastodon-bird-ui-contrast.scss"

  # Bird UI Accessible
  cat > "$STYLES_PATH/mastodon-bird-ui-accessible.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible';
EOF
  echo "  - mastodon-bird-ui-accessible.scss"

  # Bird UI Accessible - Hide Finnish
  cat > "$STYLES_PATH/mastodon-bird-ui-accessible-hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible';

.status__content[lang="fi"] + .translate-button {
  display: none;
}
EOF
  echo "  - mastodon-bird-ui-accessible-hide-finnish.scss"

  # Bird UI Accessible Plus
  cat > "$STYLES_PATH/mastodon-bird-ui-accessible-plus.scss" << 'EOF'
@use 'common';
@use 'mastodon/high-contrast';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible-plus';
EOF
  echo "  - mastodon-bird-ui-accessible-plus.scss"
fi

# Fix ownership
echo ""
echo "Fixing file ownership..."
chown -R mastodon:mastodon "$STYLES_PATH/mastodon-bird-ui"
chown mastodon:mastodon "$STYLES_PATH"/mastodon-bird-ui-*.scss 2>/dev/null || true
chown mastodon:mastodon "$STYLES_PATH"/hide-*.scss 2>/dev/null || true

# Update themes.yml
echo ""
echo "Updating themes.yml..."

# Base themes (always added)
BASE_THEMES=(
  "mastodon-bird-ui-dark: styles/mastodon-bird-ui-dark.scss"
  "mastodon-bird-ui-light: styles/mastodon-bird-ui-light.scss"
)

# Variation themes (only if requested)
VARIATION_THEMES=(
  "mastodon-bird-ui-dark-change-to-stars: styles/mastodon-bird-ui-dark-change-to-stars.scss"
  "hide-finnish: styles/hide-finnish.scss"
  "hide-finnish-change-to-stars: styles/hide-finnish-change-to-stars.scss"
  "hide-translate-links: styles/hide-translate-links.scss"
  "mastodon-bird-ui-light-hide-finnish: styles/mastodon-bird-ui-light-hide-finnish.scss"
  "mastodon-bird-ui-light-hide-finnish-change-to-stars: styles/mastodon-bird-ui-light-hide-finnish-change-to-stars.scss"
  "mastodon-bird-ui-light-hide-translate-links: styles/mastodon-bird-ui-light-hide-translate-links.scss"
  "mastodon-bird-ui-contrast: styles/mastodon-bird-ui-contrast.scss"
  "mastodon-bird-ui-accessible: styles/mastodon-bird-ui-accessible.scss"
  "mastodon-bird-ui-accessible-hide-finnish: styles/mastodon-bird-ui-accessible-hide-finnish.scss"
  "mastodon-bird-ui-accessible-plus: styles/mastodon-bird-ui-accessible-plus.scss"
)

# Add base themes
for theme in "${BASE_THEMES[@]}"; do
  theme_name=$(echo "$theme" | cut -d: -f1)
  if ! grep -q "^$theme_name:" "$THEMES_FILE"; then
    echo "$theme" >> "$THEMES_FILE"
    echo -e "${GREEN}  Added: $theme_name${NC}"
  else
    echo -e "${GREEN}  Exists: $theme_name${NC}"
  fi
done

# Add variation themes if requested
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  for theme in "${VARIATION_THEMES[@]}"; do
    theme_name=$(echo "$theme" | cut -d: -f1)
    if ! grep -q "^$theme_name:" "$THEMES_FILE"; then
      echo "$theme" >> "$THEMES_FILE"
      echo -e "${GREEN}  Added: $theme_name${NC}"
    else
      echo -e "${GREEN}  Exists: $theme_name${NC}"
    fi
  done
fi

# Update locale files with theme translations
echo ""
echo "Updating locale files..."

EN_LOCALE="$MASTODON_PATH/config/locales/en.yml"
FI_LOCALE="$MASTODON_PATH/config/locales/fi.yml"

# Base English translations
EN_BASE="    mastodon-bird-ui-dark: Mastodon Bird UI (Dark)
    mastodon-bird-ui-light: Mastodon Bird UI (Light)"

# Variation English translations
EN_VARIATIONS="    mastodon-bird-ui-dark-change-to-stars: Mastodon Bird UI (Dark, Stars)
    hide-finnish: Mastodon Bird UI (Dark, hide translate Finnish link)
    hide-finnish-change-to-stars: Mastodon Bird UI (Dark, Stars, hide translate Finnish link)
    hide-translate-links: Mastodon Bird UI (Dark, hide all Translate links)
    mastodon-bird-ui-light-hide-finnish: Mastodon Bird UI (Light, hide Translate link for Finnish)
    mastodon-bird-ui-light-hide-finnish-change-to-stars: Mastodon Bird UI (Light, Stars, hide Translate link for Finnish)
    mastodon-bird-ui-light-hide-translate-links: Mastodon Bird UI (Light, hide all Translate links)
    mastodon-bird-ui-contrast: Mastodon Bird UI (High contrast)
    mastodon-bird-ui-accessible: Mastodon Bird UI (Ultra accessible)
    mastodon-bird-ui-accessible-hide-finnish: Mastodon Bird UI (Ultra accessible, hide translate link for Finnish)
    mastodon-bird-ui-accessible-plus: Mastodon Bird UI (Ultra accessible Plus+)"

# Base Finnish translations
FI_BASE="    mastodon-bird-ui-dark: Mastodon Bird UI (tumma)
    mastodon-bird-ui-light: Mastodon Bird UI (vaalea)"

# Variation Finnish translations
FI_VARIATIONS="    mastodon-bird-ui-dark-change-to-stars: Mastodon Bird UI (tumma, tähdet)
    hide-finnish: Mastodon Bird UI (tumma, piilota Käännä-linkit suomen kielelle)
    hide-finnish-change-to-stars: Mastodon Bird UI (tumma, Tähdet, piilota Käännä-linkit suomen kielelle)
    hide-translate-links: Mastodon Bird UI (tumma, piilota kaikki käännöslinkit)
    mastodon-bird-ui-light-hide-finnish: Mastodon Bird UI (vaalea, piilota Käännä-linkit suomen kielelle)
    mastodon-bird-ui-light-hide-finnish-change-to-stars: Mastodon Bird UI (vaalea, Tähdet, piilota Käännä-linkit suomen kielelle)
    mastodon-bird-ui-light-hide-translate-links: Mastodon Bird UI (vaalea, piilota kaikki käännöslinkit)
    mastodon-bird-ui-contrast: Mastodon Bird UI (suuri kontrasti)
    mastodon-bird-ui-accessible: Mastodon Bird UI (saavutettavuus huomioitu)
    mastodon-bird-ui-accessible-hide-finnish: Mastodon Bird UI (saavutettavuus huomioitu, piilota Käännä-linkit suomelle)
    mastodon-bird-ui-accessible-plus: Mastodon Bird UI (saavutettavuus Plus, fontit vielä isommalla)"

# Original Mastodon theme translations (when Bird UI is made default)
EN_ORIGINAL="    mastodon-dark: Mastodon (Dark)
    mastodon-light: Mastodon (Light)"

FI_ORIGINAL="    mastodon-dark: Mastodon (tumma)
    mastodon-light: Mastodon (vaalea)"

# Build the themes to add
EN_THEMES="$EN_BASE"
FI_THEMES="$FI_BASE"

if [[ "$MAKE_DEFAULT" =~ ^[Yy]$ ]]; then
  EN_THEMES="$EN_THEMES
$EN_ORIGINAL"
  FI_THEMES="$FI_THEMES
$FI_ORIGINAL"
fi

if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  EN_THEMES="$EN_THEMES
$EN_VARIATIONS"
  FI_THEMES="$FI_THEMES
$FI_VARIATIONS"
fi

# Add English translations
if [ -f "$EN_LOCALE" ]; then
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    theme_key=$(echo "$line" | sed 's/:.*//' | xargs)
    if ! grep -q "^    $theme_key:" "$EN_LOCALE"; then
      sed -i "/^  themes:/a\\$line" "$EN_LOCALE"
      echo -e "${GREEN}  Added to en.yml: $theme_key${NC}"
    else
      echo -e "${GREEN}  Exists in en.yml: $theme_key${NC}"
    fi
  done <<< "$EN_THEMES"
fi

# Add Finnish translations
if [ -f "$FI_LOCALE" ]; then
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    theme_key=$(echo "$line" | sed 's/:.*//' | xargs)
    if ! grep -q "^    $theme_key:" "$FI_LOCALE"; then
      sed -i "/^  themes:/a\\$line" "$FI_LOCALE"
      echo -e "${GREEN}  Added to fi.yml: $theme_key${NC}"
    else
      echo -e "${GREEN}  Exists in fi.yml: $theme_key${NC}"
    fi
  done <<< "$FI_THEMES"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Summary:"
if [[ "$MAKE_DEFAULT" =~ ^[Yy]$ ]]; then
  echo -e "  ${GREEN}✓${NC} Bird UI is now the default system theme"
fi
echo -e "  ${GREEN}✓${NC} Base themes installed (Dark, Light)"
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  echo -e "  ${GREEN}✓${NC} Theme variations installed"
fi
echo ""
echo "Next steps:"
echo "1. Recompile assets:"
echo "   Production:  RAILS_ENV=production bundle exec rails assets:precompile"
echo "   Development: RAILS_ENV=development bundle exec rails assets:precompile"
echo "2. Restart Mastodon web service"
echo "3. Users can select Bird UI themes in Preferences > Appearance"
if [[ "$MAKE_DEFAULT" =~ ^[Yy]$ ]]; then
  echo ""
  echo "Note: 'Automatic (use system theme)' will now use Bird UI for all users."
fi
