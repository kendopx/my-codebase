#!/bin/bash

kubectl create namespace argocd
kubectl apply -f argocd-install.yaml -n argocd
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# helm repo add argo-cd https://argoproj.github.io/argo-helm
# helm dep update charts/argo-cd/
# https://www.arthurkoziel.com/setting-up-argocd-with-helm/