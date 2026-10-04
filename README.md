# Antigravity Quota Dashboard 📊

[中文说明 (Chinese)](README_CN.md) | **English**

A clean, interactive Quota Dashboard widget designed for **Google Antigravity**.

Provides real-time quota tracking for Google AI Pro (Gemini) and 3rd-party models (Claude & GPT), with local endpoint polling, 5-hour sliding window visualization, and reset countdown predictions.

---

## ✨ Features

- **⚡ Real-time Quota Sync**: Connects to the local language server / endpoint (`http://127.0.0.1:12655/api/quota`) to monitor sliding 5-hour and weekly usage windows.
- **🎨 Interactive Rich UI**: Built with Tailwind CSS, supporting dark/light modes and responsive gradients via Antigravity `generative_ui`.
- **🌐 Install-time i18n**: Select English or Chinese during installation; auto-detects your system UI culture.
- **📦 Instant Setup**: Install onto any new machine with a single command!

---

## 🚀 Quick Install (New Machine)

### Windows (PowerShell)
Run this one-liner in your terminal:
```powershell
# Clone and install with auto-detected language
git clone https://github.com/lanhux/antigravity-quota-widget.git "$env:TEMP\ag-widget"; & "$env:TEMP\ag-widget\install.ps1" -Lang auto; Remove-Item -Recurse -Force "$env:TEMP\ag-widget"
```

Or clone manually:
```powershell
git clone https://github.com/lanhux/antigravity-quota-widget.git
cd antigravity-quota-widget
.\install.ps1 -Lang en   # or -Lang zh
```

### macOS / Linux (Bash)
```bash
git clone https://github.com/lanhux/antigravity-quota-widget.git /tmp/ag-widget && /tmp/ag-widget/install.sh auto && rm -rf /tmp/ag-widget
```

---

## 💡 How to Use in Antigravity

Once installed, the `antigravity-quota` skill is active. You can simply ask the assistant:
- *"Show my Antigravity quota"*
- *"Check my remaining token limits"*

The assistant will render the live interactive quota widget directly inside the conversation!

---

## 📁 Repository Structure

```text
├── skills/
│   └── antigravity-quota/
│       └── SKILL.md                 # Antigravity skill specification
├── widgets/
│   └── quota_widget/                # Quota dashboard (ZH & EN)
│       ├── quota_widget_zh.html
│       └── quota_widget_en.html
├── install.ps1                      # Windows installer (PowerShell)
├── install.sh                       # Unix installer (Bash)
├── README.md                        # English documentation
└── README_CN.md                     # Chinese documentation
```

---

## 📄 License
MIT License
