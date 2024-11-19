    #!/bin/bash

    kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1 
    export argo_url=$(kubectl get svc -n argocd | grep argocd-server | awk '{print $4}' | grep -v none)
    echo "argo_url: http://$argo_url/"
    echo username: "admin"
    echo password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

    export ARGO_URL=$(kubectl get svc -n argocd | grep argocd-server | awk '{print $4}' | grep -v none)
    export ARGO_USERNAME=admin
    export ARGO_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    
    argocd login $ARGO_URL --username $ARGO_USERNAME --password $ARGO_PASSWORD --insecure
    argocd cluster list

   # Register A Cluster To Deploy Apps To (Optional)
    kubectl config use-context test
    kubectl config get-contexts
    argocd cluster add test --insecure 
    argocd cluster list
    argocd proj create test -d https://172.29.0.45:6443, * -s git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git
    argocd proj list test

   # kubectl apply -f wordpress-1.yaml
    argocd app create argo-config-wordpress \
    --repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
    --path wordpress-1 \
    --dest-namespace default \
    --dest-server https://172.29.0.45:6443 \
    --self-heal \
    --project test \
    --sync-policy automated \
    --sync-retry-limit 5 \
    --revision main

    argocd app create argo-config-ldap \
    --repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
    --path ldap/overlays/staging/ \
    --dest-namespace default \
    --dest-server https://172.29.0.45:6443 \
    --self-heal \
    --project test \
    --sync-policy automated \
    --sync-retry-limit 5 \
    --revision main
