
rancher_env = {
  cloud_credential    = "esx1-vsphere"
  cluster_annotations = { "Owner" = "Donald_Etsecom" }
  cluster_labels      = { "Cluster_Owner" = "donald_Etsecom" }
  rke2_version        = "v1.28.10+rke2r1"
}

kubevip = {
  load_balancer_ip = "192.168.10.254"
}

# These are machine specs for nodes.  Be mindful of System Requirements!
node = {
  ctl_plane = { hdd_capacity = 40960, name = "ctl-plane", quantity = 3, vcpu = 4, vram = 4096 }
  worker    = { hdd_capacity = 81920, name = "worker", quantity = 2, vcpu = 4, vram = 8192 }
}

vsphere_env = {
  cloud_image_name = "opensuse-linux-template-v15-6"
  compute_node     = "any"
  datacenter       = "DEV-DC"
  datastore        = "datastore-10.13"
  ds_url           = "ds:///vmfs/volumes/.../"
  library_name     = "Templates"
  server           = "192.168.10.12"
  user             = "administrator@vsphere.local"

  vm_network = ["VM Network"]
}

clustername      = "donald-downstream-cluster"
stage            = "donald-downstream-cluster"
registry01       = "registry01.suse"
registry02       = "registry02.suse:5000"
registryusername = "robot-rke2-vsphere"
registrypassword = "4tCFcThhx6q3iLxgFYIfENVd5UtI3kKm"
ntpservers       = ["192.168.10.31"]

cluster_cni = "calico"

ssh_public_key = "~/.ssh/id_ed25519.pub"

