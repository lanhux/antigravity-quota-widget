# Antigravity Quota Dashboard 📊

[中文说明 (Chinese)](README_CN.md) | **English**

A clean, interactive Quota Dashboard widget designed for **Google Antigravity**.

Provides real-time 3-pool quota tracking for **Gemini 4 Argon (Dedicated Weekly WTU Pool)**, Google AI Pro (Gemini 3.8 native pool), and 3rd-party models (Claude & GPT), with local endpoint polling, WTU capacity & step estimates, 5-hour sliding window visualization, and reset countdown predictions. Supports both **CLI one-liner installation** and **AI Agent conversational (Skill) installation**.

---

## ✨ Features

- **⚡ 3-Pool Panoramic Sync**: Real-time tracking across **Gemini 4 Argon** (weekly WTU pool), **Gemini 3.8**, and **Claude / GPT** tiers with instant tab-switching.
- **🧮 WTU Capacity Estimator**: Built-in Argon benchmark dynamically translating remaining quota percentage to usable reasoning steps (~315 steps), WTU pool capacity (~3.5M WTU), and token throughput (~18M tokens).
- **🔌 Zero-Config Local Bridge**: Bundled lightweight `quota_server.py` that auto-discovers local `language_server` processes and CSRF tokens to provide a unified CORS endpoint (`http://127.0.0.1:12655/api/quota`).
- **🎨 Interactive Rich UI**: Built with Tailwind CSS, supporting dark/light modes and dynamic breathing-dot status indicator (Live Sync vs Snapshot Mode) via Antigravity `generative_ui`.
- **🌐 Install-time i18n**: Select English or Chinese during installation; auto-detects your system UI culture or can be switched anytime.
- **📦 Dual-mode Quick Setup**: Install via a single terminal command or simply instruct your Antigravity AI assistant to deploy it via Skill.

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
│       ├── scripts/                 # Portable helper & bridge scripts (install.ps1 / install.sh / quota_server.py)
│       └── widgets/quota_widget/    # Bundled dashboard widget assets
├── widgets/
│   └── quota_widget/
│       ├── index.html               # Default active widget
│       ├── quota_widget_zh.html     # Chinese template (Argon, Gemini, Claude 3-pool)
│       └── quota_widget_en.html     # English template
├── scripts/
│   └── quota_server.py              # Local language_server discovery & CORS bridge
├── install.ps1                      # Windows installer (PowerShell)
├── install.sh                       # Unix installer (Bash)
├── README.md                        # English documentation
└── README_CN.md                     # Chinese documentation
```

---

## 📄 License
[MIT License](LICENSE)
