#!/usr/bin/env bash
set -euo pipefail

ENVS=("dev" "staging" "prod")

for env in "${ENVS[@]}"; do
  namespace="${env}"
  for release in "frontend-${env}" "backend-${env}" "postgres-${env}"; do
    if helm status "${release}" -n "${namespace}" >/dev/null 2>&1; then
      echo "🧹 helm uninstall ${release} (ns=${namespace})"
      helm uninstall "${release}" -n "${namespace}"
    fi
  done
done

echo "✅ Tous les environnements ont été nettoyés."

