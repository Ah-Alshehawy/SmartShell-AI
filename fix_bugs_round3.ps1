function Invoke-OpenCode-Safe {
    param (
        [string]$Prompt,
        [string]$OutputFile
    )
    Write-Host "Asking OpenCode (Safely) for $OutputFile ..."
    $body = @{
        model = "qwen2.5-coder:7b"
        prompt = $Prompt
        stream = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 3600
    
    $raw = $response.response
    
    # Extract code between triple backticks if present
    if ($raw -match '(?s)```[a-zA-Z]*\n(.*?)```') {
        $clean = $matches[1]
    } else {
        $clean = $raw
    }
    
    # Remove BOM if present
    $clean = $clean -replace '^\xEF\xBB\xBF', ''
    
    $clean | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Host "Successfully generated and extracted $OutputFile"
}

# 1. Regenerate backend/app.py properly
$prompt_backend = 'You are OpenCode. Write a complete Python script for backend/app.py using FastAPI. Include `app = FastAPI()`. Define GET /logs, GET /rules, POST /rules, and POST /ai/analyze endpoints.'
Invoke-OpenCode-Safe -Prompt $prompt_backend -OutputFile "backend\app.py"

# 2. Regenerate core/firewall_daemon.py properly
$prompt_core = 'You are OpenCode. Write a complete Python script core/firewall_daemon.py using NetfilterQueue and requests to post to http://127.0.0.1:8080/ai/analyze and drop/accept packets.'
Invoke-OpenCode-Safe -Prompt $prompt_core -OutputFile "core\firewall_daemon.py"

Write-Host "Round 3 execution finished."
