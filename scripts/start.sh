#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

docker stop pm-app 2>/dev/null || true
docker rm pm-app 2>/dev/null || true

cd "$PROJECT_ROOT"
# BuildKit's context sender chokes on exFAT/AppleDouble sidecar files
# (._*) when this repo sits on a non-APFS volume; the legacy builder
# doesn't walk xattrs and avoids the failure.
DOCKER_BUILDKIT=0 docker build -t pm-app .
docker run -d --name pm-app -p 8000:8000 pm-app

echo "App running at http://localhost:8000"
