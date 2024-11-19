https://www.arthurkoziel.com/setting-up-argocd-with-helm/

Setting up Argo CD with Helm

To create the umbrella chart we make a directory in our Git repository and place two files in it:

$ mkdir -p charts/argo-cd
charts/argo-cd/Chart.yaml

apiVersion: v2
name: argo-cd
version: 1.0.0
dependencies:
  - name: argo-cd
    version: 4.2.2
    repository: https://argoproj.github.io/argo-helm
charts/argo-cd/values.yaml

argo-cd:
  dex:
    enabled: false
  server:
    extraArgs:
      - --insecure
    config:
      repositories: |
        - type: helm
          name: argo-cd
          url: https://argoproj.github.io/argo-helm


For this tutorial we override the following values:

We disable the dex component that is used for integration with external auth providers
We start the server with the --insecure flag to serve the Web UI over http (This is assuming we’re using a local k8s server without TLS setup)
We add the Argo CD Helm repository to the repositories list to be used by applications
The password for the admin user is set to argocd
Before we install the chart we need to generate a Chart.lock file:

$ helm repo add argo-cd https://argoproj.github.io/argo-helm
$ helm dep update charts/argo-cd/

We exclude it by creating a .gitignore file in the chart directory:

$ echo "charts/" > charts/argo-cd/.gitignore
The chart is now ready to push to our Git repository:

$ git add charts/argo-cd
$ git commit -m 'add argo-cd chart'
$ git push


Installing our Argo CD Helm chart
We install Argo CD manually via the Helm CLI:

$ helm install argo-cd charts/argo-cd/
Accessing the Web UI
The Helm chart doesn’t install an Ingress by default, to access the Web UI we have to port-forward to the argocd-server service:

$ kubectl port-forward svc/argo-cd-argocd-server 8080:443
We can then visit http://localhost:8080 to access it.

The default username is admin. The password is auto-generated and we can get it with:
$ kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d