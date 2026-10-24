#!/bin/bash
# Mastodon Bird UI - Install to Mastodon 5
# https://github.com/rollecode/mastodon-bird-ui
# Author: Rolle Laukkarinen (@rolle@mementomori.social)
#
# Installs or updates Bird UI as site themes. Safe to run repeatedly:
#   - Replaces the Bird UI module files
#   - Writes the theme entry point SCSS files
#   - Rebuilds themes.yml, keeping other installed themes whose files exist
#   - Adds the theme names to the locale files
#
# Usage: sudo bash scripts/install-to-mastodon.sh --path /opt/mastodon

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MASTODON_PATH="${MASTODON_PATH:-}"
ADD_VARIATIONS=""
SET_DEFAULT=""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../src"
VERSION=$(grep -m1 '^### ' "$SCRIPT_DIR/../CHANGELOG.md" | sed 's/### \([^:]*\):.*/\1/')

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
      echo "Usage: sudo bash $0 [-p|--path /path/to/mastodon] [-v|--variations] [-d|--default]"
      echo ""
      echo "Options:"
      echo "  -p, --path        Path to Mastodon installation"
      echo "  -v, --variations  Add the accessible themes (Ultra accessible, Ultra accessible Plus+)"
      echo "  -d, --default     Set Mastodon Bird UI as the server default theme"
      echo "  -h, --help        Show this help message"
      echo ""
      echo "Examples:"
      echo "  sudo bash $0 --path /opt/mastodon"
      echo "  sudo bash $0 --path /opt/mastodon --variations --default"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

if [ -z "$MASTODON_PATH" ]; then
  echo -e "${YELLOW}Mastodon path not specified.${NC}"
  read -p "Enter your Mastodon installation path: " MASTODON_PATH
fi

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

if [ ! -d "$STYLES_PATH/mastodon/tokens" ]; then
  echo -e "${RED}Error: This version of Bird UI needs Mastodon 5. For Mastodon 4, use the main branch.${NC}"
  exit 1
fi

echo -e "${GREEN}Mastodon Bird UI $VERSION${NC}"
echo ""

if [ -z "$ADD_VARIATIONS" ]; then
  read -p "Add the accessible themes (Ultra accessible, Ultra accessible Plus+)? [y/N]: " ADD_VARIATIONS
  ADD_VARIATIONS=${ADD_VARIATIONS:-n}
fi

if [ -z "$SET_DEFAULT" ]; then
  read -p "Set Mastodon Bird UI as the server default theme? [y/N]: " SET_DEFAULT
  SET_DEFAULT=${SET_DEFAULT:-n}
fi

# --- Step 1: Module files ---
echo -e "${BLUE}[1/4] Updating Bird UI module files...${NC}"

# Start clean so files removed from Bird UI do not linger
rm -rf "$BIRD_UI_PATH"
mkdir -p "$BIRD_UI_PATH"
cp "$SRC_DIR/_index.scss" "$BIRD_UI_PATH/"
for dir in components micro-interactions variables variants; do
  cp -r "$SRC_DIR/$dir" "$BIRD_UI_PATH/"
done

echo -e "${GREEN}Module files updated.${NC}"

# --- Step 2: Entry points ---
echo ""
echo -e "${BLUE}[2/4] Writing entry point SCSS files...${NC}"

write_entry_point() {
  local name="$1"
  local content="$2"
  echo "$content" > "$STYLES_PATH/$name.scss"
  echo -e "  ${GREEN}Updated:${NC} $name.scss"
}

write_entry_point "mastodon-bird-ui-auto" "@use 'application';
@use 'mastodon-bird-ui';"

if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  write_entry_point "mastodon-bird-ui-accessible" "@use 'application';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible';"

  write_entry_point "mastodon-bird-ui-accessible-plus" "@use 'application';
@use 'mastodon-bird-ui';
@use 'mastodon-bird-ui/variants/accessible-plus';"
else
  rm -f "$STYLES_PATH/mastodon-bird-ui-accessible.scss" "$STYLES_PATH/mastodon-bird-ui-accessible-plus.scss"
fi

# Mastodon 4 entry points that no longer apply
rm -f "$STYLES_PATH"/mastodon-bird-ui-{dark,light,contrast,stars,light-stars,auto-stars,accessible-hide-finnish}.scss
rm -f "$STYLES_PATH"/hide-*.scss

# --- Step 3: themes.yml ---
echo ""
echo -e "${BLUE}[3/4] Rebuilding themes.yml...${NC}"

STOCK_COLORS='  colors:\n    - indigo\n    - lime\n    - pink\n    - orange\n    - cyan\n'
BIRD_KEYS="default mastodon-dark mastodon-bird-ui-auto mastodon-bird-ui-accessible mastodon-bird-ui-accessible-plus"

