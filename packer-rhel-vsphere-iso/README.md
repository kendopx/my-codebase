```sh
packer init .
packer build -force -on-error=ask -var-file ubuntu2204.pkrvars.hcl -var-file vsphere.pkrvars.hcl ubuntu2204.pkr.hcl
