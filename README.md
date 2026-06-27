# AI-Powered Open Source Firewall (AIFW)

## Overview
AIFW is an open-source, AI-driven firewall designed to run natively on Linux, OPNsense, and pfSense. It leverages local, user-provided Large Language Models (LLMs) to analyze network traffic, detect anomalies, and enforce security policies without relying on external cloud APIs, ensuring maximum privacy and data security (Bring Your Own Model).

## Key Features
- **Cross-Platform**: Runs on Linux (iptables/nftables), OPNsense, and pfSense (FreeBSD/pf).
- **AI-Powered**: Uses local AI models to analyze traffic patterns, logs, and payloads.
- **Privacy First**: Bring Your Own Model (BYOM). No data leaves your network.
- **Dynamic Rules**: Automatically adapts rules based on AI analysis of emerging threats.

## Development Environment
The development environment is built on Docker Desktop, providing a simulated network and the necessary AI backend.

## Roles
- **Project Manager**: Antigravity (AI Assistant)
- **Lead Developer**: OpenCode (`qwen2.5-coder:7b` via Ollama)

## Getting Started
See `ARCHITECTURE.md` for system design and the `docker-compose.yml` for setting up the local environment.
