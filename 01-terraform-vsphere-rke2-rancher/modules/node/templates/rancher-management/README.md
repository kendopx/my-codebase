## Reset Rancher password
kubectl -n cattle-system exec $(kubectl -n cattle-system get pods | grep ^rancher | head -n 1 | awk '{ print $1 }') reset-password
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'
