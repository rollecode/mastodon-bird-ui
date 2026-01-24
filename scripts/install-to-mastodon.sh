#!/bin/bash
# Mastodon Bird UI - Install to Mastodon Core
# https://github.com/ronilaukkarinen/mastodon-bird-ui
# Author: Roni Laukkarinen (@rolle@mementomori.social)
#
# This script installs/updates Bird UI files in your Mastodon installation.
# It only updates module files, preserving existing entry points and config.
#
# Usage: sudo bash scripts/install-to-mastodon.sh --path /opt/mastodon

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
MASTODON_PATH="${MASTODON_PATH:-}"
ADD_VARIATIONS=""

# Get script directory and version
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
    -v|--variations)
      ADD_VARIATIONS="y"
      shift
      ;;
    -h|--help)
      echo "Usage: sudo bash $0 [-p|--path /path/to/mastodon] [-v|--variations]"
      echo ""
      echo "The script auto-detects installation status:"
      echo "  - New install: Creates entry points and updates themes.yml/locales"
      echo "  - Existing install: Only updates module files (preserves entry points)"
      echo ""
      echo "Options:"
      echo "  -p, --path        Path to Mastodon installation"
      echo "  -v, --variations  Add theme variations (stars, hide-finnish, accessible, etc.)"
      echo "  -h, --help        Show this help message"
      echo ""
      echo "Examples:"
      echo "  # Install or update Bird UI:"
      echo "  sudo bash $0 --path /opt/mastodon"
      echo ""
      echo "  # Fresh install with all variations:"
      echo "  sudo bash $0 --path /opt/mastodon --variations"
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
  read -p "Enter your Mastodon installation path: " MASTODON_PATH
fi

# Validate Mastodon path
if [ ! -d "$MASTODON_PATH" ]; then
  echo -e "${RED}Error: Directory not found: $MASTODON_PATH${NC}"
  exit 1
fi

STYLES_PATH="$MASTODON_PATH/app/javascript/styles"
THEMES_FILE="$MASTODON_PATH/config/themes.yml"
BIRD_UI_PATH="$STYLES_PATH/mastodon-bird-ui"

if [ ! -d "$STYLES_PATH" ]; then
  echo -e "${RED}Error: Styles directory not found: $STYLES_PATH${NC}"
  exit 1
fi

if [ ! -f "$THEMES_FILE" ]; then
  echo -e "${RED}Error: themes.yml not found: $THEMES_FILE${NC}"
  exit 1
fi

echo -e "${GREEN}Mastodon Bird UI $VERSION${NC}"
echo ""

# Check if Bird UI is already installed
if [ -d "$BIRD_UI_PATH" ]; then
  echo -e "${BLUE}Existing Bird UI installation detected.${NC}"
  echo "Updating module files only (entry points and config preserved)..."
  UPDATE_MODE="y"
else
  echo -e "${BLUE}No existing Bird UI installation found. Running full setup...${NC}"
  SETUP_NEW="y"
  UPDATE_MODE=""
fi

echo ""

# Create directory structure if needed
mkdir -p "$BIRD_UI_PATH"
mkdir -p "$BIRD_UI_PATH/components"
mkdir -p "$BIRD_UI_PATH/layouts"
mkdir -p "$BIRD_UI_PATH/legacy"
mkdir -p "$BIRD_UI_PATH/micro-interactions"
mkdir -p "$BIRD_UI_PATH/variables"
mkdir -p "$BIRD_UI_PATH/variants"

echo "Updating Bird UI module files..."

# Copy partial files (files starting with _) - these are the actual styles
copy_if_exists() {
  local src="$1"
  local dest="$2"
  if [ -f "$src" ]; then
    cp "$src" "$dest"
    echo -e "  ${GREEN}Updated:${NC} $(basename "$dest")"
    return 0
  fi
  return 1
}

