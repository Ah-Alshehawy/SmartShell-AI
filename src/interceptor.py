import netfilterqueue
from scapy.all import *

def process_packet(packet):
    scapy_packet = IP(packet.get_payload())
    if scapy_packet.haslayer(TCP):
        print(f"Source IP: {scapy_packet[IP].src}")
        print(f"Destination IP: {scapy_packet[IP].dst}")
        print(f"Protocol: TCP")
        print(f"Source Port: {scapy_packet[TCP].sport}")
        print(f"Destination Port: {scapy_packet[TCP].dport}")
    elif scapy_packet.haslayer(UDP):
        print(f"Source IP: {scapy_packet[IP].src}")
        print(f"Destination IP: {scapy_packet[IP].dst}")
        print(f"Protocol: UDP")
        print(f"Source Port: {scapy_packet[UDP].sport}")
        print(f"Destination Port: {scapy_packet[UDP].dport}")
    packet.accept()

def main():
    print("Starting network interceptor...")
    queue = netfilterqueue.NetfilterQueue()
    queue.bind(0, process_packet)
    try:
        queue.run()
    except KeyboardInterrupt:
        print("Stopped by user")

if __name__ == "__main__":
    main()
