FROM ubuntu:24.04
RUN apt-get update && apt-get install -y python3 python3-pip iptables libnetfilter-queue-dev build-essential && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN pip3 install --break-system-packages netfilterqueue requests scapy IPy
CMD ["python3", "firewall_daemon.py"]
