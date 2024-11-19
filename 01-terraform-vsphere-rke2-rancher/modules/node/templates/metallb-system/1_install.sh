#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml

kubectl create deploy nginx --image nginx:latest
kubectl get all
kubectl expose deploy nginx --port 80 --type LoadBalancer