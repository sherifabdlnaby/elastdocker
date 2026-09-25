#!/usr/bin/env bash
# Emit compose service names (one per line) for mise task completion.
# Used by the `complete "service"` specs in mise.toml (logs/stop/restart/build/rm).
set -euo pipefail

docker compose \
	-f docker-compose.yml \
	-f docker-compose.monitor.yml \
	-f docker-compose.nodes.yml \
	-f docker-compose.logs.yml \
	config --services 2>/dev/null || true
