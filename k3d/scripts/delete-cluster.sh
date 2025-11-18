#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${1:-k8s-playground}"

echo "🧹 Deleting k3d cluster '${CLUSTER_NAME}'..."
k3d cluster delete "${CLUSTER_NAME}"

echo "✅ Cluster removed."

