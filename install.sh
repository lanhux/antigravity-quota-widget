#!/usr/bin/env bash
# Antigravity Quota Dashboard Installer (Bash for macOS / Linux)
# Supports local repo execution and remote piping (curl ... | bash)

set -e

LANG_OPT="auto"
SCOPE="global"
UNINSTALL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--lang)
      LANG_OPT="$2"
      shift 2
      ;;
    -s|--scope)
      SCOPE="$2"
      shift 2
      ;;
    -u|--uninstall)
      UNINSTALL=true
      shift
      ;;
    zh|en|auto)
      LANG_OPT="$1"
      shift
      ;;
    global|workspace)
      SCOPE="$1"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

REPO_URL="https://github.com/lanhux/antigravity-quota-widget.git"
SKILL_NAME="antigravity-quota"

# Determine target directory
if [ "$SCOPE" = "workspace" ]; then
  TARGET_DIR="$(pwd)/.agents/skills/$SKILL_NAME"
else
  TARGET_DIR="$HOME/.gemini/config/skills/$SKILL_NAME"
fi

# Handle uninstall
if [ "$UNINSTALL" = true ]; then
  echo ">>> Uninstalling Antigravity Quota Dashboard from [$SCOPE]..."
  if [ -d "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
    echo ">>> Successfully removed: $TARGET_DIR"
  else
    echo ">>> Target directory does not exist: $TARGET_DIR"
  fi
  exit 0
fi

# Determine language
if [ "$LANG_OPT" = "auto" ]; then
  if [[ "$LANG" == *"zh"* ]]; then
    SELECTED_LANG="zh"
  else
    SELECTED_LANG="en"
  fi
else
  SELECTED_LANG="$LANG_OPT"
fi

echo ">>> Installing Antigravity Quota Dashboard [${SELECTED_LANG}] (Scope: ${SCOPE})..."

# Detect source directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
IS_LOCAL=false
TEMP_DIR=""

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/skills/$SKILL_NAME/SKILL.md" ]; then
  SOURCE_DIR="$SCRIPT_DIR"
  IS_LOCAL=true
elif [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/../../skills/$SKILL_NAME/SKILL.md" ]; then
  SOURCE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
  IS_LOCAL=true
fi

if [ "$IS_LOCAL" = false ]; then
  echo ">>> Remote or piped execution detected. Fetching repository files..."
  TEMP_DIR="/tmp/ag-quota-widget-$$"
  mkdir -p "$TEMP_DIR"
  git clone --depth 1 "$REPO_URL" "$TEMP_DIR" --quiet
  SOURCE_DIR="$TEMP_DIR"
fi

cleanup() {
  if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}
trap cleanup EXIT

# Deploy files
mkdir -p "$TARGET_DIR/widgets/quota_widget"
mkdir -p "$TARGET_DIR/scripts"

if [ -f "$SOURCE_DIR/skills/$SKILL_NAME/SKILL.md" ]; then
  cp "$SOURCE_DIR/skills/$SKILL_NAME/SKILL.md" "$TARGET_DIR/SKILL.md"
fi

if [ -d "$SOURCE_DIR/widgets/quota_widget" ]; then
  cp -r "$SOURCE_DIR/widgets/quota_widget/"* "$TARGET_DIR/widgets/quota_widget/"
fi

if [ "$SELECTED_LANG" = "zh" ]; then
  cp "$TARGET_DIR/widgets/quota_widget/quota_widget_zh.html" "$TARGET_DIR/widgets/quota_widget/index.html"
else
  cp "$TARGET_DIR/widgets/quota_widget/quota_widget_en.html" "$TARGET_DIR/widgets/quota_widget/index.html"
fi

if [ -f "$SOURCE_DIR/install.sh" ]; then cp "$SOURCE_DIR/install.sh" "$TARGET_DIR/scripts/install.sh"; fi
if [ -f "$SOURCE_DIR/install.ps1" ]; then cp "$SOURCE_DIR/install.ps1" "$TARGET_DIR/scripts/install.ps1"; fi
if [ -f "$SOURCE_DIR/skills/$SKILL_NAME/scripts/quota_server.py" ]; then
  cp "$SOURCE_DIR/skills/$SKILL_NAME/scripts/quota_server.py" "$TARGET_DIR/scripts/quota_server.py"
elif [ -f "$SOURCE_DIR/scripts/quota_server.py" ]; then
  cp "$SOURCE_DIR/scripts/quota_server.py" "$TARGET_DIR/scripts/quota_server.py"
fi

echo ">>> Done! Successfully installed to: $TARGET_DIR"
echo ">>> Test or summon in Antigravity chat: '查看我的额度' or 'Show my quota'!"
