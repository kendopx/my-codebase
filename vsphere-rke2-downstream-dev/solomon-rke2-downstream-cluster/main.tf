
resource "rancher2_machine_config_v2" "nodes" {
  for_each      = var.node
  generate_name = replace(each.value.name, "_", "-")

  vsphere_config {
    cfgparam   = ["disk.enableUUID=TRUE"] # Disk UUID is Required for vSphere Storage Provider
    clone_from = var.vsphere_env.cloud_image_name
    cloud_config = templatefile("${path.cwd}/files/user_data_${each.key}.tftmpl",
      {
        ssh_user       = var.ssh_user,
        ssh_public_key = var.ssh_public_key,
        k8s_version    = var.rancher_env.rke2_version
    }) # End of templatefile
    content_library = var.vsphere_env.library_name
    cpu_count       = each.value.vcpu
    creation_type   = "template"
    datacenter      = var.vsphere_env.datacenter
    datastore       = var.vsphere_env.datastore
    disk_size       = each.value.hdd_capacity
    memory_size     = each.value.vram
    network         = var.vsphere_env.vm_network
    vcenter         = var.vsphere_env.server

    ssh_user = var.ssh_user
    # datastore_cluster = "DEV-CLUSTER"
    folder = "RKE2-CLUSTER-MNGR-DEV"
    pool   = "rke2-resource-pool"

    graceful_shutdown_timeout = "0"
  }
}

resource "rancher2_cluster_v2" "rke2" {
  annotations           = var.rancher_env.cluster_annotations
  kubernetes_version    = var.rancher_env.rke2_version
  labels                = var.rancher_env.cluster_labels
  name                  = var.clustername
  enable_network_policy = false
  rke_config {
    additional_manifest = templatefile("${path.module}/files/additional-manifests.tftmp", {
      kube_vip_rbac    = data.http.kube_vip_rbac.response_body
      kube_vip_version = jsondecode(data.http.kube_vip_version.response_body)["tag_name"]
      load_balancer_ip = var.kubevip.load_balancer_ip
    })
    etcd {
      snapshot_schedule_cron = "0 */5 * * *"
      snapshot_retention     = 5
    }
    chart_values = <<EOF
      rancher-vsphere-cpi:
        vCenter:
          host: ${var.vsphere_env.server}
          port: 443
          insecureFlag: true
          datacenters: ${var.vsphere_env.datacenter}
          username: ${var.vsphere_env.user}
          password: ${data.hcp_vault_secrets_app.kendops-infra.secrets["vcenter_vsphere_password"]}
          credentialsSecret:
            name: "vsphere-cpi-creds"
            generate: true
        cloudControllerManager:
          nodeSelector:
            node-role.kubernetes.io/control-plane: 'true'

      rancher-vsphere-csi:
        vCenter:
          host: ${var.vsphere_env.server}
          port: 443
          insecureFlag: "1"
          datacenters: ${var.vsphere_env.datacenter}
          username: ${var.vsphere_env.user}
          password: ${data.hcp_vault_secrets_app.kendops-infra.secrets["vcenter_vsphere_password"]}
          configSecret:
            name: "vsphere-config-secret"
            generate: true
        csiNode:
          nodeSelector: 
            node-role.kubernetes.io/worker: 'true'
        storageClass:
          allowVolumeExpansion: true
          #datastoreURL: ${var.vsphere_env.ds_url}
    EOF

    machine_global_config = <<EOF
      cni: calico
      etcd-expose-metrics: true
      kube-proxy-arg: ["proxy-mode=ipvs"]
      kube-apiserver-arg: [ "admission-control-config-file=/etc/rancher/rke2/custom-rke2-pss.yaml","enable-admission-plugins=AlwaysPullImages,NodeRestriction,ValidatingAdmissionWebhook", "audit-log-format=json", "audit-log-path=/var/log/audit/audit.log", "audit-policy-file=/etc/rancher/rke2/audit-policy.yaml", "audit-log-maxage=30", "audit-log-maxbackup=3", "audit-log-maxsize=100", "audit-log-mode=blocking-strict"]
      kubelite-arg: ["eviction-hard=imagefs.available<5%,nodefs.available<5%", "eviction-minimum-reclaim=imagefs.available=10%,nodefs.available=10%", "image-gc-high-threshold=85", "image-gc-low-threshold=80", "streaming-connection-idle-timeout=5m"]

    EOF

    dynamic "machine_pools" {
      for_each = var.node
      content {
        cloud_credential_secret_name = data.rancher2_cloud_credential.auth.id
        control_plane_role           = machine_pools.key == "ctl_plane" ? true : false
        etcd_role                    = machine_pools.key == "ctl_plane" ? true : false
        name                         = machine_pools.value.name
        quantity                     = machine_pools.value.quantity
        worker_role                  = machine_pools.key != "ctl_plane" ? true : false


        machine_config {
          kind = rancher2_machine_config_v2.nodes[machine_pools.key].kind
          name = replace(rancher2_machine_config_v2.nodes[machine_pools.key].name, "_", "-")
        }
      }
    }

    machine_selector_config {
      config = <<EOF
        cloud-provider-name: "rancher-vsphere"
        protect-kernel-defaults: true
        profile: "cis"
      EOF

    }
    upgrade_strategy {
      control_plane_concurrency = "10%"
      control_plane_drain_options {
        enabled = false
      }
      worker_concurrency = "10%"
      worker_drain_options {
        enabled                              = true
        delete_empty_dir_data                = true
        disable_eviction                     = false
        force                                = false
        grace_period                         = 0
        ignore_daemon_sets                   = true
        ignore_errors                        = false
        skip_wait_for_delete_timeout_seconds = 0
        timeout                              = 5
      }
    }
  }
  lifecycle {
    ignore_changes = [
      rke_config[0].machine_pools[1].quantity # Instruct Terraform to ignore changes to the quantity of "worker" pool nodes, as autoscaler will cause this value to drift between state refreshes
    ]
  }
}

