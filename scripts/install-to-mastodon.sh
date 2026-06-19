#!/bin/bash
# Mastodon Bird UI - Install to Mastodon Core
# https://github.com/ronilaukkarinen/mastodon-bird-ui
# Author: Roni Laukkarinen (@rolle@mementomori.social)
#
# This script installs/updates Bird UI files in your Mastodon installation.
# It is idempotent - safe to run multiple times. It will:
#   - Copy/update all Bird UI module files
#   - Ensure entry point SCSS files exist (creates missing ones, preserves existing)
#   - Rebuild themes.yml from scratch (removes stale entries pointing to missing files)
#   - Ensure locale entries exist
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
SET_DEFAULT=""

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
    -d|--default)
      SET_DEFAULT="y"
      shift
      ;;
    -h|--help)
      echo "Usage: sudo bash $0 [-p|--path /path/to/mastodon] [-v|--variations]"
      echo ""
      echo "This script is idempotent - safe to run repeatedly."
      echo "It ensures Bird UI is correctly installed regardless of prior state."
      echo ""
      echo "Options:"
      echo "  -p, --path        Path to Mastodon installation"
      echo "  -v, --variations  Add accessible theme variations (contrast, accessible, accessible-plus)"
      echo "  -d, --default     Set Mastodon Bird UI (Dark) as the server default theme"
      echo "  -h, --help        Show this help message"
      echo ""
      echo "Examples:"
      echo "  # Install or update Bird UI:"
      echo "  sudo bash $0 --path /opt/mastodon"
      echo ""
      echo "  # Install with all variations:"
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

# Detect a native favourite animation. Some forks (mementomori.social) ship their
# own favourite star/heart SVG with its own burst, see
# https://github.com/mementomori-social/mastodon/pull/10. When that is present we
# must not let Bird UI restyle the favourite button, so the native animation shows.
NATIVE_FAVOURITES="n"
if [ -f "$MASTODON_PATH/app/javascript/mastodon/components/favourite_star.tsx" ]; then
  NATIVE_FAVOURITES="y"
  echo -e "${YELLOW}Native favourite animation detected; Bird UI will not restyle the favourite button.${NC}"
  echo ""
fi

# Ask about variations if not specified via flag
if [ -z "$ADD_VARIATIONS" ]; then
  read -p "Add/update accessible theme variations (contrast, accessible, accessible-plus)? [y/N]: " ADD_VARIATIONS
  ADD_VARIATIONS=${ADD_VARIATIONS:-n}
fi

# --- Step 1: Copy module files ---
echo -e "${BLUE}[1/4] Updating Bird UI module files...${NC}"

mkdir -p "$BIRD_UI_PATH"
mkdir -p "$BIRD_UI_PATH/components"
mkdir -p "$BIRD_UI_PATH/components/profile"
mkdir -p "$BIRD_UI_PATH/components/profile/icons"
mkdir -p "$BIRD_UI_PATH/layouts"
mkdir -p "$BIRD_UI_PATH/micro-interactions"
mkdir -p "$BIRD_UI_PATH/variables"
mkdir -p "$BIRD_UI_PATH/variants"

copy_if_exists() {
  local src="$1"
  local dest="$2"
  if [ -f "$src" ]; then
    cp "$src" "$dest"
    echo -e "  ${GREEN}Updated:${NC} $(basename "$dest")"
    return 0
  fi
  return 0
}

# Core module files
copy_if_exists "$SRC_DIR/_index.scss" "$BIRD_UI_PATH/_index.scss"

# Variables
for f in "$SRC_DIR/variables/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/variables/$(basename "$f")"
done

# Components
for f in "$SRC_DIR/components/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/components/$(basename "$f")"
done

# Profile components
for f in "$SRC_DIR/components/profile/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/components/profile/$(basename "$f")"
done

# Profile icons
for f in "$SRC_DIR/components/profile/icons/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/components/profile/icons/$(basename "$f")"
done

# Layouts
for f in "$SRC_DIR/layouts/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/layouts/$(basename "$f")"
done

