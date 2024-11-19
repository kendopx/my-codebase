#####################################################################################################
#                                                                                                   #
# vSphere module/configuration                                                                      #
#                                                                                                   #
#####################################################################################################

resource "vsphere_virtual_machine" "vm" {
  count            = length(var.ip_list)
  name             =  "argo${count.index +1}.${var.domain}"
  resource_pool_id = vsphere_resource_pool.resource_pool.id
  datastore_id     = var.datastore_id
  folder           = var.folder
  num_cpus         = var.num_cpu
  memory           = var.memory
  guest_id         = var.guest_id

  network_interface {
    network_id = var.network_id
  }

  # Root Disk
  disk {
    # label            = "argo${count.index +0}.${var.domain}"
    label              = var.disk1
    unit_number      = 0    
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }  

  # Additional Disk 
  disk {
    #label            = "argo${count.index +1}.${var.domain}"
    label            = var.disk2
    unit_number      = 1
    size             = var.disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  } 

    boot_delay              = 10000
    firmware                = "efi"
    efi_secure_boot_enabled = true

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.metadata" = base64encode((templatefile(("${path.module}/files/metadata.yml.tpl"),
      { hostname    = "argo${count.index +1}.${var.domain}"
        ip          = var.ip_list[count.index]
        ip_netmask  = var.ipv4_netmask
        gw          = var.ipv4_gateway
        dns_servers = var.dns_server_list
    })))

    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata" = base64encode((templatefile(("${path.module}/files/cloud-init.yml.tpl"),
      { cluster_name     = var.rke2_cluster_name
        bootstrap_server = var.is_server && count.index != 0 ? var.ip_list[0] : var.bootstrap_server
        public_address   = var.ip_list[0]
        rke2_version     = var.rke2_version
        rke2_token       = var.rke2_token
        is_server        = var.is_server
        san              = var.ip_list
        rke2_conf        = var.rke2_config_file != "" ? file(var.rke2_config_file) : ""
        registries_conf  = var.registries_conf
        additional_san   = var.additional_san
        manifests_files  = var.manifests_path != "" ? [for f in fileset(var.manifests_path, "*.{yml,yaml}") : [f, base64gzip(file("${var.manifests_path}/${f}"))]] : []
        manifests_gzb64  = var.manifests_gzb64
    })))
    "guestinfo.userdata.encoding" = "base64"
  }

  lifecycle {
    ignore_changes = [
      extra_config
    ]
  }
}