# Antigravity 额度看板 📊

**中文说明** | [English](README.md)

专为 **Google Antigravity** 打造的便携式交互型额度监控面板。

提供 Google AI Pro (Gemini) 与第三方模型 (Claude & GPT) 的实时额度追踪、5小时滑动窗口百分比展示与重置倒计时预测。

---

## ✨ 核心特性

- **⚡ 实时额度同步**：探测并连接本地服务端口（`http://127.0.0.1:12655/api/quota`），实时监控 5 小时滑动额度与每周总额度。
- **🎨 现代交互 UI**：原生 Tailwind CSS，暗色/亮色自适应，支持通过 `generative_ui` 在 Antigravity 对话中内嵌渲染。
- **🌐 安装期多语言选择 (i18n)**：在安装部署阶段根据系统语言（或指定参数 `-Lang zh / -Lang en`）写入目标语言，开箱即用。
- **📦 换电脑一键极速还原**：任何新电脑只需执行一条命令即可自动完成部署！

---

## 🚀 极速安装（新电脑换机体验）

### Windows (PowerShell)
在 PowerShell 终端中执行单行命令即可完成一键部署：
```powershell
# 自动检测语言并安装到 ~/.gemini/config/skills/
git clone https://github.com/lanhux/antigravity-quota-widget.git "$env:TEMP\ag-widget"; & "$env:TEMP\ag-widget\install.ps1" -Lang auto; Remove-Item -Recurse -Force "$env:TEMP\ag-widget"
```

或者手动克隆并指定中文：
```powershell
git clone https://github.com/lanhux/antigravity-quota-widget.git
cd antigravity-quota-widget
.\install.ps1 -Lang zh
```

### macOS / Linux (Bash)
```bash
git clone https://github.com/lanhux/antigravity-quota-widget.git /tmp/ag-widget && /tmp/ag-widget/install.sh zh && rm -rf /tmp/ag-widget
```

---

## 💡 在 Antigravity 中使用

安装完成后，技能 `antigravity-quota` 将自动就绪。你在对话中对 AI 助手说：
- *“查看我的 Antigravity 额度”*
- *“刷新一下模型余量”*

助手即可直接在对话界面中以内嵌小组件的形式渲染出交互看板！

---

## 📁 目录规范

```text
├── skills/
│   └── antigravity-quota/
│       └── SKILL.md                 # Antigravity 技能声明规范
├── widgets/
│   └── quota_widget/                # 额度看板组件 (中/英源码)
│       ├── quota_widget_zh.html
│       └── quota_widget_en.html
├── install.ps1                      # Windows 一键安装脚本
├── install.sh                       # Unix/macOS 安装脚本
├── README.md                        # 英文说明
└── README_CN.md                     # 中文说明
```

---

## 📄 开源许可
MIT License
