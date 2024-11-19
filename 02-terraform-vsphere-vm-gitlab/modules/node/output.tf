#####################################################################################################
#                                                                                                   #
# vSphere module/output                                                                             #
#                                                                                                   #
#####################################################################################################

output "ips" {
  value = "${formatlist("%s: %s", vsphere_virtual_machine.vm.*.name,vsphere_virtual_machine.vm.*.default_ip_address)}"
}
