function Invoke-OpenCode {
    param (
        [string]$Prompt,
        [string]$OutputFile
    )
    Write-Host "Asking OpenCode to generate/fix $OutputFile ..."
    $body = @{
        model = "qwen2.5-coder:7b"
        prompt = $Prompt
        stream = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 3600
    
    # We must explicitly clean up any backticks that the model still insists on returning
    $cleanText = $response.response -replace '^```\w*\n', '' -replace '\n```$', ''
    $cleanText | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Host "Finished $OutputFile"
}

# 1. Ask OpenCode to strip markdown from the files it messed up
$files = @("backend\app.py", "backend\database.py", "core\firewall_daemon.py", "frontend\src\App.jsx")
foreach ($f in $files) {
    $content = Get-Content $f -Raw
    $prompt = "You are OpenCode. You made a mistake by including markdown formatting tags like ```python in the following code. Please output the EXACT SAME CODE but without ANY markdown tags or backticks around it:\n\n$content"
    Invoke-OpenCode -Prompt $prompt -OutputFile $f
}

# 2. Ask OpenCode to generate missing Vite files
$prompt_html = "You are OpenCode. Write a complete index.html for a React Vite project. It should have a div with id='root' and a script tag importing '/src/main.jsx' as a module. Output ONLY the raw HTML code without markdown formatting."
Invoke-OpenCode -Prompt $prompt_html -OutputFile "frontend\index.html"

$prompt_main = "You are OpenCode. Write a complete main.jsx for a React Vite project. It should import React, ReactDOM, App from './App', and render App into the 'root' element. Output ONLY the raw JSX code without markdown formatting."
Invoke-OpenCode -Prompt $prompt_main -OutputFile "frontend\src\main.jsx"

$prompt_vite = "You are OpenCode. Write a complete vite.config.js for a React Vite project. It should import defineConfig from 'vite' and react from '@vitejs/plugin-react' and export the default config using the react plugin. Output ONLY the raw JS code without markdown formatting."
Invoke-OpenCode -Prompt $prompt_vite -OutputFile "frontend\vite.config.js"

Write-Host "All fixes applied via OpenCode!"
