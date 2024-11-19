#####################################################################################################
#                                                                                                   #
# vSphere module/configuration                                                                      #
#                                                                                                   #
#####################################################################################################


data "vsphere_datacenter" "dc" {
  name = "DEV-DC"
}

data "vsphere_virtual_machine" "template" {
  name          = "RHEL9-TEST"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "${var.cluster_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_resource_pool" "resource_pool" {
  name                    = "hashicorp-vault-ha"
  parent_resource_pool_id = "${data.vsphere_compute_cluster.compute_cluster.resource_pool_id}"
}

