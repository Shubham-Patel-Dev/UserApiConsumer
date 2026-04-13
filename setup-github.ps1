# Setup script for pushing to GitHub

Write-Host "🚀 Setting up Git repository and pushing to GitHub..." -ForegroundColor Cyan

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Initialize git if not already initialized
if (-not (Test-Path .git)) {
    Write-Host "📦 Initializing Git repository..." -ForegroundColor Yellow
    git init
    git branch -M main
} else {
    Write-Host "✓ Git repository already initialized" -ForegroundColor Green
}

# Add all files
Write-Host "📝 Adding files to Git..." -ForegroundColor Yellow
git add .

# Commit
Write-Host "💾 Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial consumer setup with Pact contract test"

# Prompt for GitHub repository URL
Write-Host ""
Write-Host "=================================================================================" -ForegroundColor Cyan
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Create a new repository on GitHub (https://github.com/new)" -ForegroundColor White
Write-Host "   - Repository name: UserApiConsumer" -ForegroundColor White
Write-Host "   - Make it public or private (your choice)" -ForegroundColor White
Write-Host "   - DO NOT initialize with README, .gitignore, or license" -ForegroundColor White
Write-Host ""
Write-Host "2. After creating, copy the repository URL" -ForegroundColor White
Write-Host "   Example: https://github.com/YOUR_USERNAME/UserApiConsumer.git" -ForegroundColor White
Write-Host "=================================================================================" -ForegroundColor Cyan
Write-Host ""

$repoUrl = Read-Host "Enter your GitHub repository URL (or press Enter to skip)"

if ($repoUrl) {
    Write-Host "🔗 Adding remote origin..." -ForegroundColor Yellow
    git remote add origin $repoUrl 2>$null
    if (-not $?) {
        git remote set-url origin $repoUrl
    }
    
    Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    Write-Host ""
    Write-Host "✅ SUCCESS! Your code is now on GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "The GitHub Actions pipeline will automatically:" -ForegroundColor Cyan
    Write-Host "  1. Run the contract test" -ForegroundColor White
    Write-Host "  2. Generate the pact file" -ForegroundColor White
    Write-Host "  3. Publish it to: http://puvsfpactserver.tiger01-dev.ba.lab.local:9292/" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "⏭️  Skipping GitHub push. You can do it manually later:" -ForegroundColor Yellow
    Write-Host "   git remote add origin YOUR_REPO_URL" -ForegroundColor White
    Write-Host "   git push -u origin main" -ForegroundColor White
}

Write-Host ""
Write-Host "📊 View your pact in the broker:" -ForegroundColor Cyan
Write-Host "   http://puvsfpactserver.tiger01-dev.ba.lab.local:9292/" -ForegroundColor White
Write-Host ""
