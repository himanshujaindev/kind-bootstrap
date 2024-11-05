#!/bin/bash
set -x

brew install kind

CLUSTER_NAME="test"

# Check if the cluster already exists, else create kind cluster
if kind get clusters | grep -q "${CLUSTER_NAME}"; then
    echo "Cluster '${CLUSTER_NAME}' already exists. Skipping creation."
else
    echo "Creating cluster '${CLUSTER_NAME}'..."
    kind create cluster --name "${CLUSTER_NAME}" --config kind.yaml
fi

### Create platform namespace
kubectl create namespace platform

### Metric Server - https://artifacthub.io/packages/helm/metrics-server/metrics-server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server --namespace kube-system --values metrics-server.yaml
