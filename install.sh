#!/usr/bin/env bash
# Antigravity Quota & Pet Widget Installer (Bash for macOS / Linux)

set -e

LANG_OPT="${1:-auto}"

if [ "$LANG_OPT" = "auto" ]; then
  if [[ "$LANG" == *"zh"* ]]; then
    SELECTED_LANG="zh"
  else
    SELECTED_LANG="en"
  fi
else
  SELECTED_LANG="$LANG_OPT"
fi

echo ">>> Installing Antigravity Quota & Pet Widgets [${SELECTED_LANG}]..."

TARGET_DIR="$HOME/.gemini/config/skills/antigravity-quota"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$TARGET_DIR/widgets/quota_widget"
mkdir -p "$TARGET_DIR/widgets/pelican_bicycle"
mkdir -p "$TARGET_DIR/widgets/surfing_marmot"

cp "$SCRIPT_DIR/skills/antigravity-quota/SKILL.md" "$TARGET_DIR/SKILL.md"

if [ "$SELECTED_LANG" = "zh" ]; then
  cp "$SCRIPT_DIR/widgets/quota_widget/quota_widget_zh.html" "$TARGET_DIR/widgets/quota_widget/index.html"
  cp "$SCRIPT_DIR/widgets/pelican_bicycle/pelican_bicycle.html" "$TARGET_DIR/widgets/pelican_bicycle/index.html"
else
  cp "$SCRIPT_DIR/widgets/quota_widget/quota_widget_en.html" "$TARGET_DIR/widgets/quota_widget/index.html"
  cp "$SCRIPT_DIR/widgets/pelican_bicycle/pelican_bicycle_en.html" "$TARGET_DIR/widgets/pelican_bicycle/index.html"
fi

cp "$SCRIPT_DIR/widgets/pelican_bicycle/pelican_bicycle.svg" "$TARGET_DIR/widgets/pelican_bicycle/pelican_bicycle.svg"
cp "$SCRIPT_DIR/widgets/surfing_marmot/surfing_marmot.svg" "$TARGET_DIR/widgets/surfing_marmot/surfing_marmot.svg"

echo ">>> Successfully installed to: $TARGET_DIR"
