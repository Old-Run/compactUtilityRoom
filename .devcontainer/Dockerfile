FROM mcr.microsoft.com/devcontainers/go:1.23-bookworm
ARG DEBIAN_FRONTEND=noninteractive

# 1) 系統套件 + Node + Claude CLI + Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git curl gnupg ca-certificates python3 python3-pip && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm i -g @anthropic-ai/claude-code@latest superclaude@latest && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2) SuperClaude 安裝 —— 把 HOME 指去 /home/vscode
ENV HOME=/home/vscode
RUN mkdir -p $HOME/.claude && \
    git clone --depth=1 https://github.com/NomenAK/SuperClaude.git /opt/superclaude && \
    python3 /opt/superclaude/SuperClaude.py install --quick --yes \
        --install-dir $HOME/.claude && \
    rm -rf /opt/superclaude && \
    chown -R vscode:vscode $HOME/.claude

# 3) Gemini CLI
RUN npm i -g @google/gemini-cli

# 4) MCP 註冊腳本
RUN install -m 0755 /dev/null /usr/local/bin/init_claude.sh && \
cat <<'EOF' >/usr/local/bin/init_claude.sh
#!/usr/bin/env bash
set -euo pipefail
MAGIC_API_KEY="${MAGIC_API_KEY:-}"

echo "🔗  註冊 MCP servers …"
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest || true
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
claude mcp add puppeteer           -- npx -y @modelcontextprotocol/server-puppeteer           || true
claude mcp add magic -e API_KEY="$MAGIC_API_KEY" -- npx -y @21st-dev/magic@latest             || true
echo "✅  Claude & MCP ready!"
EOF

USER vscode

CMD ["bash", "-c", "init_claude.sh && sleep infinity"]
