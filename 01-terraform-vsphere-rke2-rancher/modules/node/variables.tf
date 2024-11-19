#####################################################################################################
#                                                                                                   #
# vSphere module/variable                                                                           #
#                                                                                                   #
#####################################################################################################

variable "cluster_name" {
  type = string
}

variable "rke2_cluster_name" {
  type        = string
}

variable "firmware" {
  type        = string
}

variable "name_prefix" {
  type = string
}

variable "datastore_id" {
  type = string
}

variable "folder" {
  type = string
}

variable "vsphere_username" {
  type = string
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_server" {
  type = string
}

variable "ip_list" {
  type = list(string)
}

variable "ipv4_netmask" {
  type = number
}

variable "boot_delay" {
  type = number
}

variable "network_id" {
  type = string
}

variable "ipv4_gateway" {
  type = string
}

variable "dns_server_list" {
  type = list(string)
}

variable "domain" {
  type = string
}

variable "num_cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "guest_id" {
  type = string
}

variable "template_uuid" {
  type = string
}

variable "rke2_version" {
  type = string
}

variable "rke2_config_file" {
  type = string
}

variable "registries_conf" {
  type    = string
  default = ""
}

variable "bootstrap_server" {
  type    = string
  default = ""
}

variable "is_server" {
  type    = bool
  default = true
}

variable "rke2_token" {
  type    = string
  default = ""
}

variable "pool_id" {
  type = string
  default = "rancher-new-pool"
}

variable "additional_san" {
  type        = list(string)
  default     = []
  description = "RKE additional SAN"
}

variable "manifests_path" {
  type        = string
  default     = ""
  description = "RKE2 addons manifests directory"
}

variable "manifests_gzb64" {
  type    = map(string)
  default = {}
}

variable "vms_count" {
  type = number
}

variable "host_master" {
  type        = string
  default     = ""
}

variable "user" {
  type        = string
  default     = ""
}

variable "disk1" {
  type        = string
  default     = ""
}

variable "disk2" {
  type        = string
  default     = ""
}