# Third-party themes stay when their file still exists
PRESERVED_THEMES=$(awk -v keep="$BIRD_KEYS" -v root="$MASTODON_PATH/app/javascript/" '
  BEGIN { split(keep, k, " "); for (i in k) bird[k[i]] = 1 }
  /^[A-Za-z0-9_-]+:/ {
    flush(); key = $0; sub(/:.*/, "", key); block = $0 "\n"; path = ""
    if (split($0, inline, ": ") == 2) { path = inline[2] }
    next
  }
  /^[ \t]/ && key != "" {
    block = block $0 "\n"
    if ($1 == "path:") { path = $2 }
    next
  }
  END { flush() }
  function flush() {
    if (key == "" || (key in bird)) { key = ""; return }
    if (path != "" && system("test -f " root path) == 0) { printf "%s", block }
    key = ""
  }' "$THEMES_FILE")

if [[ "$SET_DEFAULT" =~ ^[Yy]$ ]]; then
  printf "default:\n  path: styles/mastodon-bird-ui-auto.scss\nmastodon-dark:\n  path: styles/application.scss\n$STOCK_COLORS" > "$THEMES_FILE"
  echo -e "  ${GREEN}Set:${NC} default: Bird UI, mastodon-dark: stock Mastodon"
else
  printf "default:\n  path: styles/application.scss\n${STOCK_COLORS}mastodon-bird-ui-auto:\n  path: styles/mastodon-bird-ui-auto.scss\n" > "$THEMES_FILE"
  echo -e "  ${GREEN}Set:${NC} default: stock Mastodon, mastodon-bird-ui-auto: Bird UI"
fi

if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  printf 'mastodon-bird-ui-accessible:\n  path: styles/mastodon-bird-ui-accessible.scss\nmastodon-bird-ui-accessible-plus:\n  path: styles/mastodon-bird-ui-accessible-plus.scss\n' >> "$THEMES_FILE"
  echo -e "  ${GREEN}Added:${NC} accessible themes"
fi

if [ -n "$PRESERVED_THEMES" ]; then
  printf '%s\n' "$PRESERVED_THEMES" >> "$THEMES_FILE"
  echo -e "  ${GREEN}Preserved:${NC} other installed themes"
fi

# --- Step 4: Locale files ---
echo ""
echo -e "${BLUE}[4/4] Updating locale files...${NC}"

EN_LOCALE="$MASTODON_PATH/config/locales/en.yml"
FI_LOCALE="$MASTODON_PATH/config/locales/fi.yml"

STALE_THEME_KEYS="mastodon-light contrast system mastodon-bird-ui-dark mastodon-bird-ui-light mastodon-bird-ui-contrast mastodon-bird-ui-dark-change-to-stars hide-finnish hide-finnish-change-to-stars hide-translate-links mastodon-bird-ui-light-hide-finnish mastodon-bird-ui-light-hide-finnish-change-to-stars mastodon-bird-ui-light-hide-translate-links mastodon-bird-ui-accessible-hide-finnish"

for locale_file in "$EN_LOCALE" "$FI_LOCALE"; do
  [ ! -f "$locale_file" ] && continue
  for stale_key in $STALE_THEME_KEYS; do
    sed -i "/^    ${stale_key}:/d" "$locale_file"
  done
done

set_locale_entry() {
  local file="$1"
  local key="$2"
  local value="$3"

  [ ! -f "$file" ] && return
  grep -q "^  themes:" "$file" || return

  sed -i "/^    ${key}:/d" "$file"
  sed -i "/^  themes:/a\\    ${key}: ${value}" "$file"
  echo -e "  ${GREEN}Set in $(basename "$file"):${NC} $key"
}

if [[ "$SET_DEFAULT" =~ ^[Yy]$ ]]; then
  set_locale_entry "$EN_LOCALE" "default" "Mastodon Bird UI"
  set_locale_entry "$FI_LOCALE" "default" "Mastodon Bird UI"
  set_locale_entry "$EN_LOCALE" "mastodon-dark" "Mastodon"
  set_locale_entry "$FI_LOCALE" "mastodon-dark" "Mastodon"
else
  set_locale_entry "$EN_LOCALE" "default" "Mastodon"
  set_locale_entry "$FI_LOCALE" "default" "Mastodon"
  set_locale_entry "$EN_LOCALE" "mastodon-bird-ui-auto" "Mastodon Bird UI"
  set_locale_entry "$FI_LOCALE" "mastodon-bird-ui-auto" "Mastodon Bird UI"
fi

if [[ "$ADD_VARIATIONS" =~ ^[Yy]$ ]]; then
  set_locale_entry "$EN_LOCALE" "mastodon-bird-ui-accessible" "Mastodon Bird UI (Ultra accessible)"
  set_locale_entry "$EN_LOCALE" "mastodon-bird-ui-accessible-plus" "Mastodon Bird UI (Ultra accessible Plus+)"
  set_locale_entry "$FI_LOCALE" "mastodon-bird-ui-accessible" "Mastodon Bird UI (saavutettava)"
  set_locale_entry "$FI_LOCALE" "mastodon-bird-ui-accessible-plus" "Mastodon Bird UI (saavutettava Plus+)"
fi

# --- Ownership and permissions ---
echo ""
echo "Fixing file ownership and permissions..."
chmod -R a+r "$BIRD_UI_PATH"
find "$BIRD_UI_PATH" -type d -exec chmod a+rx {} \;
if id mastodon >/dev/null 2>&1; then
  chown -R mastodon:mastodon "$BIRD_UI_PATH"
  chown mastodon:mastodon "$STYLES_PATH"/mastodon-bird-ui-*.scss "$THEMES_FILE" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo "themes.yml contents:"
cat "$THEMES_FILE"
echo ""
echo "Next steps:"
echo "  cd $MASTODON_PATH"
echo "  RAILS_ENV=production bundle exec rails assets:precompile"
echo "  sudo systemctl restart mastodon-web"
