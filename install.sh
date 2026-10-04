#!/usr/bin/env bash
# Antigravity Quota Dashboard Installer (Bash for macOS / Linux)

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

echo ">>> Installing Antigravity Quota Dashboard [${SELECTED_LANG}]..."

TARGET_DIR="$HOME/.gemini/config/skills/antigravity-quota"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$TARGET_DIR/widgets/quota_widget"

cp "$SCRIPT_DIR/skills/antigravity-quota/SKILL.md" "$TARGET_DIR/SKILL.md"

if [ "$SELECTED_LANG" = "zh" ]; then
  cp "$SCRIPT_DIR/widgets/quota_widget/quota_widget_zh.html" "$TARGET_DIR/widgets/quota_widget/index.html"
else
  cp "$SCRIPT_DIR/widgets/quota_widget/quota_widget_en.html" "$TARGET_DIR/widgets/quota_widget/index.html"
fi

echo ">>> Successfully installed to: $TARGET_DIR"
