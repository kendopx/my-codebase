# terraform.tfvars

#####################################################################################################
#                                                                                                   #
# vSphere configuration                                                                             #
#                                                                                                   #
#####################################################################################################

vsphere_password     = "Soly2020!1239"
vsphere_username     = "solomon@vsphere.local"
vsphere_server       = "172.29.0.2"
allow_unverified_ssl = true
datastore            = "kendops-kube-nas-datastore-01"
datacenter           = "DEV-DC"
cluster_name         = "DEV-CLUSTER"
network              = "VM Network"
template             = "RHEL9-RKE2"
pool                 = "rancher-argo-pool"

#####################################################################################################
#                                                                                                   #
# VM Configuration                                                                                  #
#                                                                                                   #
#####################################################################################################

vms_count               = 3
boot_delay              = 10000
guest_id                = "rhel9_64Guest"
system_user             = "root"
server_num_cpu          = "8"
server_disk_size        = "200"
server_memory           = "32000"
name_prefix             = "argo"
rke2_cluster_name       = "argo"
disk1                   = "disk1"
disk2                   = "disk2"
user                    = "root"
efi_secure_boot_enabled = true
firmware                = "efi"
domain                  = "kendopz.com"
ipv4_gateway            = "172.29.0.1"
ipv4_netmask            = "24"
dns_server_list         = ["172.29.0.8", "172.29.0.9", "1.1.1.1"]
dns_suffix_list         = ["kendopz.com"]
rke2_version            = "v1.26.6+rke2r1"
server_ip_list          = ["172.29.0.45", "172.29.0.46", "172.29.0.47"]
host_master             = "172.29.0.45"
