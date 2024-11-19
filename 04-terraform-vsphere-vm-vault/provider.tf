
#####################################################################################################
#                                                                                                   #
# vSphere module/provider                                                                           #
#                                                                                                   #
#####################################################################################################

provider "vsphere" {
  user                 = "solomon@vsphere.local"
  password             = "Sogzg5bbtvbt"
  vsphere_server       = "vcenter.kendopz.com"
  allow_unverified_ssl = true
}

