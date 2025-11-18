#!/usr/bin/env bash
set -euo pipefail

ENV="${1:-dev}"
NAMESPACE="${ENV}"
SERVICE="postgres-${ENV}"

case "${ENV}" in
  dev) LOCAL_PORT=15432 ;;
  staging) LOCAL_PORT=25432 ;;
  prod) LOCAL_PORT=35432 ;;
  *)
    LOCAL_PORT=15432
    ;;
esac

echo "📡 Port-forward ${SERVICE}.${NAMESPACE} -> localhost:${LOCAL_PORT}"
echo "    Connexion: psql postgres://playground:<password>@localhost:${LOCAL_PORT}/<database>"

kubectl port-forward "svc/${SERVICE}" "${LOCAL_PORT}:5432" -n "${NAMESPACE}"

