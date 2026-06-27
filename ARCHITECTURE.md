# System Architecture

## Core Components

1. **Traffic Interceptor Module**: 
   - Linux: Uses `NFQUEUE` / `eBPF` to intercept packets.
   - pfSense/OPNsense: Uses `pflog` or a custom packet filter integration.

2. **AI Analysis Engine (AIE)**:
   - Connects to a local inference server (e.g., Ollama).
   - Prompts the user-provided model with parsed network data, anomaly metrics, or logs.
   - Evaluates whether traffic is benign or malicious based on behavior and patterns.

3. **Rule Management Engine**:
   - Dynamically translates AI decisions into firewall rules (e.g., block IP, rate-limit subnet).
   - Applies rules to the underlying firewall subsystem (`iptables`, `nftables`, `pf`).

4. **User Interface (UI)**:
   - A local dashboard to view AI decisions, configure the AI model endpoints, and manually override rules.

## Data Flow
1. Packet arrives at network interface.
2. Interceptor captures metadata and passes it to the AI Engine.
3. AI Engine queries the local model (`qwen2.5-coder:7b` for dev, user's choice for prod).
4. Model responds with a verdict (Allow/Block/Log).
5. Rule Engine applies the verdict.
