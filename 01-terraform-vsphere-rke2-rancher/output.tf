#####################################################################################################
#                                                                                                   #
# vSphere module/output                                                                             #
#                                                                                                   #
#####################################################################################################


# output "ips" {
#   value = "${formatlist("%s: %s", module.server.ipv4_netmask.vm.*.name,module.server.ipv4_netmask.*.default_ip_address)}"
# }

# output "ips" {
#   value = "${formatlist("%s: %s", data.vsphere_virtual_machine.vm.*.name,data.vsphere_virtual_machine.vm.*.default_ip_address)}"
# }

# output "vms_ips" {
#   value = vsphere_virtual_machine.vm.*.default_ip_address
# }

# output "datacenter" {
#     value = data.vsphere_datacenter.datacenter[*].name
# }

# output "vms_names" {
#   value = vsphere_virtual_machine.vm.*.name
# }
# output "datastore" {
#     value = data.vsphere_datastore.datastore[*].name
# }

# output "private_ipv4" {
#   value       = module.server.ipv4_netmask.*.default_ip_address)
# }

# output "public_ipv4" {
#   value       = vsphere_virtual_machine.vm.*.default_ip_address
# }



