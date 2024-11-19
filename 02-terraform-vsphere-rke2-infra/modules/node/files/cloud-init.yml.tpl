#cloud-config
write_files:
- path: /root/.ssh/authorized_keys
  content: |
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAJ7M38wDPnT8Wkd1ZbHEfmbg+DOF/LOQ0KzLlB5oHHKLWRPnRVYxf3hEyVMxK33GLj+XNw3woAHsO2cPN+RiCQ1Wa/NxoZGoJn57nj8H8j/18TW7dfD5+8GUND04AVb8AGa6t2yS55UUtaDK+tGUhNnUUPJBwUzfxLX01NcqRgyy/DOW+wL6h6ginuJJK2A+HtEYEFNjlqQmQ5NAiskfr9b0l456ZK3k/9ELq0O3trqBuHrbPlr8RqtRKgblqMB7mLlxy9oqLF/4/4ZNCuYsR5/pk1RZuSBhHGODamRR3E3L1uHlZLsaZxwQxMOysKG2og8YLnlFmOZKpQoxx3Ts6DIRpw8XitJlDDZSNjkx++pn/BOpXY7/fn/9xpanog7wfMp2YvuJ1B5L7+oaQgfn/GzoGqXk/yhO4JHs3IFlIaHzRlUncVjitxvUM6g7jaACpTVNZlb9zParvgwCuYwrFinGUR50uoCQNpyGPc2gkyliHN3uxmN7PZV7yH26B+pc= swilliams@MDLT002
- path: /usr/local/bin/wait-for-node-ready.sh
  permissions: "0755"
  owner: root:root
  content: |
    #!/bin/sh
    until (curl -sL http://localhost:10248/healthz) && [ $(curl -sL http://localhost:10248/healthz) = "ok" ];
      do sleep 10 && echo "Wait for $(hostname) kubelet to be ready"; done;
%{ if bootstrap_server == "" ~}
  %{~ for f in manifests_files ~}
- path: /var/lib/rancher/rke2/server/manifests/${f[0]}.yaml
  permissions: "0600"
  owner: root:root
  encoding: gz+b64
  content: ${f[1]}
  %{~ endfor ~}
  %{~ for k, v in manifests_gzb64 ~}
- path: /var/lib/rancher/rke2/server/manifests/${k}.yaml
  permissions: "0600"
  owner: root:root
  encoding: gz+b64
  content: ${v}
  %{~ endfor ~}
%{~ endif ~}
%{~ if registries_conf != "" ~}
- path: /etc/rancher/rke2/registries.yaml
  permissions: "0600"
  owner: root:root
  encoding: gz+b64
  content: ${registries_conf}
%{ endif ~}
- path: /etc/rancher/rke2/config.yaml
  permissions: "0600"
  owner: root:root
  content: |
    token: "${rke2_token}"
    %{~ if bootstrap_server != "" ~}
    server: https://${bootstrap_server}:9345
    %{~ endif ~}
    %{~ if is_server ~}

    write-kubeconfig-mode: "0640"
    tls-san:
      ${indent(6, yamlencode(concat(san, additional_san)))}
    kube-apiserver-arg: "kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
    %{~ endif ~}
    ${indent(4,rke2_conf)}
runcmd:
  - subscription-manager register --username spaceuser --password Redhat123### --auto-attach --force 
  - export INSTALL_RKE2_VERSION=${rke2_version}
  - curl -sfL https://get.rke2.io | sh -
  %{~ if is_server ~}
    %{~ if bootstrap_server != "" ~}
  - [ sh,  -c, 'until (nc -z ${bootstrap_server} 6443); do echo Wait for master node && sleep 10; done;']
    %{~ endif ~}
  - systemctl enable rke2-server.service
  - systemctl start rke2-server.service
  - cp -rf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin
  - mkdir ~/.kube
  - cp /etc/rancher/rke2/rke2.yaml ~/.kube/config  
  - chmod 400 ~/.kube/config   
  - echo "systemctl start rke2-server.service" >> /etc/rc.d/rc.local   
  - echo "systemctl enable rke2-server.service" >> /etc/rc.d/rc.local 
  - echo "systemctl disable firewalld.service" >> /etc/rc.d/rc.local          
  - chmod +x /etc/rc.d/rc.local  
  - /bin/cp -rf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin  
  - systemctl disable firewalld.service
  - systemctl stop firewalld.service
  - [ sh, -c, 'until [ -f /etc/rancher/rke2/rke2.yaml ]; do echo Waiting for rke2 to start && sleep 10; done;' ]
  - [ sh, -c, 'until [ -x /var/lib/rancher/rke2/bin/kubectl ]; do echo Waiting for kubectl bin && sleep 10; done;' ]
  - cp /etc/rancher/rke2/rke2.yaml /etc/rancher/rke2/rke2-argo.yaml
  - sudo chgrp sudo /etc/rancher/rke2/rke2-argo.yaml
  - KUBECONFIG=/etc/rancher/rke2/rke2-infra.yaml /var/lib/rancher/rke2/bin/kubectl config set-cluster default --server https://${public_address}:6443
  - KUBECONFIG=/etc/rancher/rke2/rke2-infra.yaml/var/lib/rancher/rke2/bin/kubectl config rename-context default ${cluster_name}  
  - /bin/cp -rf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin  
  - systemctl disable firewalld.service
  - systemctl stop firewalld.service  
  - mkdir /home/swilliams/.kube  
  - chown swilliams:swilliams  /home/swilliams/.kube
  - cp /etc/rancher/rke2/rke2.yaml /home/swilliams/.kube/config  
  - chmod 400 /home/swilliams/.kube/config     
  - echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sdb
  - pvcreate /dev/sdb1
  - vgextend rhel /dev/sdb1
  - lvextend -l +100%FREE /dev/mapper/rhel-root
  - xfs_growfs /dev/mapper/rhel-root     
  - curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  - chmod +x get_helm.sh
  - sh get_helm.sh  
  - curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
  - chmod +x /usr/local/bin/argocd
  %{~ else ~}
  - systemctl enable rke2-server.service
  - systemctl start rke2-server.service  
  %{~ endif ~}