resource "local_file" "get-kube" {
  content  = rancher2_cluster_v2.rke2.kube_config
  filename = "${path.module}/${var.clustername}.yaml"
}

resource "rancher2_app_v2" "cluster_autoscaler" {
  chart_name = "cluster-autoscaler"
  #   chart_version = "9.28.0"å
  cluster_id = rancher2_cluster_v2.rke2.cluster_v1_id
  name       = "cluster-autoscaler"
  namespace  = "cattle-system"
  repo_name  = "autoscaler"
  values     = <<EOF
    autoDiscovery:
      clusterName: ${rancher2_cluster_v2.rke2.name}
    cloudProvider: rancher
    extraArgs:
      cloud-config: /etc/rancher/rancher.conf
      skip-nodes-with-local-storage: false
      skip-nodes-with-system-pods: false
    extraVolumeSecrets:
      cloud-config:
        name: ${rancher2_secret_v2.cluster_autoscaler_cloud_config.name}
        mountPath: /etc/rancher
    image:
      repository: registry.k8s.io/autoscaling/cluster-autoscaler
    nodeSelector:
      node-role.kubernetes.io/control-plane: "true"
    tolerations:
    - effect: NoSchedule
      key: node-role.kubernetes.io/control-plane
    - effect: NoExecute
      key: node-role.kubernetes.io/etcd
  EOF
  depends_on = [rancher2_cluster_v2.rke2]
}

resource "rancher2_catalog_v2" "cluster_autoscaler" {
  cluster_id = rancher2_cluster_v2.rke2.cluster_v1_id
  name       = "autoscaler"
  url        = "https://kubernetes.github.io/autoscaler"
}

resource "rancher2_secret_v2" "cluster_autoscaler_cloud_config" {
  cluster_id = rancher2_cluster_v2.rke2.cluster_v1_id
  name       = "cluster-autoscaler-cloud-config"
  namespace  = "cattle-system"
  data = {
    "rancher.conf" = <<EOF
        url: ${data.hcp_vault_secrets_app.kendops-infra.secrets["rke2_dev_mgnr_rancher_url"]}
        token: ${rancher2_token.cluster_autoscaler.token}
        clusterName: ${rancher2_cluster_v2.rke2.name}
        clusterNamespace: fleet-default # This is the Namespace for the "cluster.provisioning.cattle.io" API resource on "local" cluster
    EOF
  }
  depends_on = [rancher2_cluster_v2.rke2]
}

resource "rancher2_token" "cluster_autoscaler" {
  description = "Unscoped Rancher API Token for Cluster Autoscaling"
  ttl         = 0
}

