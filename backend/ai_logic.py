import requests

def analyze_packet(packet_data: dict) -> str:
    prompt = f"Decide whether to 'accept' or 'drop' the packet based on its src_ip, dst_ip, and protocol. Source IP: {packet_data['src_ip']}, Destination IP: {packet_data['dst_ip']}, Protocol: {packet_data['protocol']}"
    
    try:
        response = requests.post("http://host.docker.internal:11434/api/generate", json={"prompt": prompt, "model": "qwen2.5-coder:7b"})
        response.raise_for_status()
        
        result = response.json().get('response', '')
        if 'drop' in result:
            return 'drop'
        elif 'accept' in result:
            return 'accept'
        else:
            return 'drop'
    except requests.RequestException:
        return 'drop'

