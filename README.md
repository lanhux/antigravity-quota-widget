# Antigravity Quota Dashboard 📊

[中文说明 (Chinese)](README_CN.md) | **English**

A clean, interactive Quota Dashboard widget designed for **Google Antigravity**.

Provides real-time quota tracking for Google AI Pro (Gemini) and 3rd-party models (Claude & GPT), with local endpoint polling, 5-hour sliding window visualization, and reset countdown predictions. Supports both **CLI one-liner installation** and **AI Agent conversational (Skill) installation**.

---

## ✨ Features

- **⚡ Real-time Quota Sync**: Connects to the local language server / endpoint (`http://127.0.0.1:12655/api/quota`) to monitor sliding 5-hour and weekly usage windows.
- **🎨 Interactive Rich UI**: Built with Tailwind CSS, supporting dark/light modes and responsive gradients via Antigravity `generative_ui`.
- **🌐 Install-time i18n**: Select English or Chinese during installation; auto-detects your system UI culture or can be switched anytime.
- **📦 Dual-mode Quick Setup**: Install via a single terminal command or simply instruct your Antigravity AI assistant to deploy it via Skill.
- **🧹 Clean & Focused**: Lightweight repository dedicated solely to the quota dashboard, free of unrelated toy assets.

---

## 🚀 Installation

### Method 1: CLI One-Liner (Terminal)

Ideal for quick terminal setup or new machine migration:

#### 1. Windows (PowerShell)
```powershell
# Remote one-liner (auto-detects system language)
irm https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.ps1 | iex

# Or explicitly select English
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.ps1))) -Lang en
```

#### 2. macOS / Linux (Bash)
```bash
# Remote one-liner (auto-detects system language)
curl -fsSL https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.sh | bash

# Or explicitly select English
curl -fsSL https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.sh | bash -s -- en
```

#### 3. Manual Clone
```powershell
git clone https://github.com/lanhux/antigravity-quota-widget.git
cd antigravity-quota-widget

# Windows
.\install.ps1 -Lang en

# macOS / Linux
chmod +x install.sh
./install.sh en
```

> **Uninstall**: Run `.\install.ps1 -Uninstall` or `./install.sh --uninstall` to cleanly remove the skill.

---

### Method 2: Install via Antigravity Skill / AI Agent

This project complies with the official [Antigravity Customization System](https://github.com) skill specification. In any Antigravity conversation, simply tell your assistant:

> 💬 *"Install or update the quota dashboard skill from `lanhux/antigravity-quota-widget`"*
> 
> Or if cloned in your current workspace:
> 💬 *"Install this repository as a global Antigravity quota skill"*

The AI assistant will automatically read the **Automated Installation Runbook (Workflow 2)** inside `SKILL.md`, detect your environment (`~/.gemini/config/skills/antigravity-quota/`), apply language preferences, and deploy the files without manual steps.

---

## 💡 How to Use in Antigravity

Once installed, the `antigravity-quota` skill is globally active. In any project conversation, ask:

- 💬 *"Show my Antigravity quota"*
- 💬 *"Check my remaining token limits and sliding window"*
- 💬 *"Refresh model allowances"*
- 💬 *"查看我的额度"*

The assistant will render the live interactive quota widget directly inside your conversation stream via `generative_ui`:

- Click the **🔄 Refresh** button in the top-right corner to re-sync with your local endpoint.
- View real-time percentages and 5-hour countdown timers for both Gemini and Claude/GPT tiers.

---

## 📁 Repository Structure

```text
antigravity-quota-widget/
├── skills/
│   └── antigravity-quota/
│       ├── SKILL.md                 # Antigravity skill specification & runbooks
│       ├── scripts/                 # Portable helper scripts (install.ps1 / install.sh)
│       └── widgets/quota_widget/    # Bundled dashboard widget assets
├── widgets/
│   └── quota_widget/
│       ├── index.html               # Default active widget
│       ├── quota_widget_zh.html     # Chinese template
│       └── quota_widget_en.html     # English template
├── install.ps1                      # Windows installer (PowerShell)
├── install.sh                       # Unix installer (Bash)
├── README.md                        # English documentation
└── README_CN.md                     # Chinese documentation
```

---

## 📄 License
[MIT License](LICENSE)
