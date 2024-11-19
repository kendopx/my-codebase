
#####################################################################################################
#                                                                                                   #
# vSphere module/provider                                                                           #
#                                                                                                   #
#####################################################################################################

provider "vsphere" {
  user                 = "solomon@vsphere.local"
  password             = "Soly2020!1239"
  vsphere_server       = "vcenter.kendopz.com"
  allow_unverified_ssl = true
}

