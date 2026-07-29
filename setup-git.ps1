# Farm Game Studio - Git 仓库初始化脚本
# 使用方法：安装 Git 后，在 PowerShell 中执行：
#   powershell -ExecutionPolicy Bypass -File setup-git.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Farm Game Studio - Git 仓库初始化" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Git 是否已安装
Write-Host "[1/5] 检查 Git 安装状态..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "  ✓ Git 已安装: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Git 未安装！请先安装 Git:" -ForegroundColor Red
    Write-Host "    下载地址: https://git-scm.com/download/win" -ForegroundColor White
    Write-Host "    详细步骤请查看: git-setup-guide.md" -ForegroundColor White
    Read-Host "按回车键退出..."
    exit 1
}

# 检查是否已在 Git 仓库中
if (Test-Path ".git") {
    Write-Host "  ℹ 已存在 Git 仓库，跳过初始化" -ForegroundColor Yellow
} else {
    # 初始化仓库
    Write-Host "[2/5] 初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    git branch -M main
    Write-Host "  ✓ 仓库已初始化" -ForegroundColor Green
}

# 配置 Git 用户信息（如未配置）
Write-Host "[3/5] 检查 Git 用户配置..." -ForegroundColor Yellow
$userName = git config user.name 2>$null
$userEmail = git config user.email 2>$null

if (-not $userName -or -not $userEmail) {
    Write-Host "  ⚠ Git 用户信息未配置" -ForegroundColor Yellow
    Write-Host "  请执行以下命令设置：" -ForegroundColor White
    Write-Host '    git config --global user.name "你的名字"' -ForegroundColor Gray
    Write-Host '    git config --global user.email "your.email@example.com"' -ForegroundColor Gray
    Write-Host ""
    Write-Host "  详细说明请查看: git-setup-guide.md" -ForegroundColor White
} else {
    Write-Host "  ✓ 用户: $userName ($userEmail)" -ForegroundColor Green
}

# 添加所有文件到暂存区
Write-Host "[4/5] 添加文件到暂存区..." -ForegroundColor Yellow
git add .
Write-Host "  ✓ 已添加所有文件" -ForegroundColor Green

# 创建初始提交（如无提交记录）
$commitCount = git rev-list --count HEAD 2>$null
if ($commitCount -eq "0") {
    Write-Host "[5/5] 创建初始提交..." -ForegroundColor Yellow
    git commit -m @"
Initial commit: PRD v2.0.1, TDD, AGENT.md

- PRD: 产品需求文档 v2.0.1
- TDD: 技术设计文档 v2.0.1
- AGENT.md: 游戏工作室架构
- .gitignore: Godot 4.x 忽略规则
- .gitattributes: 跨平台换行配置
- git-setup-guide.md: Git 配置指引
"@
    Write-Host "  ✓ 初始提交已创建" -ForegroundColor Green
} else {
    Write-Host "[5/5] 已存在提交记录，跳过" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  ✓ Git 仓库配置完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 显示仓库状态
Write-Host "仓库状态:" -ForegroundColor White
git status

Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "  1. 关联远程仓库: git remote add origin <仓库地址>" -ForegroundColor White
Write-Host "  2. 推送到远程:   git push -u origin main" -ForegroundColor White
Write-Host "  3. 详细文档:     git-setup-guide.md" -ForegroundColor White
Write-Host ""