# Micro-interactions
# The favourite restyling lives in _heart.scss and _star.scss. When the target
# ships a native favourite animation we swap both for _native-favourites.scss,
# which drops the favourite styling and only re-shows Mastodon's default icons
# (Bird UI's icon reset would otherwise hide them). Navigation/layout that used
# to be bundled in _heart.scss now lives in components/_mobile-navigation.scss,
# so it is unaffected.
for f in "$SRC_DIR/micro-interactions/"_*.scss; do
  [ -f "$f" ] || continue
  base=$(basename "$f")
  if [[ "$NATIVE_FAVOURITES" =~ ^[Yy]$ && ( "$base" == "_heart.scss" || "$base" == "_star.scss" ) ]]; then
    cp "$SRC_DIR/micro-interactions/_native-favourites.scss" "$BIRD_UI_PATH/micro-interactions/$base"
    echo -e "  ${YELLOW}Native favourites:${NC} $base (Bird UI favourite styling dropped)"
  else
    copy_if_exists "$f" "$BIRD_UI_PATH/micro-interactions/$base"
  fi
done

# Variants
for f in "$SRC_DIR/variants/"_*.scss; do
  [ -f "$f" ] && copy_if_exists "$f" "$BIRD_UI_PATH/variants/$(basename "$f")"
done

# Create entry point inside module for Custom CSS build compatibility
cat > "$BIRD_UI_PATH/mastodon-bird-ui.scss" << 'EOF'
@use "index";
EOF

echo -e "${GREEN}Module files updated.${NC}"

# --- Step 2: Ensure entry point SCSS files exist ---
echo ""
echo -e "${BLUE}[2/4] Ensuring entry point SCSS files...${NC}"

# Helper: create entry point only if missing (preserves any local edits)
ensure_entry_point() {
  local file="$1"
  local content="$2"
  local name
  name=$(basename "$file")
  echo "$content" > "$file"
  echo -e "  ${GREEN}Updated:${NC} $name"
}

# Auto bundle - respects data-color-scheme attribute and prefers-color-scheme.
# Replaces the old separate Dark/Light theme entries; Mastodon's Appearance
# radios drive the scheme.
ensure_entry_point "$STYLES_PATH/mastodon-bird-ui-auto.scss" "@use 'application';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variables/light-mixin' as light;

[data-color-scheme=\"light\"] {
  @include light.tokens;
}

@media (prefers-color-scheme: light) {
  html:not([data-color-scheme]) {
    @include light.tokens;
  }
}"

# Variation entry points
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  echo ""
  echo "  Creating variation entry points..."

  ensure_entry_point "$STYLES_PATH/mastodon-bird-ui-accessible.scss" "@use 'application';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible';"

  cat > "$BIRD_UI_PATH/mastodon-bird-ui-accessible.scss" << 'EOF'
@use "index";
@use "variants/accessible";
EOF

  ensure_entry_point "$STYLES_PATH/mastodon-bird-ui-accessible-plus.scss" "@use 'application';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible-plus';"

  cat > "$BIRD_UI_PATH/mastodon-bird-ui-accessible-plus.scss" << 'EOF'
@use "index";
@use "variants/accessible-plus";
EOF
fi

# --- Step 3: Rebuild themes.yml ---
if [ -z "$SET_DEFAULT" ]; then
  read -p "Set Mastodon Bird UI (Dark) as the server default theme? [y/N]: " SET_DEFAULT
  SET_DEFAULT=${SET_DEFAULT:-n}
fi

echo ""
echo -e "${BLUE}[3/4] Rebuilding themes.yml...${NC}"

# Helper: add a theme entry, verifying the SCSS file actually exists
add_theme_entry() {
  local key="$1"
  local value="$2"
  local scss_file="$MASTODON_PATH/app/javascript/$value"
  if [ -f "$scss_file" ]; then
    echo "${key}: ${value}" >> "$THEMES_FILE"
    echo -e "  ${GREEN}Added:${NC} $key"
  else
    echo -e "  ${YELLOW}Skipped:${NC} $key (${value} not found)"
  fi
}

# Set default theme entry
if [[ "$SET_DEFAULT" =~ ^[Yy]$ ]]; then
  echo "default: styles/mastodon-bird-ui-auto.scss" > "$THEMES_FILE"
  echo -e "  ${GREEN}Set:${NC} default: styles/mastodon-bird-ui-auto.scss (Bird UI)"
  add_theme_entry "mastodon-dark" "styles/application.scss"
else
  echo "default: styles/application.scss" > "$THEMES_FILE"
  echo -e "  ${GREEN}Set:${NC} default: styles/application.scss"
  add_theme_entry "mastodon-bird-ui-auto" "styles/mastodon-bird-ui-auto.scss"
fi

