import netfilterqueue
import requests
from IPy import IP

def process_packet(packet):
    # Get the data of the packet
    payload = packet.get_payload()
    
    try:
        # Convert payload to string and decode from utf-8
        payload_str = payload.decode('utf-8', errors='ignore')
        
        # Check if the payload is a valid IP address
        ip_address = IP(payload_str)
        
        # Analyze the packet using an AI service
        response = requests.post("http://127.0.0.1:8080/ai/analyze", json={"ip": str(ip_address)})
        
        if response.status_code == 200:
            analysis_result = response.json()
            
            # Check the analysis result to decide whether to accept or drop the packet
            if analysis_result.get("action") == "accept":
                print(f"Packet accepted for {ip_address}")
                packet.accept()
            else:
                print(f"Packet dropped for {ip_address}")
                packet.drop()
        else:
            print(f"Failed to analyze packet: {response.status_code}")
    except Exception as e:
        print(f"Error processing packet: {e}")

def run_firewall_daemon():
    # Create a NetfilterQueue instance
    queue = netfilterqueue.NetfilterQueue()
    
    # Bind the queue number to the process_packet function
    queue.bind(1, process_packet)
    
    try:
        # Start the packet processing loop
        print("Firewall daemon started. Listening for packets...")
        queue.run()
    except KeyboardInterrupt:
        # Handle Ctrl+C to gracefully stop the script
        print("Firewall daemon stopped.")
    finally:
        # Clean up by flushing the NetfilterQueue
        queue.unbind()

if __name__ == "__main__":
    run_firewall_daemon()

