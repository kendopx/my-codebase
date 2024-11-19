#cloud-config
write_files:
- path: /root/.ssh/authorized_keys
  content: |
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAJ7M38wDPnT8Wkdvvv john.doe@workstation1
runcmd:
  - subscription-manager register --username spaceuser --password Redhat123### --auto-attach --force 
  - systemctl enable firewalld.service
  - systemctl start firewalld.service  
  - systemctl enable firewalld.service
  - sudo setenforce 0
  - sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config   
  - sudo yum install -y yum-utils
  - sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  - sudo yum -y install consul vault 
  - sudo firewall-cmd  --add-port={8300,8301,8302,8400,8500,8600}/tcp --permanent
  - sudo firewall-cmd  --add-port={8301,8302,8600}/udp --permanent
  - sudo firewall-cmd --reload  
  - echo "systemctl enable firewalld.service" >> /etc/rc.d/rc.local          
  - echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sdb
  - pvcreate /dev/sdb1
  - vgextend rhel /dev/sdb1
  - lvextend -l +100%FREE /dev/mapper/rhel-root
  - xfs_growfs /dev/mapper/rhel-root
  - firewall-cmd --reload