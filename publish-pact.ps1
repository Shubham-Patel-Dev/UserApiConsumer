# Publish Pact to Broker Manually
# Run this script from your local machine after tests pass

param(
    [string]$Version = ""
)

$pactFile = "pacts\UserApiConsumer-UserApiProvider.json"
$brokerUrl = "http://puvsfpactserver.tiger01-dev.ba.lab.local:9292"
$consumerName = "UserApiConsumer"
$providerName = "UserApiProvider"

# Check if pact file exists
if (-not (Test-Path $pactFile)) {
    Write-Host "❌ Pact file not found. Run tests first: dotnet test" -ForegroundColor Red
    exit 1
}

# If no version provided, use git commit hash or timestamp
if ([string]::IsNullOrEmpty($Version)) {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $Version = git rev-parse --short HEAD
        Write-Host "📌 Using git commit hash: $Version" -ForegroundColor Cyan
    } else {
        $Version = Get-Date -Format "yyyy-MM-dd-HHmmss"
        Write-Host "📌 Using timestamp: $Version" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "🚀 Publishing Pact to Broker..." -ForegroundColor Cyan
Write-Host "   Consumer: $consumerName" -ForegroundColor White
Write-Host "   Provider: $providerName" -ForegroundColor White
Write-Host "   Version:  $Version" -ForegroundColor White
Write-Host "   Broker:   $brokerUrl" -ForegroundColor White
Write-Host ""

# Publish pact
$url = "$brokerUrl/pacts/provider/$providerName/consumer/$consumerName/version/$Version"
$response = curl.exe -X PUT -H "Content-Type: application/json" -d "@$pactFile" "$url" -w "%{http_code}" -o temp_response.json -s

if ($LASTEXITCODE -eq 0) {
    $statusCode = $response
    $responseBody = Get-Content temp_response.json -Raw | ConvertFrom-Json
    Remove-Item temp_response.json -ErrorAction SilentlyContinue
    
    Write-Host "✅ Pact published successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔗 View in broker:" -ForegroundColor Cyan
    Write-Host "   $brokerUrl" -ForegroundColor White
    
    # Tag with 'main' branch
    Write-Host ""
    Write-Host "🏷️  Tagging version as 'main'..." -ForegroundColor Cyan
    $tagUrl = "$brokerUrl/pacticipants/$consumerName/versions/$Version/tags/main"
    curl.exe -X PUT "$tagUrl" -s -o $null
    Write-Host "✅ Tagged successfully!" -ForegroundColor Green
    
} else {
    Write-Host "❌ Failed to publish pact" -ForegroundColor Red
    Remove-Item temp_response.json -ErrorAction SilentlyContinue
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ All done!" -ForegroundColor Green
Write-Host "The provider can now fetch this pact from the broker for verification." -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
