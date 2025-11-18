#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ensure_namespace() {
  local namespace="$1"
  if ! kubectl get namespace "${namespace}" >/dev/null 2>&1; then
    kubectl create namespace "${namespace}"
  fi
}

deploy_env() {
  local env="$1"
  local namespace="$env"

  ensure_namespace "${namespace}"

  echo "🚀 Deploying frontend (${env})"
  helm upgrade --install "frontend-${env}" "${ROOT_DIR}/helm/charts/frontend" \
    -n "${namespace}" \
    -f "${ROOT_DIR}/helm/values/frontend/${env}.yaml" \
    --wait

  echo "🚀 Deploying backend (${env})"
  helm upgrade --install "backend-${env}" "${ROOT_DIR}/helm/charts/backend" \
    -n "${namespace}" \
    -f "${ROOT_DIR}/helm/values/backend/${env}.yaml" \
    --wait

  echo "🚀 Deploying postgres (${env})"
  helm upgrade --install "postgres-${env}" "${ROOT_DIR}/helm/charts/postgres" \
    -n "${namespace}" \
    -f "${ROOT_DIR}/helm/values/postgres/${env}.yaml" \
    --wait

  echo "✅ Environment '${env}' déployé."
}

