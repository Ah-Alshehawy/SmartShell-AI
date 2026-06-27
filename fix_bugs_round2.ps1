function Invoke-OpenCode {
    param (
        [string]$Prompt,
        [string]$OutputFile
    )
    Write-Host "Asking OpenCode to fix $OutputFile ..."
    $body = @{
        model = "qwen2.5-coder:7b"
        prompt = $Prompt
        stream = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 3600
    
    $cleanText = $response.response -replace '^\xEF\xBB\xBF', ''
    $cleanText = $cleanText -replace '^```[a-zA-Z]*\n', ''
    $cleanText = $cleanText -replace '\n```$', ''
    $cleanText = $cleanText -replace '```', ''
    $cleanText | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Host "Finished fixing $OutputFile"
}

# 1. Fix backend/app.py
$prompt_backend = 'You are OpenCode. Your previous FastAPI code crashed because the ASGI app was missing. Please rewrite backend/app.py ensuring you include app = FastAPI() and define all endpoints. Output ONLY raw python code.'
Invoke-OpenCode -Prompt $prompt_backend -OutputFile "backend\app.py"

# 2. Fix frontend/vite.config.js
$prompt_vite = 'You are OpenCode. Your previous vite.config.js crashed with Unterminated string literal. Please rewrite a valid vite.config.js for React without syntax errors. Output ONLY raw javascript code.'
Invoke-OpenCode -Prompt $prompt_vite -OutputFile "frontend\vite.config.js"

# 3. Clean firewall_daemon.py
$content = Get-Content "core\firewall_daemon.py" -Raw
$prompt_core = "You are OpenCode. Output this code exactly as is, but ensure there are absolutely no markdown backticks at the beginning or end:`n`n$content"
Invoke-OpenCode -Prompt $prompt_core -OutputFile "core\firewall_daemon.py"

Write-Host "All Round 2 bugs fixed via OpenCode!"
