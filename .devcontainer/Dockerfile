FROM mcr.microsoft.com/devcontainers/go:1.23-bookworm
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace

# 1) 系統套件 + Node + Claude CLI + Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git curl gnupg ca-certificates python3 python3-pip && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm i -g @anthropic-ai/claude-code@latest superclaude@latest && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2) SuperClaude 安裝 —— 把 HOME 指去 /home/vscode
ENV HOME=/home/vscode
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN pip install --no-cache-dir SuperClaude \
    && python3 -m SuperClaude install --quick --yes \
    && mkdir -p "$HOME/.npm" "$HOME/.config"
    
RUN chown -R vscode:vscode $HOME/.claude $HOME/.npm $HOME/.config

# 3) MCP 註冊腳本
RUN install -m 0755 /dev/null /usr/local/bin/init_claude.sh && \
    cat <<'EOF' >/usr/local/bin/init_claude.sh

#!/usr/bin/env bash
set -euo pipefail
MAGIC_API_KEY="${MAGIC_API_KEY:-}"
# 確保 npm 緩存權限正確
if [[ -d "$HOME/.npm" ]]; then
    sudo chown -R $(id -u):$(id -g) "$HOME/.npm" 2>/dev/null || true
fi

echo "🔗  註冊 MCP servers …"
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest || true
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
claude mcp add puppeteer           -- npx -y @modelcontextprotocol/server-puppeteer           || true
claude mcp add magic -e API_KEY="$MAGIC_API_KEY" -- npx -y @21st-dev/magic@latest             || true
echo "✅  Claude & MCP ready!"
EOF

USER vscode

CMD ["bash", "-c", "init_claude.sh && sleep infinity"]
