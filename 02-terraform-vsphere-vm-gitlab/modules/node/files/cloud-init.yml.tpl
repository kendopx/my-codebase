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
  - echo -e "172.29.0.18\tgitlab.kendopz.com\t gitlab" | sudo tee -a /etc/hosts
  - sudo setenforce 0
  - dnf install java-11-openjdk-devel -y
  - dnf install wget -y 
  - wget -O /etc/yum.repos.d/gitlab.repo https://pkg.gitlab.io/redhat-stable/gitlab.repo
  - rpm --import https://pkg.gitlab.io/redhat-stable/gitlab.io.key
  - dnf install gitlab -y
  - systemctl daemon-reload
  - systemctl start gitlab
  - systemctl enable gitlab
  - systemctl status gitlab    
  - sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config   
  - firewall-cmd --add-service={http,https,dns,ntp,freeipa-ldap,freeipa-ldaps} --permanent
  - firewall-cmd --permanent --add-port=80/tcp
  - firewall-cmd --permanent --add-port=443/tcp,
  - firewall-cmd --add-port=8080/tcp --permanent
  - firewall-cmd --reload
  - echo "systemctl enable firewalld.service" >> /etc/rc.d/rc.local          
  - mkdir --parents /opt/raft
  - chown --recursive vault:vault /opt/raft
  - echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sdb
  - pvcreate /dev/sdb1
  - vgextend rhel /dev/sdb1
  - lvextend -l +100%FREE /dev/mapper/rhel-root
  - xfs_growfs /dev/mapper/rhel-root
  - yum install httpd 
  - systemctl enable httpd.service
  - systemctl start httpd.service
  - systemctl enable httpd.service
  - firewall-cmd --reload