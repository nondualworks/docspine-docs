# How to Deploy

Step-by-step guide for deploying the Checkout API.

## Prerequisites

- Access to the `checkout` namespace in Kubernetes
- `kubectl` configured for the target cluster

## Steps

1. Merge your PR to `main`
2. CI pipeline builds and pushes the container image
3. ArgoCD detects the new image tag and syncs
4. Verify the deployment: `kubectl get pods -n checkout`
