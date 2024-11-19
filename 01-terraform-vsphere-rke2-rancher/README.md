# Deploy K8s VM's with Terraform on vSphere

Pre-Reqs
__________________________
1. FreeIPA Server - DNS resolver 
https://www.linuxtechi.com/how-to-install-freeipa-server-on-rhel/

# VM's IP Addresses 
172.29.0.62 infra1.kendopz.com
172.29.0.63 infra1.kendopz.com
172.29.0.64 infra1.kendopz.com

Overview 
__________________________
1. VM - Linux OS for Kubernetes nodes 
1. RKE2 - Security focused Kubernetes
1. Rancher - Multi-Cluster Kubernetes Management
1. VMWare CSI -  vSphere Container Storage Interface (CSI) driver
1. Longhorn - Unified storage layer
1. Cert-Manager - Secure Ingress Resources With Cert Manager
1. Ingresses - Load Balancers with MetalLB and nginx-ingress

