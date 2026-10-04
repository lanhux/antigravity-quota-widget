<#
.SYNOPSIS
    Antigravity Quota & Pet Widget Installer
.DESCRIPTION
    Installs the quota dashboard and pet widget into the Antigravity skills directory,
    with automatic language detection or explicit language selection (zh / en).
.PARAMETER Lang
    Target language ('zh' for Chinese, 'en' for English). Defaults to auto-detecting system UI culture.
#>

param(
    [ValidateSet("zh", "en", "auto")]
    [string]$Lang = "auto"
)

$ErrorActionPreference = "Stop"

# 1. Detect language
if ($Lang -eq "auto") {
    $currentCulture = (Get-UICulture).TwoLetterISOLanguageName.ToLower()
    if ($currentCulture -eq "zh") {
        $selectedLang = "zh"
    } else {
        $selectedLang = "en"
    }
} else {
    $selectedLang = $Lang
}

$langName = if ($selectedLang -eq "zh") { "中文 (Chinese)" } else { "English" }
Write-Host ">>> Installing Antigravity Quota & Pet Widgets [$langName]..." -ForegroundColor Cyan

# 2. Paths
$homeDir = $env:USERPROFILE
$targetSkillDir = Join-Path $homeDir ".gemini\config\skills\antigravity-quota"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 3. Create target directory
if (-not (Test-Path $targetSkillDir)) {
    New-Item -ItemType Directory -Force -Path $targetSkillDir | Out-Null
}

# 4. Copy Skill definition
$skillSource = Join-Path $scriptDir "skills\antigravity-quota\SKILL.md"
if (Test-Path $skillSource) {
    Copy-Item $skillSource (Join-Path $targetSkillDir "SKILL.md") -Force
}

# 5. Deploy chosen language widget as default index.html
$quotaWidgetDir = Join-Path $targetSkillDir "widgets\quota_widget"
$pelicanWidgetDir = Join-Path $targetSkillDir "widgets\pelican_bicycle"
$marmotWidgetDir = Join-Path $targetSkillDir "widgets\surfing_marmot"

New-Item -ItemType Directory -Force -Path $quotaWidgetDir | Out-Null
New-Item -ItemType Directory -Force -Path $pelicanWidgetDir | Out-Null
New-Item -ItemType Directory -Force -Path $marmotWidgetDir | Out-Null

if ($selectedLang -eq "zh") {
    Copy-Item (Join-Path $scriptDir "widgets\quota_widget\quota_widget_zh.html") (Join-Path $quotaWidgetDir "index.html") -Force
    Copy-Item (Join-Path $scriptDir "widgets\pelican_bicycle\pelican_bicycle.html") (Join-Path $pelicanWidgetDir "index.html") -Force
} else {
    Copy-Item (Join-Path $scriptDir "widgets\quota_widget\quota_widget_en.html") (Join-Path $quotaWidgetDir "index.html") -Force
    Copy-Item (Join-Path $scriptDir "widgets\pelican_bicycle\pelican_bicycle_en.html") (Join-Path $pelicanWidgetDir "index.html") -Force
}

# Copy SVG assets
Copy-Item (Join-Path $scriptDir "widgets\pelican_bicycle\pelican_bicycle.svg") (Join-Path $pelicanWidgetDir "pelican_bicycle.svg") -Force
Copy-Item (Join-Path $scriptDir "widgets\surfing_marmot\surfing_marmot.svg") (Join-Path $marmotWidgetDir "surfing_marmot.svg") -Force

Write-Host ">>> Done! Successfully installed to: $targetSkillDir" -ForegroundColor Green
Write-Host ">>> Restart or summon in Antigravity chat: '查看我的额度' or 'Show my quota'!" -ForegroundColor Yellow
