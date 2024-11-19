#!/bin/bash

######### Install CSI ############

kubectl create configmap cloud-config --from-file=1_cpi-vsphere.conf --namespace=kube-system 
kubectl create -f 2_cpi-secret.conf  
kubectl create -f  3_cloud-controller-manager-roles.yaml
kubectl create -f  4_cloud-controller-manager-role-bindings.yaml
kubectl create -f  5_cloud-provider.yaml
kubectl create secret generic vsphere-config-secret --from-file=6_csi-vsphere.conf  --namespace=kube-system 
kubectl apply -f 7_csi-driver-rbac.yaml
kubectl create -f 8_csi-controller.yaml
kubectl apply -f 9_csi-driver.yaml 
kubectl apply -f 10_storage-class.yaml 

######### Install Longhorn ########

kubectl create ns longhorn-system
#USER=admin; PASSWORD=admin; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" > longhorn-auth.txt
#kubectl -n longhorn-system create secret generic basic-auth --from-file=longhorn-auth.txt
curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/master/scripts/environment_check.sh | bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.5.1/deploy/longhorn.yaml
kubectl apply -f longhorn-ingress.yml
kubectl patch svc longhorn-frontend -n longhorn-system -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
kubectl -n longhorn-system get pod
