#####################################################################################################
#                                                                                                   #
# RKE2 post-installation                                                                            #
#                                                                                                   #
#####################################################################################################

# Virtual instance deployment status
resource "null_resource" "virtual_instance_deployment" {
    provisioner local-exec { 
    command = <<-EOT
     echo " "      
     echo "Virtual instance deploy complete successfully --------------------------------------> Kubernetes mechanic" 
  EOT
    on_failure = continue
  }  
}  

# Authenticate to the node via ssh 
resource "null_resource" "manifest_config_files" {
  connection {
    user           = "root"
    private_key    = file("~/.ssh/id_rsa")
    host           = vsphere_virtual_machine.vm[0].default_ip_address        
    port           = 22
    agent       = false
    type        = "ssh"    
  }
}