# Bird UI variations
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  add_theme_entry "mastodon-bird-ui-accessible" "styles/mastodon-bird-ui-accessible.scss"
  add_theme_entry "mastodon-bird-ui-accessible-plus" "styles/mastodon-bird-ui-accessible-plus.scss"
fi

# --- Step 4: Update locale files ---
echo ""
echo -e "${BLUE}[4/4] Updating locale files...${NC}"

EN_LOCALE="$MASTODON_PATH/config/locales/en.yml"
FI_LOCALE="$MASTODON_PATH/config/locales/fi.yml"

# Clean up stale locale entries from old theme system (removed in Mastodon #37612)
remove_stale_locale_entry() {
  local file="$1"
  local key="$2"
  local lang="$3"

  [ ! -f "$file" ] && return

  if grep -q "^    ${key}:" "$file"; then
    sed -i "/^    ${key}:/d" "$file"
    echo -e "  ${YELLOW}Removed from $lang:${NC} $key (stale)"
  fi
}

STALE_THEME_KEYS="mastodon-dark mastodon-light contrast system mastodon-bird-ui-dark mastodon-bird-ui-light mastodon-bird-ui-contrast mastodon-bird-ui-dark-change-to-stars hide-finnish hide-finnish-change-to-stars hide-translate-links mastodon-bird-ui-light-hide-finnish mastodon-bird-ui-light-hide-finnish-change-to-stars mastodon-bird-ui-light-hide-translate-links mastodon-bird-ui-accessible-hide-finnish"

for locale_file in "$EN_LOCALE" "$FI_LOCALE"; do
  [ ! -f "$locale_file" ] && continue
  lang=$(basename "$locale_file")
  for stale_key in $STALE_THEME_KEYS; do
    remove_stale_locale_entry "$locale_file" "$stale_key" "$lang"
  done
done

# Set the 'default' locale label based on whether Bird UI is the default theme
if [[ "$SET_DEFAULT" =~ ^[Yy]$ ]]; then
  sed -i "s/^    default: Mastodon.*/    default: Mastodon Bird UI/" "$EN_LOCALE"
  sed -i "s/^    default: Mastodon.*/    default: Mastodon Bird UI/" "$FI_LOCALE"
  echo -e "  ${GREEN}Set:${NC} default locale -> Mastodon Bird UI"
else
  sed -i "s/^    default: Mastodon Bird UI.*/    default: Mastodon/" "$EN_LOCALE" 2>/dev/null
  sed -i "s/^    default: Mastodon Bird UI.*/    default: Mastodon/" "$FI_LOCALE" 2>/dev/null
fi

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

# Core theme locale entries
if [[ "$SET_DEFAULT" =~ ^[Yy]$ ]]; then
  # Bird UI is default, so add locale for the stock Mastodon theme
  add_locale_entry "$EN_LOCALE" "mastodon-dark" "Mastodon" "en.yml"
  add_locale_entry "$FI_LOCALE" "mastodon-dark" "Mastodon" "fi.yml"
else
  add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-auto" "Mastodon Bird UI" "en.yml"
  add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-auto" "Mastodon Bird UI" "fi.yml"
fi

# Variation locale entries
if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-accessible" "Mastodon Bird UI (Accessible)" "en.yml"
  add_locale_entry "$EN_LOCALE" "mastodon-bird-ui-accessible-plus" "Mastodon Bird UI (Accessible Plus)" "en.yml"

  add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-accessible" "Mastodon Bird UI (saavutettava)" "fi.yml"
  add_locale_entry "$FI_LOCALE" "mastodon-bird-ui-accessible-plus" "Mastodon Bird UI (saavutettava Plus)" "fi.yml"
fi

# --- Fix ownership and permissions ---
echo ""
echo "Fixing file ownership and permissions..."
chmod -R a+r "$BIRD_UI_PATH"
find "$BIRD_UI_PATH" -type d -exec chmod a+rx {} \;
chown -R mastodon:mastodon "$BIRD_UI_PATH"
chown mastodon:mastodon "$STYLES_PATH"/mastodon-bird-ui-*.scss 2>/dev/null || true
chown mastodon:mastodon "$STYLES_PATH"/hide-*.scss 2>/dev/null || true
chown mastodon:mastodon "$THEMES_FILE"

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo "themes.yml contents:"
cat "$THEMES_FILE"
echo ""
echo "Next steps:"
echo "  cd $MASTODON_PATH"
echo "  RAILS_ENV=development bundle exec rails assets:precompile && sudo systemctl restart mastodon-web"
