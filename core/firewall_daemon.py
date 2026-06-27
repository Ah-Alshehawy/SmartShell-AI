#!/usr/bin/env python3
import socket
import struct
from scapy.all import IP, TCP, UDP

def packet_callback(packet):
    try:
        ip_packet = IP(packet.get_payload())
        src = ip_packet.src
        dst = ip_packet.dst
        proto = ip_packet.proto

        if proto == 6:  # TCP
            tcp_layer = ip_packet[TCP]
            sport = tcp_layer.sport
            dport = tcp_layer.dport
        elif proto == 17:  # UDP
            udp_layer = ip_packet[UDP]
            sport = udp_layer.sport
            dport = udp_layer.dport
        else:
            return

        metadata = {
            'src': src,
            'dst': dst,
            'proto': proto,
            'sport': sport,
            'dport': dport
        }

        response = requests.post('http://127.0.0.1:8080/ai/analyze', json=metadata)
        action = response.json().get('action')

        if action == 'accept':
            return netfilterqueue.CONTINUE
        elif action == 'drop':
            return netfilterqueue.DROP

    except Exception as e:
        print(f"Error: {e}")
        return netfilterqueue.CONTINUE

if __name__ == "__main__":
    import netfilterqueue
    queue = netfilterqueue.NetfilterQueue()
    queue.bind(1, packet_callback)
    queue.run()

