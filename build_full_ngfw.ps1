# Setup Directories
New-Item -ItemType Directory -Force -Path "backend"
New-Item -ItemType Directory -Force -Path "frontend\src"
New-Item -ItemType Directory -Force -Path "core"

function Invoke-OpenCode {
    param (
        [string]$Prompt,
        [string]$OutputFile
    )
    Write-Host "Asking OpenCode to generate $OutputFile ..."
    $body = @{
        model = "qwen2.5-coder:7b"
        prompt = $Prompt
        stream = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 3600
    
    $response.response | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Host "Finished writing $OutputFile"
    Write-Host "----------------------------------------"
}

Write-Host "=== Phase 2: Backend & Database ==="
$prompt_db = "You are OpenCode. Write a complete Python script for backend/database.py using SQLAlchemy. It should define two tables: 'Log' (id, src_ip, dst_ip, protocol, action, timestamp) and 'Rule' (id, ip, action). Provide ONLY the raw Python code without any markdown formatting."
Invoke-OpenCode -Prompt $prompt_db -OutputFile "backend\database.py"

$prompt_api = "You are OpenCode. Write a complete Python script for backend/app.py using FastAPI. It should import the models from database.py. It must have API endpoints to GET /logs, GET /rules, POST /rules, and a POST /ai/analyze endpoint that takes network data, queries local Ollama at http://localhost:11434/api/generate to ask if it's malicious, and returns 'ALLOW' or 'DROP'. Provide ONLY the raw Python code without any markdown formatting."
Invoke-OpenCode -Prompt $prompt_api -OutputFile "backend\app.py"

Write-Host "=== Phase 3: Frontend GUI ==="
$prompt_pkg = "You are OpenCode. Write a package.json file for a React Vite project. Include dependencies for react, react-dom, axios, and tailwindcss. Provide ONLY the raw JSON without any markdown formatting."
Invoke-OpenCode -Prompt $prompt_pkg -OutputFile "frontend\package.json"

$prompt_jsx = "You are OpenCode. Write a complete React component for frontend/src/App.jsx. It should use axios to fetch /logs and /rules from http://localhost:8000 and display them in two tables. Use Tailwind classes for a modern Dashboard look. Provide ONLY the raw JSX code without any markdown formatting."
Invoke-OpenCode -Prompt $prompt_jsx -OutputFile "frontend\src\App.jsx"

Write-Host "=== Phase 4: Core Firewall Daemon ==="
$prompt_daemon = "You are OpenCode. Write a Python script core/firewall_daemon.py. It should use NetfilterQueue to intercept packets. Extract src_ip, dst_ip, ports. Make an HTTP POST request to the backend API at http://localhost:8000/ai/analyze. If the response is 'DROP', use subprocess to add an iptables rule blocking the IP and drop the packet. Else accept it. Provide ONLY the raw Python code without any markdown formatting."
Invoke-OpenCode -Prompt $prompt_daemon -OutputFile "core\firewall_daemon.py"

Write-Host "All comprehensive NGFW modules generated successfully by OpenCode."
