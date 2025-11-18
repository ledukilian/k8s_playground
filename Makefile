SHELL := /usr/bin/env bash

K3D_CLUSTER ?= k8s-playground
K3D_CONFIG  ?= k3d/k3d-cluster.yaml
HELM        ?= helm
KUBECTL     ?= kubectl
METRICS_MANIFEST := k8s/metrics-server/metrics-server.yaml

.PHONY: help create-cluster delete-cluster build-images push-images \
        deploy-dev deploy-staging deploy-prod \
        teardown-dev teardown-all \
        metrics k9s port-forward-db lint

help:
	@printf "Kubernetes Playground helper targets:\n"
	@printf "  make create-cluster     # k3d cluster create --config %s\n" "$(K3D_CONFIG)"
	@printf "  make delete-cluster     # k3d cluster delete $(K3D_CLUSTER)\n"
	@printf "  make build-images       # Docker build frontend/backend demos\n"
	@printf "  make push-images        # Push images into the local registry\n"
	@printf "  make deploy-<env>       # Helm upgrade --install (dev|staging|prod)\n"
	@printf "  make teardown-<env>     # Helm uninstall (dev) / teardown-all\n"
	@printf "  make metrics            # Apply metrics-server manifest\n"
	@printf "  make k9s                # Launch k9s on the playground context\n"
	@printf "  make port-forward-db    # Forward PostgreSQL (default: dev)\n"
	@printf "  make lint               # helm lint + kubeval templates\n"

create-cluster:
	./k3d/scripts/create-cluster.sh

delete-cluster:
	./k3d/scripts/delete-cluster.sh

build-images:
	./scripts/build-images.sh

push-images:
	./scripts/push-images-local.sh

deploy-dev:
	./scripts/deploy-dev.sh

deploy-staging:
	./scripts/deploy-staging.sh

deploy-prod:
	./scripts/deploy-prod.sh

teardown-dev:
	./scripts/teardown-dev.sh

teardown-all:
	./scripts/teardown-all.sh

metrics:
	$(KUBECTL) apply -f $(METRICS_MANIFEST)

k9s:
	./scripts/k9s.sh

port-forward-db:
	./scripts/port-forward-db.sh dev

lint:
	$(HELM) lint helm/charts/frontend helm/charts/backend helm/charts/postgres

