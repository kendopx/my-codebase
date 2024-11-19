# terraform.tfvars

#####################################################################################################
#                                                                                                   #
# vSphere configuration                                                                             #
#                                                                                                   #
#####################################################################################################

vsphere_password     = "Sisiuuuub"
vsphere_username     = "solomon@vsphere.local"
vsphere_server       = "172.29.0.2"
allow_unverified_ssl = true
datastore            = "kendops-kube-nas-datastore-01"
datacenter           = "DEV-DC"
cluster_name         = "DEV-CLUSTER"
network              = "VM Network"
template             = "RHEL9-RKE2"
pool                 = "gitlab-pool"

#####################################################################################################
#                                                                                                   #
# VM Configuration                                                                                  #
#                                                                                                   #
#####################################################################################################

vms_count               = 1
boot_delay              = 10000
guest_id                = "rhel9_64Guest"
system_user             = "root"
server_num_cpu          = "8"
server_disk_size        = "200"
server_memory           = "32000"
name_prefix             = "gitlab"
rke2_cluster_name       = "gitlab"
disk1                   = "disk1"
disk2                   = "disk2"
user                    = "root"
efi_secure_boot_enabled = true
firmware                = "efi"
domain                  = "kendopz.com"
ipv4_gateway            = "172.29.0.1"
ipv4_netmask            = "24"
dns_server_list         = ["172.29.0.18", "172.29.0.9", "1.1.1.1"]
dns_suffix_list         = ["kendopz.com"]
server_ip_list          = ["172.29.0.18"]
# server_ip_list          = ["172.29.0.200", "172.29.0.201", "172.29.0.202"]

