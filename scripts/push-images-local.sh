#!/usr/bin/env bash
set -euo pipefail

REGISTRY="${REGISTRY:-k3d-playground-registry.localhost:5111}"
IMAGES=(
  "frontend:latest"
  "frontend:dev"
  "frontend:staging"
  "frontend:prod"
  "backend:latest"
  "backend:dev"
  "backend:staging"
  "backend:prod"
)

for image in "${IMAGES[@]}"; do
  echo "📦 Pushing ${REGISTRY}/${image}"
  docker push "${REGISTRY}/${image}"
done

echo "✅ Push terminé."

