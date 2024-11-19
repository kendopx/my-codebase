#!/bin/bash

kubectl create ns jira
#kubectl apply -f jira-localhome-pvc.yaml
#kubectl apply -f jira-sharedhome-pvc.yaml

#helm repo update
kubectl -n jira create secret generic license-secret --from-file=jira-helm/license-key
kubectl -n jira create secret generic postgres-secret --from-literal=username=postgres --from-literal=password=postgres

helm upgrade -i jira atlassian-data-center/jira --namespace jira --create-namespace --values jira-helm/jira-values.yaml
kubectl get pod -n jira
kubectl get svc -n jira
kubectl get ing -n jira
kubectl get ns
sleep 30s
kubectl get po -n jira -w
