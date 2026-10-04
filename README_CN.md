# Antigravity 额度看板 📊

**中文说明** | [English](README.md)

专为 **Google Antigravity** 打造的便携式交互型额度监控面板。

提供 Google AI Pro (Gemini) 与第三方模型 (Claude & GPT) 的实时额度追踪、5小时滑动窗口百分比展示与重置倒计时预测。支持**命令行一键安装**与**智能体对话式（Skill）一键安装**。

---

## ✨ 核心特性

- **⚡ 实时额度同步**：探测并连接本地服务端口（`http://127.0.0.1:12655/api/quota`），实时监控 5 小时滑动额度与每周总额度。
- **🎨 现代交互 UI**：原生 Tailwind CSS，暗色/亮色自适应，支持通过 `generative_ui` 在 Antigravity 对话中内嵌渲染。
- **🌐 多语言适配 (i18n)**：预置中文版与英文版，安装期自适应系统语言，亦可随时按需切换。
- **📦 双模式快速安装**：支持终端单行命令秒装，也支持在 Antigravity 聊天中直接让 AI 助手调用 Skill 规范自动部署。
- **🧹 干净轻量**：纯净专注于额度面板，无多余第三方玩具依赖，解耦清晰。

---

## 🚀 安装方式

### 方式一：命令行一键安装 (CLI Installation)

适合在终端中快速操作，换新电脑单行即装：

#### 1. Windows (PowerShell)
```powershell
# 远程一键安装（默认自动检测系统语言）
irm https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.ps1 | iex

# 或者显式指定中文版
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.ps1))) -Lang zh
```

#### 2. macOS / Linux (Bash)
```bash
# 远程一键安装（自动检测语言）
curl -fsSL https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.sh | bash

# 显式指定中文版
curl -fsSL https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.sh | bash -s -- zh
```

#### 3. 本地克隆安装
```powershell
git clone https://github.com/lanhux/antigravity-quota-widget.git
cd antigravity-quota-widget

# Windows
.\install.ps1 -Lang zh

# macOS / Linux
chmod +x install.sh
./install.sh zh
```

> **卸载方法**：运行 `.\install.ps1 -Uninstall` 或 `./install.sh --uninstall` 即可完全清除。

---

### 方式二：通过 Antigravity Skill 安装 (Install via Skill / AI)

本项目符合标准的 [Antigravity Customization System](https://github.com/google) 技能规范。在任何 Antigravity 编程会话中，只需对你的 AI 助手说：

> 💬 *“哈基米，帮我安装/更新 `lanhux/antigravity-quota-widget` 额度看板技能”*
> 
> 或如果在当前工作区克隆了本项目：
> 💬 *“帮我把这个仓库总结的额度看板安装为全局 Skill”*

AI 助手将自动读取 `SKILL.md` 中的 **自动化安装手册（Workflow 2）**，完成路径探测（`~/.gemini/config/skills/antigravity-quota/`）、语言选择与文件写入，零手动操作。

---

## 💡 在 Antigravity 中使用

安装完成后，技能 `antigravity-quota` 即刻全局生效。在任何工程会话中发送以下提示词：

- 💬 *“查看我的 Antigravity 额度”*
- 💬 *“查询剩余 Token 和滑动窗口”*
- 💬 *“刷新一下模型余量”*
- 💬 *“Show my quota status”*

AI 助手将调用 `generative_ui` 直接在对话流中渲染出实时交互看板：

- 支持点击右上角 **🔄 刷新** 按钮，动态向本地端口重新发起同步。
- 自动计算并显示 Gemini 与 Claude/GPT 的 5 小时恢复倒计时。

---

## 📁 目录规范

```text
antigravity-quota-widget/
├── skills/
│   └── antigravity-quota/
│       ├── SKILL.md                 # Antigravity 技能核心规范文档
│       ├── scripts/                 # 便携维护脚本 (install.ps1 / install.sh)
│       └── widgets/quota_widget/    # 随 Skill 一同分发的看板组件
├── widgets/
│   └── quota_widget/
│       ├── index.html               # 默认激活组件
│       ├── quota_widget_zh.html     # 中文版组件源码
│       └── quota_widget_en.html     # 英文版组件源码
├── install.ps1                      # Windows 命令行一键安装器
├── install.sh                       # Unix/macOS 命令行一键安装器
├── README.md                        # 英文说明
└── README_CN.md                     # 中文说明
```

---

## 📄 开源许可
[MIT License](LICENSE)
