#####################################################################################################
#                                                                                                   #
# RKE2 post-installation                                                                            #
#                                                                                                   #
#####################################################################################################

# Virtual instance deployment status
resource "null_resource" "virtual_instance_deployment" {
    provisioner local-exec { 
    command = <<-EOT
     echo " "      
     echo "Virtual instance deploy complete successfully --------------------------------------> Kubernetes mechanic" 
  EOT
    on_failure = continue
  }  
}  

# Authenticate to the node via ssh 
resource "null_resource" "manifest_config_files" {
  # count = var.vms_count
  connection {
    user           = "root"
    private_key    = file("~/.ssh/id_rsa")
    host           = vsphere_virtual_machine.vm[0].default_ip_address        
    port           = 22
    agent       = false
    type        = "ssh"    
  }

# Copy manifests folder to the node  
  provisioner "file" {
    source      = "${path.module}/templates/manifests"
    destination = "/opt"
    on_failure = continue
  }

# Deploy manifest 
  provisioner "remote-exec" {
    inline = [ 
      "cd /opt/manifests/scripts",
      "chmod +x kustomize.sh", 
      "sleep 10m; sh kustomize.sh | tee -a kustomize.log",
    ]
    on_failure = continue   
  }

# Cluster Healthcheck  
  provisioner local-exec { 
    command = <<-EOT
     scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@172.29.0.45:/etc/rancher/rke2/rke2-argo.yaml .
     sed -i 's/default/argo/g' rke2-argo.yaml 

     cp rke2-argo.yaml ~/.kube/clusters/argo.config
     sh "${path.module}/templates/manifests/scripts/healthcheck.sh" | tee -a healthcheck.log
     sh "${path.module}/templates/manifests/scripts/kubeconfig-auto.sh" | tee -a kubeconfig-auto.log

     echo " "     
     echo "CHECKING LONGHORN STATUS -----------------------------------------------------------> Kubernetes mechanic"     
     kubectl get pod -n longhorn-system --kubeconfig rke2-argo.yaml  
  EOT
    on_failure = continue
  }  
  depends_on = [vsphere_virtual_machine.vm]   
}

##########################################################################################################################



#https://developer.hashicorp.com/consul/tutorials/get-started-kubernetes/kubernetes-gs-deploy

# ssh -q -o StrictHostKeyChecking=no root@172.29.0.45 'kubectl get pods -n longhorn-system -w'
# ssh -q -o StrictHostKeyChecking=no root@172.29.0.45 'kubectl get storageclass'

# ssh -q -o StrictHostKeyChecking=no root@172.29.0.45 'kubectl get nodes'
## 1. install vsphere csi / longhorn                                =  done 
## 2. install dashboard                                             =
## 3. create service account                                        =  done 
## 4. install cert-manager / let's encrypt                          =  done 
## 5. install rancher                                               =  done 
## 6. install metallb                                               =  done 
## 7. install velero                                                =
## 8. install argocd / configure and add repo                       =
## 9. install gitlab                                                =
## 10. install wordpress                                            =
## 11. install consul/vault 
## 12. install monitoring / prometheus / grafanal and configure them 
## 13. integrate with github 
## 14. integrate with slacks 
## 15. integrate with teams 
## 16. integrate with external/cloudflared 
## 17. install mysql

# git clone https://gitlab.com/Chabane87/vault-aws-eks.git
# git clone https://github.com/jacobmammoliti/vault-terraform-demo.git
# https://developer.hashicorp.com/vault/docs/platform/k8s/helm/terraform
# https://developer.hashicorp.com/vault/docs/platform/k8s/helm
# https://www.arthurkoziel.com/setting-up-argocd-with-helm/
# https://deepsource.com/blog/setup-vault-Kubernetes mechanic
# https://developer.hashicorp.com/vault/docs/platform/k8s/helm

# kustomize 
# ldap /ad integration 
# create dns record 
# output rancher url and all the url 
# working_dir = "/tmp"

# So I made an ansible role that does this for me, and I put

# provisioner "local-exec" {
#   when    = "destroy"
#   command = "ansible-playbook playbooks/unregister_rhsm.yml"
# }

# subscription-manager remove --all
# subscription-manager unregister
# subscription-manager clean

##########################################################################################################################
