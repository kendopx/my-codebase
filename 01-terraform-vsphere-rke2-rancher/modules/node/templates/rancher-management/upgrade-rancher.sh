#!/bin/bash

helm list -n cattle-system
kubectl get po -n cattle-system
helm upgrade rancher rancher-latest/rancher \
  --namespace cattle-system
kubectl -n cattle-system rollout status deploy/rancher
~
