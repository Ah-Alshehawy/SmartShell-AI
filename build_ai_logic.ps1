function Invoke-OpenCode-Safe {
    param (
        [string]$Prompt,
        [string]$OutputFile
    )
    $body = @{
        model = "qwen2.5-coder:7b"
        prompt = $Prompt
        stream = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 3600
    
    $raw = $response.response
    if ($raw -match '(?s)```[a-zA-Z]*\n(.*?)```') {
        $clean = $matches[1]
    } else {
        $clean = $raw
    }
    
    $clean = $clean -replace '^\xEF\xBB\xBF', ''
    $clean | Out-File -FilePath $OutputFile -Encoding utf8
}

$prompt_ai = "Output ONLY raw python code. DO NOT wrap it in markdown. DO NOT output the filename. DO NOT output conversational text. Import requests. Define a function analyze_packet(packet_data: dict) -> str. It must use requests.post to send a prompt to Ollama at http://host.docker.internal:11434/api/generate. The model is qwen2.5-coder:7b. The prompt asks to decide whether to 'accept' or 'drop' the packet based on its src_ip, dst_ip, and protocol. Extract the word 'drop' or 'accept' from the response. Return 'accept' or 'drop'."
Invoke-OpenCode-Safe -Prompt $prompt_ai -OutputFile "backend\ai_logic.py"