# Core module files
copy_if_exists "$SRC_DIR/_index.scss" "$BIRD_UI_PATH/_index.scss"
copy_if_exists "$SRC_DIR/_base.scss" "$BIRD_UI_PATH/_base.scss"
copy_if_exists "$SRC_DIR/_variables-light.scss" "$BIRD_UI_PATH/_variables-light.scss"

# Variables
for f in "$SRC_DIR/variables/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/variables/$(basename "$f")"
done

# Components
for f in "$SRC_DIR/components/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/components/$(basename "$f")"
done

# Layouts
for f in "$SRC_DIR/layouts/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/layouts/$(basename "$f")"
done

# Legacy layouts
for f in "$SRC_DIR/legacy/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/legacy/$(basename "$f")"
done

# Micro-interactions
for f in "$SRC_DIR/micro-interactions/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/micro-interactions/$(basename "$f")"
done

# Create _stars.scss alias at module root (for @use 'mastodon-bird-ui/stars')
if [ -f "$SRC_DIR/micro-interactions/_star.scss" ]; then
  cp "$SRC_DIR/micro-interactions/_star.scss" "$BIRD_UI_PATH/_stars.scss"
  echo -e "  ${GREEN}Updated:${NC} _stars.scss (star animation alias)"
fi

# Variants
for f in "$SRC_DIR/variants/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/variants/$(basename "$f")"
done

echo -e "${GREEN}Module files updated.${NC}"

# Ask about variations if not specified
if [ -z "$ADD_VARIATIONS" ]; then
  read -p "Add/update theme variations (stars, hide-finnish, accessible, etc.)? [y/N]: " ADD_VARIATIONS
  ADD_VARIATIONS=${ADD_VARIATIONS:-n}
fi

# Full setup mode - create entry points and update config
if [[ "$SETUP_NEW" =~ ^[Yy]$ ]] && [ -z "$UPDATE_MODE" ]; then
  echo ""
  echo "Setting up entry points and configuration..."

  # Create theme entry points in styles root
  echo ""
  echo "Creating theme entry points..."

  cat > "$STYLES_PATH/mastodon-bird-ui-dark.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
EOF
  echo "  - mastodon-bird-ui-dark.scss"

  cat > "$STYLES_PATH/mastodon-bird-ui-light.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';
EOF
  echo "  - mastodon-bird-ui-light.scss"

  # Create entry points inside module for Custom CSS build compatibility
  cat > "$BIRD_UI_PATH/mastodon-bird-ui.scss" << 'EOF'
@use "index";
EOF
fi

# Create/update variations (both new install and update mode)
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Creating theme variations..."

    # Stars variant
    cat > "$STYLES_PATH/mastodon-bird-ui-dark-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/stars';
EOF
    echo "  - mastodon-bird-ui-dark-change-to-stars.scss"

    cat > "$BIRD_UI_PATH/mastodon-bird-ui-stars.scss" << 'EOF'
@use "index";
@use "stars";
EOF

    # Hide Finnish
    cat > "$STYLES_PATH/hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';

.status__content__text[lang="fi"] ~ .status__content__translate-button {
  display: none;
}
EOF
    echo "  - hide-finnish.scss"

    cat > "$STYLES_PATH/hide-finnish-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/stars';

.status__content__text[lang="fi"] ~ .status__content__translate-button {
  display: none;
}
EOF
    echo "  - hide-finnish-change-to-stars.scss"

    # Hide translate links
    cat > "$STYLES_PATH/hide-translate-links.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';

.status__content__text[lang] ~ .status__content__translate-button {
  display: none;
}
EOF
    echo "  - hide-translate-links.scss"

    # Light variants
    cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';
@use 'mastodon-bird-ui/variants/hide-finnish';
EOF
    echo "  - mastodon-bird-ui-light-hide-finnish.scss"

    cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-finnish-change-to-stars.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';
@use 'mastodon-bird-ui/stars';
@use 'mastodon-bird-ui/variants/hide-finnish';
EOF
    echo "  - mastodon-bird-ui-light-hide-finnish-change-to-stars.scss"

    cat > "$STYLES_PATH/mastodon-bird-ui-light-hide-translate-links.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables-light';
