#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="${REGISTRY:-k3d-playground-registry.localhost:5111}"

echo "🏗️  Building frontend image…"
docker build \
  -t "${REGISTRY}/frontend:latest" \
  -t "${REGISTRY}/frontend:dev" \
  -t "${REGISTRY}/frontend:staging" \
  -t "${REGISTRY}/frontend:prod" \
  "${ROOT_DIR}/docker/frontend"

echo "🏗️  Building backend image…"
docker build \
  -t "${REGISTRY}/backend:latest" \
  -t "${REGISTRY}/backend:dev" \
  -t "${REGISTRY}/backend:staging" \
  -t "${REGISTRY}/backend:prod" \
  "${ROOT_DIR}/docker/backend"

echo "✅ Images built (stored locally)."

