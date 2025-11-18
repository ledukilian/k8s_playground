#!/usr/bin/env bash
set -euo pipefail

ENV="dev"
NAMESPACE="${ENV}"
RELEASES=("frontend-${ENV}" "backend-${ENV}" "postgres-${ENV}")

for release in "${RELEASES[@]}"; do
  if helm status "${release}" -n "${NAMESPACE}" >/dev/null 2>&1; then
    echo "🧹 helm uninstall ${release}"
    helm uninstall "${release}" -n "${NAMESPACE}"
  fi
done

echo "✅ Environnement dev nettoyé."

