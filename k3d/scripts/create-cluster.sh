#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_FILE="${ROOT_DIR}/k3d/k3d-cluster.yaml"
CLUSTER_NAME="k8s-playground"

echo "🚀 Creating k3d cluster '${CLUSTER_NAME}'..."
k3d cluster create --config "${CONFIG_FILE}"

echo "✅ Cluster ready. Current context:"
kubectl config current-context

echo "ℹ️  Useful commands:"
echo "    kubectl get nodes"
echo "    kubectl get pods -A"

