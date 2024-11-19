#!/bin/bash

kubectl annotate storageclass longhorn storageclass.kubernetes.io/is-default-class=true --overwrite
sleep 10
kubectl annotate storageclass vsphere-csi storageclass.kubernetes.io/is-default-class=false --overwrite
kubectl get storageclass
