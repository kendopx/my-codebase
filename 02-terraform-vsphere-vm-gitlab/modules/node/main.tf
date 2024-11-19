#####################################################################################################
#                                                                                                   #
# vSphere module/configuration                                                                      #
#                                                                                                   #
#####################################################################################################

resource "vsphere_virtual_machine" "vm" {
  count            = length(var.ip_list)
  name             =  "gitlab${count.index +1}.${var.domain}"
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
    label              = var.disk1
    unit_number      = 0    
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }  

  # Additional Disk 
  disk {
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
      { hostname    = "gitlab${count.index +1}.${var.domain}"
        ip          = var.ip_list[count.index]
        ip_netmask  = var.ipv4_netmask
        gw          = var.ipv4_gateway
        dns_servers = var.dns_server_list
    })))
    "guestinfo.metadata.encoding" = "base64"
  }

  lifecycle {
    ignore_changes = [
      extra_config
    ]
  }
}