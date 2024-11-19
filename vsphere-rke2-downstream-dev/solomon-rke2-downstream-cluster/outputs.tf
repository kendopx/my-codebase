# output "namespaces" {
#   value      = data.kubernetes_all_namespaces.all.namespaces
#   depends_on = [local_file.get-kube]

# }

output "kube_vip_version" {
  value = jsondecode(data.http.kube_vip_version.response_body).tag_name
}

output "cluster_id" {
  value = rancher2_cluster_v2.rke2.cluster_v1_id

}

output "cluster_name" {
  value      = rancher2_cluster_v2.rke2.name
  depends_on = [local_file.get-kube]
}

output "cluster_autoscaler" {
  value = rancher2_app_v2.cluster_autoscaler.id
}

output "cluster_autoscaler_catalog" {
  value = rancher2_catalog_v2.cluster_autoscaler.id
}

output "kube_config" {
  value      = rancher2_cluster_v2.rke2.kube_config
  sensitive  = true
  depends_on = [local_file.get-kube]
}

output "kube_config_file" {
  value      = local_file.get-kube.filename
  depends_on = [local_file.get-kube]
}

output "machine_pools" {
  value     = { for k, v in rancher2_machine_config_v2.nodes : k => v.vsphere_config }
  sensitive = true
}

output "machine_generate_name" {
  value = { for k, v in rancher2_machine_config_v2.nodes : k => v.generate_name }
}

# output "kubernetes_all_namespaces" {
#   value = data.kubernetes_all_namespaces.kubernetes_all_namespaces
#   depends_on = [ local_file.get-kube ]
# }