---
name: antigravity-quota
description: Interactive Antigravity quota & model usage dashboard widget with generative_ui. Displays real-time Gemini 4 Argon (WTU pool), Gemini 3.8, and Claude/GPT allowances, 5-hour sliding windows, WTU capacity estimators, and countdown timers, with automated CLI/agent skill installation workflows.
---

# Antigravity Quota Dashboard Skill

This skill enables Antigravity AI assistants to render an interactive 3-pool quota dashboard (**Gemini 4 Argon**, **Gemini 3.8**, and **Claude & GPT**), inspect remaining model allowances and WTU capacity estimates, and automate the deployment/installation of the quota widget across machines and workspaces.

---

## 🎯 Trigger Scenarios & User Intents

Activate this skill when the user asks:
1. **Quota & Usage Inquiries**:
   - "查看我的额度" / "Show my Antigravity quota"
   - "Argon额度还有多少" / "Check remaining Argon / Token allowances"
   - "5小时滑动窗口剩余" / "5-hour sliding window status"
   - "刷新额度" / "Refresh quota dashboard"
2. **Skill Installation & Setup**:
   - "安装额度看板" / "部署额度小组件"
   - "通过Skill安装quota widget" / "Install quota dashboard skill"
   - "更新额度看板技能" / "Update quota widget"
3. **Configuration & Language Switching**:
   - "把额度面板切换成英文/中文" / "Change quota widget language to English/Chinese"
   - "卸载额度看板" / "Uninstall quota skill"

---

## 📋 Workflows

### Workflow 1: Display Live Quota Dashboard (Generative UI)

When the user asks to view, check, or refresh their quota:

1. **Locate the Widget HTML**:
   - Primary path: `<current_skill_dir>/widgets/quota_widget/index.html`
   - Fallback path: `<workspace_root>/widgets/quota_widget/index.html`
   - Language-specific variants:
     - Chinese: `<current_skill_dir>/widgets/quota_widget/quota_widget_zh.html`
     - English: `<current_skill_dir>/widgets/quota_widget/quota_widget_en.html`

2. **Ensure Local Live Bridge (`http://127.0.0.1:12655/api/quota`) or Probe `RetrieveUserQuotaSummary`**:
   - The widget polls `http://127.0.0.1:12655/api/quota` directly within the webview.
   - If `127.0.0.1:12655` is not yet listening, start the lightweight local bridge in daemon mode:
     ```powershell
     python "<current_skill_dir>/scripts/quota_server.py"
     ```
   - Or query `http://127.0.0.1:<port>/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary` directly via `language_server` and update the initial snapshot `state.groups` in the artifact HTML.

3. **Render with Generative UI (`<agent-embed>`)**:
   - Copy the HTML file into the conversation's artifact directory (e.g. `<artifact_dir>/quota_widget.html` with `UserFacing: true`) and embed it inline in your response:
     ```html
     <agent-embed src="file:///<artifact_dir>/quota_widget.html"></agent-embed>
     ```

---

### Workflow 2: Automated Skill Installation (AI Agent Runbook)

When the user instructs the assistant to install or update the quota dashboard skill:

1. **Determine Installation Scope**:
   - **Global (Default & Recommended)**: `~/.gemini/config/skills/antigravity-quota/`
     - Available everywhere on this machine across all workspaces.
   - **Workspace**: `<workspace_root>/.agents/skills/antigravity-quota/`
     - Project-specific, ideal for team repositories.

2. **Determine Language**:
   - Auto-detected or user-specified (`zh` for Chinese, `en` for English).

3. **Execute Installation**:
   - **Via Command Line Script**:
     - **Windows (PowerShell)**:
       ```powershell
       & "<skill_dir>\scripts\install.ps1" -Lang zh -Scope Global
       ```
     - **macOS / Linux (Bash)**:
       ```bash
       bash "<skill_dir>/scripts/install.sh" -l zh -s global
       ```
   - **Via Direct Agent File Operations**:
     If running scripts is restricted, the agent can directly create the folder structure and copy files:
     - Target: `~/.gemini/config/skills/antigravity-quota/`
     - Copy `SKILL.md` -> `<target>/SKILL.md`
     - Copy `widgets/quota_widget/` -> `<target>/widgets/quota_widget/`
     - Copy selected language file (`quota_widget_zh.html` or `quota_widget_en.html`) -> `<target>/widgets/quota_widget/index.html`
     - Copy `scripts/` -> `<target>/scripts/`

4. **Verify Deployment**:
   - Confirm `<target>/SKILL.md` and `<target>/widgets/quota_widget/index.html` exist.
   - Report success to the user with sample trigger commands.

---

### Workflow 3: Uninstallation / Cleanup

When the user asks to remove the skill:
1. Locate the installed path (`~/.gemini/config/skills/antigravity-quota` or `<workspace>/.agents/skills/antigravity-quota`).
2. Run uninstaller script:
   - PowerShell: `& "<target>\scripts\install.ps1" -Uninstall -Scope Global`
   - Bash: `bash "<target>/scripts/install.sh" -u -s global`
   - Or delete the directory directly.
3. Confirm clean uninstallation to the user.
