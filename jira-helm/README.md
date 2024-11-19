```sh
helm install jira atlassian-data-center/jira  -n jira -f jira-values.yaml 
helm upgrade -i jira atlassian-data-center/jira --namespace jira --create-namespace --values jira-values.yaml

export NODE_PORT=$(kubectl get --namespace jira -o jsonpath="{.spec.ports[0].nodePort}" services jira)
export NODE_IP=$(kubectl get nodes --namespace jira -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT


export POD_NAME=$(kubectl get pods --namespace jira -l "app.kubernetes.io/instance=jira" -o jsonpath="{.items[0].metadata.name}")
echo POD_NAME: $POD_NAME && echo POD_STATUS: $(kubectl get pod $POD_NAME -o jsonpath='{.status.phase}')
kubectl --namespace jira  port-forward $POD_NAME 8080

kubectl patch svc jira -n jira -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
kubectl scale sts jira -n jira --replicas=2

kubectl edit statefulsets -n jira <stateful-set-name>
kubectl patch statefulsets <stateful-set-name> -p '{"spec":{"replicas":2}}'
kubectl patch statefulsets  jira -n jira -p '{"spec":{"replicas":1}}'

SQL_Latin1_General_CP1_CI_AS

k logs  jira-0 -n jira
kubectl get po -n jira
kubectl get svc -n jira
kubectl get ing -n jira
kubectl logs -f jira-0 -n jira
kubectl describe pod  jira-0 -n  jira
helm uninstall jira -n jira 

### atlassian-database-poc
10.130.5.72

kubectl patch pvc local-home-jira-0 -p '{"metadata":{"finalizers":null}}' -n jira
telnet 10.130.5.6 1433

k delete secret mssql-secret -n jira
k delete pvc local-home-jira-0 -n jira

