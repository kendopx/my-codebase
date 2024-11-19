#!/bin/bash 

helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create ns cert-manager 
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
kubectl get pods --namespace cert-manager

sleep 5

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher10.kendopz.com \
  --set replicas=3 \
  --set bootstrapPassword=admin 
kubectl get pod -n cattle-system
