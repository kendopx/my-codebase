#####################################################################################################
#                                                                                                   #
# vSphere module/output                                                                             #
#                                                                                                   #
#####################################################################################################

output "ips" {
  value = "${formatlist("%s: %s", vsphere_virtual_machine.vm.*.name,vsphere_virtual_machine.vm.*.default_ip_address)}"
}

# output "nodes" {
#   value = {
#     (module.cluster.cluster_name)   = module.cluster.cluster_nodes
#     (module.cluster_2.cluster_name) = module.cluster_2.cluster_nodes
#     (module.cluster_3.cluster_name) = module.cluster_3.cluster_nodes
#   }
# }
