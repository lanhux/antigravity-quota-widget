---
name: antigravity-quota
description: Renders the interactive Antigravity quota & model usage dashboard widget or fun companion pet widgets using generative_ui. Triggers on requests about remaining quota, tokens, reset limits, or fun desk companions.
---

# Antigravity Quota & Companion Widgets

Use this skill when the user asks about:
- Their Antigravity quota, usage, token limits, remaining 5h sliding window, or reset schedules.
- Refreshing the status of Google AI Pro (Gemini) and 3rd party (Claude / GPT) allowances.
- Opening or viewing the desktop companion widgets (e.g. Pelican on a Bicycle, Marmot).

## 1. Quota Dashboard Widget

When asked to display or refresh the quota, inline the widget using the Generative UI mechanism:

1. Locate the widget template:
   - Primary: `<current_skill_dir>/../../widgets/quota_widget/index.html` (or fallback to `<skill_dir>/quota_widget.html`)
2. Read the HTML content.
3. If fresh quota numbers are provided via tools or API, replace the default state numbers in the HTML script.
4. Render using the write artifact or inline UI pattern.

## 2. Pelican / Companion Widget

When the user asks to summon their companion, relax, or play with the bicycle pelican:
- Open `<current_skill_dir>/../../widgets/pelican_bicycle/index.html` (or the corresponding language file).
- Render it for the user to enjoy the bell, feeding, shades, and turbo animations.
