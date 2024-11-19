variable "kubevip" {
  description = "IP pool for kube-vip L2 Configuration"
  type = object({
    load_balancer_ip = string
  })
}

variable "node" {
  description = "Properties for MachinePool node types"
  type = object({
    ctl_plane = map(any)
    worker    = map(any)
  })
}

variable "rancher_env" {
  description = "Variables for Rancher environment"
  type = object({
    cloud_credential    = string
    cluster_annotations = map(string)
    cluster_labels      = map(string)
    rke2_version        = string
  })
}

variable "vsphere_env" {
  description = "Variables for vSphere environment"
  type = object({
    cloud_image_name = string
    datacenter       = string
    datastore        = string
    ds_url           = string
    library_name     = string
    server           = string
    user             = string
    vm_network       = list(string)
  })
}
variable "stage" {
}
variable "registry01" {
}
variable "registry02" {
}
variable "registryusername" {
}
variable "registrypassword" {
}
variable "clustername" {
}
variable "ntpservers" {
  type = list(string)
}


variable "hcp_client_id" {
  type        = string
  description = "vault-secret client id"
  default     = ""
}

variable "hcp_client_secret" {
  type        = string
  description = "vault client secret id"
  default     = ""
}

variable "ssh_port" {
  type        = number
  description = "SSH port for remote file"
  default     = 22
}

variable "ssh_user" {
  type        = string
  description = "SSH user for remote file"
  default     = "root"

}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for remote file"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCXkJlT8CB8+TIM/iRMWiuYT5YRu2FpRVC4XV1MnGKhdtRjx13wJIRNIk7n5BYvzLHPCcguXaYExBxEJq71mtyNNivTVP3g99p92YlNtQ0uLLDb3bDoq8Xt7SDt/UGgjJDBr5SrAj4M+quMusOKfF3jDa54+tL8SXWeV3GZ9ubqfWE1ep1e/bfEdwgBLzyxkkKpbOlmWnomz2BTX6UFdNdxKBJtpaFfuDwxX+p13CzrpFhj+o/u3Az42tGQNzY6VFiC4tdeQyaaUcD/jwKeT8nYexjm58JIXKBDWYP+nSAeei7Wu+Gq03FX427kif4szqxvZz4U8sD5Wj7ANV+GMs7ysqKyE5kaEV5dUgulWxel39JYtKTNy3VySR4z8Z7DWGA2oltCcySf0YXrR1FXIypoTYKbx9AedRzI9GsffGuSe2YI/lpRUPR7QJWT1uYrK2Zm3UTrVaOba4999HDCWGZVQdPcAZE1r+ovU5ygtO0mCaNsli2Z7CmKvf2OGVySXkE= donald@Donalds-MacBook-Pro-2.local"

}


variable "ssh_private_key" {
  type        = string
  description = "SSH private key for remote file"
  default     = "~/.ssh/id_rsa"

}


variable "cluster_cni" {
  type        = string
  description = "choose you own cni for the rke2 cluster"
  default     = "calico"
}