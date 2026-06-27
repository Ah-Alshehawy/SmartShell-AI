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
    
    # We use a large timeout because local LLM generation takes time
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 3600
    
    # Save the output to the target file
    $response.response | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Host "Finished writing $OutputFile"
    Write-Host "----------------------------------------"
}

Write-Host "=== Phase 2: AI Connector Module ==="
$prompt2 = "You are OpenCode, the Lead Developer. Write a Python script named ai_connector.py. It must contain a function `analyze_traffic(data)` that takes a dictionary `data` (with src_ip, dst_ip, protocol, ports), and sends a prompt to a local Ollama API (http://localhost:11434/api/generate) using the requests library. The prompt should ask if the traffic is malicious. Parse the JSON response and return a string 'ALLOW' or 'DROP'. Output ONLY the raw Python code without any markdown formatting."
Invoke-OpenCode -Prompt $prompt2 -OutputFile "src\ai_connector.py"

Write-Host "=== Phase 3: Rule Enforcement Engine ==="
$prompt3 = "You are OpenCode. Write a Python script named rule_engine.py. It must contain a function `enforce_rule(ip_address, action)` that takes an IP string and an action string ('ALLOW' or 'DROP'). If 'DROP', use the subprocess module to run an iptables command that drops traffic from that IP. Output ONLY the raw Python code without any markdown formatting."
Invoke-OpenCode -Prompt $prompt3 -OutputFile "src\rule_engine.py"

Write-Host "=== Phase 4: Main Integration ==="
$prompt4 = "You are OpenCode. Write a Python script named main.py. It should import everything necessary from interceptor.py, ai_connector.py, and rule_engine.py. Write the main logic that ties them together: intercept packets, extract data, pass data to analyze_traffic(), and if the verdict is 'DROP', call enforce_rule() to block the IP and drop the packet. Otherwise, accept it. Start the NetfilterQueue. Output ONLY the raw Python code without any markdown formatting."
Invoke-OpenCode -Prompt $prompt4 -OutputFile "src\main.py"

Write-Host "All modules generated successfully by OpenCode."
