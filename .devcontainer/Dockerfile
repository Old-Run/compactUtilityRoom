# Go 1.23 - Node 18 - Claude Code + SuperClaude Dev Image
FROM mcr.microsoft.com/devcontainers/go:1.23-bookworm

# 1) 以 root 安裝系統套件、Node 18、Claude CLI

RUN apt-get update \
    && apt-get install -y --no-install-recommends git curl gnupg ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm i -g @anthropic-ai/claude-code@latest superclaude@latest \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/NomenAK/SuperClaude.git /tmp/superclaude \
    && (cd /tmp/superclaude && ./install.sh --force) \
    && rm -rf /tmp/superclaude

COPY init_claude.sh /usr/local/bin/init_claude.sh
RUN chmod +x /usr/local/bin/init_claude.sh

CMD ["bash", "-c", "init_claude.sh && sleep infinity"]
