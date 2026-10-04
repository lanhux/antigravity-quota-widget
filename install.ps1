<#
.SYNOPSIS
    Antigravity Quota Dashboard Installer
.DESCRIPTION
    Installs, configures, or removes the Antigravity Quota Dashboard Skill.
    Supports local repository execution and remote one-liner execution (via irm | iex).
.PARAMETER Lang
    Target language ('zh' for Chinese, 'en' for English, 'auto' for system UI culture). Default is 'auto'.
.PARAMETER Scope
    Target installation scope ('Global' for ~/.gemini/config/skills, 'Workspace' for .agents/skills). Default is 'Global'.
.PARAMETER Uninstall
    Switch to uninstall the skill from the specified scope.
.EXAMPLE
    .\install.ps1 -Lang zh
.EXAMPLE
    irm https://raw.githubusercontent.com/lanhux/antigravity-quota-widget/main/install.ps1 | iex
.EXAMPLE
    .\install.ps1 -Uninstall
#>

param(
    [ValidateSet("zh", "en", "auto")]
    [string]$Lang = "auto",

    [ValidateSet("Global", "Workspace")]
    [string]$Scope = "Global",

    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/lanhux/antigravity-quota-widget.git"
$SkillName = "antigravity-quota"

# Determine target directory based on Scope
if ($Scope -eq "Global") {
    $targetDir = Join-Path $env:USERPROFILE ".gemini\config\skills\$SkillName"
} else {
    $targetDir = Join-Path (Get-Location) ".agents\skills\$SkillName"
}

# Handle Uninstall
if ($Uninstall) {
    Write-Host ">>> Uninstalling Antigravity Quota Dashboard from [$Scope]..." -ForegroundColor Yellow
    if (Test-Path $targetDir) {
        Remove-Item -Recurse -Force $targetDir
        Write-Host ">>> Successfully removed: $targetDir" -ForegroundColor Green
    } else {
        Write-Host ">>> Target directory does not exist: $targetDir" -ForegroundColor Gray
    }
    return
}

# Determine Language
if ($Lang -eq "auto") {
    $currentCulture = (Get-UICulture).TwoLetterISOLanguageName.ToLower()
    $selectedLang = if ($currentCulture -eq "zh") { "zh" } else { "en" }
} else {
    $selectedLang = $Lang
}

$langLabel = if ($selectedLang -eq "zh") { "中文 (Chinese)" } else { "English" }
Write-Host ">>> Installing Antigravity Quota Dashboard [$langLabel] (Scope: $Scope)..." -ForegroundColor Cyan

# Locate Source Directory
$isLocal = $false
$sourceDir = $PSScriptRoot

if (-not [string]::IsNullOrWhiteSpace($sourceDir) -and (Test-Path (Join-Path $sourceDir "skills\$SkillName\SKILL.md"))) {
    $isLocal = $true
} elseif (-not [string]::IsNullOrWhiteSpace($sourceDir) -and (Test-Path (Join-Path $sourceDir "SKILL.md"))) {
    # Script might be running from within skills/antigravity-quota/scripts
    $possibleRoot = (Resolve-Path (Join-Path $sourceDir "..\..")).Path
    if (Test-Path (Join-Path $possibleRoot "skills\$SkillName\SKILL.md")) {
        $sourceDir = $possibleRoot
        $isLocal = $true
    }
}

$tempDir = $null
if (-not $isLocal) {
    Write-Host ">>> Remote or piped execution detected. Fetching repository files..." -ForegroundColor Gray
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "ag-quota-widget-$([System.Guid]::NewGuid().ToString('N').Substring(0, 8))"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    try {
        if (Get-Command git -ErrorAction SilentlyContinue) {
            git clone --depth 1 $RepoUrl $tempDir --quiet
        } else {
            # Fallback to downloading zip archive
            $zipUrl = "https://github.com/lanhux/antigravity-quota-widget/archive/refs/heads/main.zip"
            $zipPath = Join-Path $tempDir "archive.zip"
            Invoke-RestMethod -Uri $zipUrl -OutFile $zipPath
            Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
            $sourceDir = Join-Path $tempDir "antigravity-quota-widget-main"
        }
        if (Test-Path (Join-Path $tempDir "skills\$SkillName\SKILL.md")) {
            $sourceDir = $tempDir
        }
    } catch {
        Write-Error "Failed to fetch files from remote repository: $_"
        if ($tempDir -and (Test-Path $tempDir)) { Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue }
        return
    }
}

try {
    # Create target directories
    $targetWidgetsDir = Join-Path $targetDir "widgets\quota_widget"
    $targetScriptsDir = Join-Path $targetDir "scripts"
    New-Item -ItemType Directory -Force -Path $targetWidgetsDir | Out-Null
    New-Item -ItemType Directory -Force -Path $targetScriptsDir | Out-Null

    # 1. Copy SKILL.md
    $skillMdSource = Join-Path $sourceDir "skills\$SkillName\SKILL.md"
    if (-not (Test-Path $skillMdSource)) {
        $skillMdSource = Join-Path $sourceDir "SKILL.md"
    }
    Copy-Item $skillMdSource (Join-Path $targetDir "SKILL.md") -Force

    # 2. Copy widgets
    $widgetSourceDir = Join-Path $sourceDir "widgets\quota_widget"
    if (Test-Path $widgetSourceDir) {
        Copy-Item (Join-Path $widgetSourceDir "*") $targetWidgetsDir -Force
    }

    # Set chosen language as index.html
    $chosenHtml = if ($selectedLang -eq "zh") {
        Join-Path $targetWidgetsDir "quota_widget_zh.html"
    } else {
        Join-Path $targetWidgetsDir "quota_widget_en.html"
    }
    if (Test-Path $chosenHtml) {
        Copy-Item $chosenHtml (Join-Path $targetWidgetsDir "index.html") -Force
    }

    # 3. Copy scripts for standalone portable maintenance
    $installPs1 = Join-Path $sourceDir "install.ps1"
    $installSh = Join-Path $sourceDir "install.sh"
    if (Test-Path $installPs1) { Copy-Item $installPs1 (Join-Path $targetScriptsDir "install.ps1") -Force }
    if (Test-Path $installSh) { Copy-Item $installSh (Join-Path $targetScriptsDir "install.sh") -Force }

    Write-Host ">>> Done! Successfully installed to: $targetDir" -ForegroundColor Green
    Write-Host ">>> Test or summon in Antigravity chat: '查看我的额度' or 'Show my quota'!" -ForegroundColor Yellow
} finally {
    if ($tempDir -and (Test-Path $tempDir)) {
        Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
    }
}
