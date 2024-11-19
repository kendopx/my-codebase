#####################################################################################################
#                                                                                                   #
# vSphere module/configuration                                                                      #
#                                                                                                   #
#####################################################################################################

locals {
  node_config = {
    bootstrap_server = var.server_ip_list[0]
    cluster_name     = var.cluster_name
    datastore_id     = data.vsphere_datastore.datastore.id
    dns_server_list  = var.dns_server_list
    domain           = var.domain
    folder           = var.folder
    guest_id         = var.guest_id
    ipv4_gateway     = var.ipv4_gateway
    ipv4_netmask     = var.ipv4_netmask
    network_id       = data.vsphere_network.network.id
    pool_id          = var.pool
    rke2_version     = var.rke2_version
    rke2_token       = random_password.rke2_token.result
    registries_conf  = var.registries_conf
  }
  ssh = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
  scp = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "random_password" "rke2_token" {
  length = 64
}

module "server" {
  source            = "./modules/node"
  cluster_name      = var.cluster_name
  name_prefix       = var.rke2_cluster_name
  rke2_cluster_name = var.rke2_cluster_name
  vsphere_server    = var.vsphere_server
  vsphere_username  = var.vsphere_username
  vsphere_password  = var.vsphere_password
  boot_delay        = var.boot_delay
  firmware          = var.firmware
  ip_list           = var.server_ip_list
  ipv4_netmask      = var.ipv4_netmask
  ipv4_gateway      = var.ipv4_gateway
  dns_server_list   = var.dns_server_list
  domain            = var.domain
  template_uuid     = var.template_uuid
  num_cpu           = var.server_num_cpu
  disk_size         = var.server_disk_size
  memory            = var.server_memory
  guest_id          = var.guest_id
  pool_id           = var.pool
  datastore_id      = data.vsphere_datastore.datastore.id
  folder            = var.folder
  network_id        = data.vsphere_network.network.id
  rke2_version      = var.rke2_version
  rke2_config_file  = var.rke2_config_file
  registries_conf   = var.registries_conf
  rke2_token        = random_password.rke2_token.result
  additional_san    = var.additional_san
  manifests_path    = var.manifests_path
  manifests_gzb64   = var.manifests_gzb64
  vms_count         = var.vms_count
  disk1             = var.disk1
  disk2             = var.disk2
}
