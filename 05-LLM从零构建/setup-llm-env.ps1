<#
.SYNOPSIS
  一键搭建 LLMs-from-scratch 学习环境 - 适用于 Windows + Miniconda
.DESCRIPTION
  在一台新机器上执行以下操作：
  1. 检查 conda 是否安装
  2. 创建 llms 虚拟环境
  3. 安装 PyTorch + 其他依赖
  4. 验证环境可用

  用法：在 PowerShell 中运行：
    .\setup-llm-env.ps1

  默认在 D:\learning\LLMs-from-scratch 下 clone 代码，
  如需修改路径，执行前改 $CODE_DIR 变量。
#>

$CODE_DIR = "D:\learning\LLMs-from-scratch"
$ENV_NAME = "llms"

Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   LLMs-from-scratch 环境搭建脚本     ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Step 1: 检查 conda
Write-Host "[1/4] 检查 conda..." -ForegroundColor Yellow
$condaPath = Get-Command conda -ErrorAction SilentlyContinue
if (-not $condaPath) {
    Write-Host "❌ 没有找到 conda！请先安装 Miniconda:" -ForegroundColor Red
    Write-Host "   https://docs.anaconda.com/miniconda/"
    Write-Host "或直接搜 'Miniconda Windows 安装'"
    exit 1
}
Write-Host "✅ conda 已就绪: $($condaPath.Source)" -ForegroundColor Green

# Step 2: clone 代码
Write-Host "[2/4] 克隆代码仓库..." -ForegroundColor Yellow
$parentDir = Split-Path $CODE_DIR -Parent
if (-not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
}

if (Test-Path $CODE_DIR) {
    Write-Host "  目录已存在，跳过 clone" -ForegroundColor Green
} else {
    git clone --depth 1 https://github.com/rasbt/LLMs-from-scratch.git $CODE_DIR
    Write-Host "✅ clone 完成" -ForegroundColor Green
}

# Step 3: 创建 conda 环境
Write-Host "[3/4] 创建 conda 环境 ($ENV_NAME)..." -ForegroundColor Yellow
$existingEnv = conda env list | Select-String "^$ENV_NAME\s"
if ($existingEnv) {
    Write-Host "  环境 '$ENV_NAME' 已存在，跳过创建" -ForegroundColor Green
} else {
    conda create -n $ENV_NAME python=3.10 -y
    Write-Host "✅ 环境创建完成" -ForegroundColor Green
}

# 激活环境并装依赖
Write-Host "  安装依赖中..." -ForegroundColor Yellow
conda run -n $ENV_NAME pip install -r "$CODE_DIR\requirements.txt" 2>&1 | Out-Null
Write-Host "✅ 依赖安装完成" -ForegroundColor Green

# Step 4: 验证
Write-Host "[4/4] 验证环境..." -ForegroundColor Yellow
$verify = conda run -n $ENV_NAME python -c "import torch; print(f'PyTorch {torch.__version__}'); print(f'CUDA可用: {torch.cuda.is_available()}')" 2>&1
Write-Host $verify -ForegroundColor White

Write-Host ""
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   ✅ 环境搭建完成！                    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "👉 接下来："
Write-Host "   激活环境:  conda activate llms"
Write-Host "   打开代码:  code $CODE_DIR"
Write-Host "   开始学习:  打开 ch02/01_main-chapter-code/ch02.ipynb"
Write-Host ""
Write-Host "📖 每日学习计划在 Obsidian 知识库: 05-LLM从零构建/"
