FROM ubuntu:24.04

# Install core dependencies for networking, firewall management, and Python (for prototyping)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    iptables \
    nftables \
    libnetfilter-queue-dev \
    build-essential \
    curl \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Initialize a virtual environment for Python development
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Dummy entrypoint, to keep container alive for dev
CMD ["tail", "-f", "/dev/null"]
