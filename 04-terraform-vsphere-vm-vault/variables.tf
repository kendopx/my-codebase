variable "cluster_name" {
  type        = string
  default     = "pro-rancher"
  description = "Cluster name"
}


variable "rke2_cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "allow_unverified_ssl" {
  type = string
}

variable "firmware" {
  type = string
}


variable "vsphere_username" {
  type = string
}


variable "server_ip_list" {
  type        = list(string)
  description = "A list of nodes IP"
}

variable "vms_count" {
  type = number
}

variable "boot_delay" {
  type = number
}

variable "ipv4_netmask" {
  type        = number
  description = "The IPV4 subnet mask in bits (e.g. 24 for 255.255.255.0)"
}

variable "ipv4_gateway" {
  type        = string
  description = "The IPv4 default gateway"
}

variable "dns_server_list" {
  type        = list(string)
  description = " The list of DNS servers to configure on a virtual machine. "
}

variable "domain" {
  type        = string
  description = "A list of DNS search domains to add to the DNS configuration on the virtual machine"
}

variable "datacenter" {
  type        = string
  description = "The vSphere datacenter name"
}

variable "datastore" {
  type        = string
  description = "The vSphere datastore name"
}

variable "pool" {
  type        = string
  default     = "rancher-test-pool"
  description = "The vSphere resource pool name"
}


variable "folder" {
  type        = string
  description = "The path to the folder to put this virtual machine in"
  default     = ""
}

variable "network" {
  type        = string
  description = "The vSphere network name"
}

variable "vsphere_password" {
  type = string
}

variable "dns_suffix_list" {
  type = list(string)
}

variable "template_uuid" {
  type        = string
  default     = "RHEL9-TEST"
  description = "The VM template UUID"
}

variable "template" {
  type = string
}

variable "vsphere_server" {
  type = string
}

variable "efi_secure_boot_enabled" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "guest_id" {
  type        = string
  description = "The VM guest ID"
}

variable "system_user" {
  type        = string
  default     = "root"
  description = "Default OS image user"
}

variable "server_num_cpu" {
  type        = number
  description = "CPU count for master nodes"
}

variable "server_memory" {
  type        = number
  description = "Memory count for master nodes"
}

variable "server_disk_size" {
  type        = number
  description = "Master nodes disk size"
}

variable "rke2_version" {
  type        = string
  default     = ""
  description = "RKE2 version"
}

variable "rke2_config_file" {
  type        = string
  default     = ""
  description = "RKE2 config file for servers"
}

variable "registries_conf" {
  type        = string
  default     = ""
  description = "Containerd registries config in gz+b64"
}

variable "additional_san" {
  type        = list(string)
  default     = []
  description = "RKE2 additional SAN"
}

variable "manifests_path" {
  type        = string
  default     = ""
  description = "RKE2 addons manifests directory"
}

variable "manifests_gzb64" {
  type        = map(string)
  default     = {}
  description = "RKE2 addons manifests in gz+b64 in the form { \"addon_name\": \"gzb64_manifests\" }"
}

variable "host_master" {
  type    = string
  default = ""
}

variable "user" {
  type    = string
  default = ""
}

variable "disk1" {
  type    = string
  default = ""
}

variable "disk2" {
  type    = string
  default = ""
}