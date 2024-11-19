#!/bin/bash
helm uninstall jira -n jira
kubectl delete secret mssql-secret -n jira
kubectl delete pvc local-home-jira-0 -n jira
kubectl delete ns jira
kubectl get ns

