# Define Packer variables
variable "vsphere_server" {
  description = "The vSphere server address."
  type        = string
}

variable "vsphere_user" {
  description = "The vSphere user account."
  type        = string
}

variable "vsphere_password" {
  description = "The vSphere user password."
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "The name of the datacenter."
  type        = string
}

variable "vsphere_cluster" {
  description = "The name of the cluster."
  type        = string
}

variable "vsphere_datastore" {
  description = "The name of the datastore."
  type        = string
}

variable "vsphere_network" {
  description = "The name of the network."
  type        = string
}

variable "iso_url" {
  description = "The URL or path to the RHEL 9 ISO file."
  type        = string
}

variable "iso_checksum" {
  description = "The checksum for the RHEL 9 ISO file."
  type        = string
}

variable "vm_name" {
  description = "The name of the VM template."
  type        = string
}

variable "ssh_username" {
  description = "The username for SSH access during build."
  type        = string
}

variable "ssh_password" {
  description = "The password for SSH access during build."
  type        = string
  sensitive   = true
}

# Define the source image
source "vsphere-iso" "rhel9" {
  vcenter_server       = var.vsphere_server
  username             = var.vsphere_user
  password             = var.vsphere_password
  cluster              = var.vsphere_cluster
  datacenter           = var.vsphere_datacenter
  datastore            = var.vsphere_datastore
  network              = var.vsphere_network
  insecure_connection  = true  # Set to false for production
  iso_paths            = [var.iso_url]
  iso_checksum         = var.iso_checksum
  iso_checksum_type    = "sha256"
  
  vm_name              = var.vm_name
  guest_os_type        = "rhel9_64Guest"
  cpus                 = 2
  memory               = 4096
  disk {
    size              = 40960
    thin_provisioned  = true
  }

  # Boot command to automate installation
  boot_command = [
    "<esc><wait>",
    "linux ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]

  # SSH configuration for post-processing
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_wait_timeout = "20m"
}

# HTTP server to host kickstart file
build {
  sources = ["source.vsphere-iso.rhel9"]

  provisioner "shell" {
    inline = [
      "yum update -y",
      "yum install -y open-vm-tools"
    ]
  }

  post-processor "vsphere" {
    vcenter_server = var.vsphere_server
    username       = var.vsphere_user
    password       = var.vsphere_password
    datacenter     = var.vsphere_datacenter
    cluster        = var.vsphere_cluster
    datastore      = var.vsphere_datastore
    network        = var.vsphere_network
    vm_name        = var.vm_name

    keep_registered = true
    template = true
  }
}
