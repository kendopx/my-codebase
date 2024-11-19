

```sh
telnet 10.130.5.6 1433

SQL_Latin1_General_CP1_CS_AS

k logs  jira-0 -n jira
kubectl get po -n jira
kubectl get svc -n jira
kubectl get ing -n jira
kubectl logs -f jira-0 -n jira
kubectl describe pod  jira-0 -n  jira
kubectl scale sts jira -n jira --replicas=2

k logs  jira-0 -n jira
kubectl get po -n jira
kubectl get svc -n jira
kubectl get ing -n jira
kubectl logs -f jira-0 -n jira

kubectl patch pvc local-home-jira-0 -p '{"metadata":{"finalizers":null}}' -n jira


k delete secret mssql-secret -n jira
kubectl patch pvc local-home-jira-0 -p '{"metadata":{"finalizers":null}}' -n jira


k delete secret mssql-secret -n jira
k delete pvc local-home-jira-0 -n jira

#####################################################################

helm repo add atlassian-data-center https://atlassian.github.io/data-center-helm-charts
helm repo update
helm show values atlassian-data-center/jira > values.yaml

### Create a Kubernetes secret to store the connectivity details of the database:
kubectl create secret generic <secret_name> --from-literal=username='<db_username>'

### 
database:
  type: <db_type>
  url: <jdbc_url>
  driver: <engine_driver>
  credentials:
    secretName: <secret_name>
    usernameSecretKey: username
    passwordSecretKey: password

### Configure license¶
kubectl create secret generic license-secret --from-literal=license-key='license' -n jira

license:
  secretName: license-secret
  secretKey: license-key

### 
helm install <release-name>  atlassian-data-center/<product>  -n jira  --version <chart-version> \
             --values values.yaml

jiradbuser
jiradb

###################################################################