@use 'mastodon-bird-ui/variants/hide-translate-links';
EOF
    echo "  - mastodon-bird-ui-light-hide-translate-links.scss"

    # High contrast / Accessible variants
    cat > "$STYLES_PATH/mastodon-bird-ui-contrast.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
EOF
    echo "  - mastodon-bird-ui-contrast.scss"

    cat > "$STYLES_PATH/mastodon-bird-ui-accessible.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible';
EOF
    echo "  - mastodon-bird-ui-accessible.scss"

    cat > "$BIRD_UI_PATH/mastodon-bird-ui-accessible.scss" << 'EOF'
@use "index";
@use "variants/accessible";
EOF

    cat > "$STYLES_PATH/mastodon-bird-ui-accessible-hide-finnish.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible';
@use 'mastodon-bird-ui/variants/hide-finnish';
EOF
    echo "  - mastodon-bird-ui-accessible-hide-finnish.scss"

    cat > "$BIRD_UI_PATH/mastodon-bird-ui-accessible-hide-finnish.scss" << 'EOF'
@use "index";
@use "variants/accessible";
@use "variants/hide-finnish";
EOF

    cat > "$STYLES_PATH/mastodon-bird-ui-accessible-plus.scss" << 'EOF'
@use 'common';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible-plus';
EOF
    echo "  - mastodon-bird-ui-accessible-plus.scss"

    cat > "$BIRD_UI_PATH/mastodon-bird-ui-accessible-plus.scss" << 'EOF'
@use "index";
@use "variants/accessible-plus";
EOF
fi

