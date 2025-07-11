#!/usr/bin/env bash
set -euo pipefail

MAGIC_API_KEY="${MAGIC_API_KEY:-}"

echo "🔗  註冊 MCP servers …"
claude mcp add --transport http context7 https://mcp.context7.com/mcp      || true
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
claude mcp add puppeteer           -- npx -y @modelcontextprotocol/server-puppeteer           || true
claude mcp add magic -e API_KEY="$MAGIC_API_KEY" -- npx -y @21st-dev/magic@latest             || true

echo "✅  Claude & MCP ready!"
