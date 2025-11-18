#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${1:-dev}"

echo "🛰️  Launching k9s (namespace=${NAMESPACE})"
k9s -n "${NAMESPACE}"