# Update themes.yml (for both new and update modes)
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]] || [ -z "$UPDATE_MODE" ]; then
  echo ""
  echo "Updating themes.yml..."
  cp "$THEMES_FILE" "$THEMES_FILE.bak"

  add_theme_entry() {
    local key="$1"
    local value="$2"
    if ! grep -q "^${key}:" "$THEMES_FILE"; then
      echo "${key}: ${value}" >> "$THEMES_FILE"
      echo -e "  ${GREEN}Added:${NC} $key"
    fi
  }

  if [ -z "$UPDATE_MODE" ]; then
    add_theme_entry "mastodon-bird-ui-dark" "styles/mastodon-bird-ui-dark.scss"
    add_theme_entry "mastodon-bird-ui-light" "styles/mastodon-bird-ui-light.scss"
  fi

  if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
    add_theme_entry "mastodon-bird-ui-dark-change-to-stars" "styles/mastodon-bird-ui-dark-change-to-stars.scss"
    add_theme_entry "hide-finnish" "styles/hide-finnish.scss"
    add_theme_entry "hide-finnish-change-to-stars" "styles/hide-finnish-change-to-stars.scss"
    add_theme_entry "hide-translate-links" "styles/hide-translate-links.scss"
    add_theme_entry "mastodon-bird-ui-light-hide-finnish" "styles/mastodon-bird-ui-light-hide-finnish.scss"
    add_theme_entry "mastodon-bird-ui-light-hide-finnish-change-to-stars" "styles/mastodon-bird-ui-light-hide-finnish-change-to-stars.scss"
    add_theme_entry "mastodon-bird-ui-light-hide-translate-links" "styles/mastodon-bird-ui-light-hide-translate-links.scss"
    add_theme_entry "mastodon-bird-ui-contrast" "styles/mastodon-bird-ui-contrast.scss"
    add_theme_entry "mastodon-bird-ui-accessible" "styles/mastodon-bird-ui-accessible.scss"
    add_theme_entry "mastodon-bird-ui-accessible-hide-finnish" "styles/mastodon-bird-ui-accessible-hide-finnish.scss"
    add_theme_entry "mastodon-bird-ui-accessible-plus" "styles/mastodon-bird-ui-accessible-plus.scss"
  fi

  # Update locale files
  echo ""
  echo "Updating locale files..."

  EN_LOCALE="$MASTODON_PATH/config/locales/en.yml"
  FI_LOCALE="$MASTODON_PATH/config/locales/fi.yml"

  add_locale_entry() {
    local file="$1"
    local key="$2"
    local value="$3"
    local lang="$4"

    [ ! -f "$file" ] && return

    if ! grep -q "^    ${key}:" "$file"; then
      if grep -q "^  themes:" "$file"; then
        sed -i "/^  themes:/a\\    ${key}: ${value}" "$file"
        echo -e "  ${GREEN}Added to $lang:${NC} $key"
      fi
    fi
  }

  if [ -z "$UPDATE_MODE" ]; then
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-dark" "Mastodon Bird UI (Dark)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-light" "Mastodon Bird UI (Light)" "en.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-dark" "Mastodon Bird UI (tumma)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-light" "Mastodon Bird UI (vaalea)" "fi.yml"
  fi

  if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-dark-change-to-stars" "Mastodon Bird UI (Dark, Stars)" "en.yml"
    add_locale_entry "$EN_LOCALE" "hide-finnish" "Mastodon Bird UI (Dark, hide translate Finnish link)" "en.yml"
    add_locale_entry "$EN_LOCALE" "hide-finnish-change-to-stars" "Mastodon Bird UI (Dark, Stars, hide translate Finnish link)" "en.yml"
    add_locale_entry "$EN_LOCALE" "hide-translate-links" "Mastodon Bird UI (Dark, hide all Translate links)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-light-hide-finnish" "Mastodon Bird UI (Light, hide Finnish)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-light-hide-finnish-change-to-stars" "Mastodon Bird UI (Light, Stars, hide Finnish)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-light-hide-translate-links" "Mastodon Bird UI (Light, hide Translate links)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-contrast" "Mastodon Bird UI (High contrast)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-accessible" "Mastodon Bird UI (Accessible)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-accessible-hide-finnish" "Mastodon Bird UI (Accessible, hide Finnish)" "en.yml"
    add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-accessible-plus" "Mastodon Bird UI (Accessible Plus)" "en.yml"

    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-dark-change-to-stars" "Mastodon Bird UI (tumma, tähdet)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "hide-finnish" "Mastodon Bird UI (tumma, piilota käännös suomelle)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "hide-finnish-change-to-stars" "Mastodon Bird UI (tumma, tähdet, piilota käännös suomelle)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "hide-translate-links" "Mastodon Bird UI (tumma, piilota käännöslinkit)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-light-hide-finnish" "Mastodon Bird UI (vaalea, piilota käännös suomelle)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-light-hide-finnish-change-to-stars" "Mastodon Bird UI (vaalea, tähdet, piilota käännös suomelle)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-light-hide-translate-links" "Mastodon Bird UI (vaalea, piilota käännöslinkit)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-contrast" "Mastodon Bird UI (suuri kontrasti)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-accessible" "Mastodon Bird UI (saavutettava)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-accessible-hide-finnish" "Mastodon Bird UI (saavutettava, piilota käännös suomelle)" "fi.yml"
    add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-accessible-plus" "Mastodon Bird UI (saavutettava Plus)" "fi.yml"
  fi
fi

# Fix ownership and permissions
echo ""
echo "Fixing file ownership and permissions..."
chmod -R a+r "$BIRD_UI_PATH"
find "$BIRD_UI_PATH" -type d -exec chmod a+rx {} \;
chown -R mastodon:mastodon "$BIRD_UI_PATH"
chown mastodon:mastodon "$STYLES_PATH"/mastodon-bird-ui-*.scss 2>/dev/null || true
chown mastodon:mastodon "$STYLES_PATH"/hide-*.scss 2>/dev/null || true

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo "Next steps:"
echo "1. Recompile assets:"
echo "   cd $MASTODON_PATH"
echo "   RAILS_ENV=production bundle exec rails assets:precompile"
echo "2. Restart Mastodon web service"
