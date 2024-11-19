https://www.suse.com/c/rancher_blog/stateful-kubernetes-workloads-on-vsphere-with-rke/

_____________
Set Up vSphere on RKE

Additions to RKE cluster.yml

1. Create a CPI secret
2. Deploy the RBAC manifests for CPI.
3. Set up RBAC for CSI provider
4. Install the CSI controller
5. Install the CSI node driver
6. Apply this storage class

kubectl create configmap cloud-config --from-file=1_cpi-vsphere.conf --namespace=kube-system --> kubectl get cm cloud-config -n kube-system
kubectl create -f 2_cpi-secret.conf  --> kubectl get secret cpi-global-secret -n kube-system
kubectl create -f  3_cloud-controller-manager-roles.yaml
kubectl create -f  4_cloud-controller-manager-role-bindings.yaml
kubectl create -f  5_cloud-provider.yaml
kubectl create secret generic vsphere-config-secret --from-file=6_csi-vsphere.conf  --namespace=kube-system --> kubectl get secret vsphere-config-secret -n kube-ssytem
kubectl apply -f 7_csi-driver-rbac.yaml
kubectl create -f 8_csi-controller.yaml
kubectl apply -f 9_csi-driver.yaml --> kubectl get CSINode
kubectl apply -f 10_storage-class.yaml --> kubectl get pv 

kubectl --namespace longhorn-system port-forward --address 0.0.0.0 service/longhorn-frontend 5080:80

-----------------------------------------


curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.2.1/scripts/environment_check.sh | bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.1/deploy/prerequisite/longhorn-iscsi-installation.yaml
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.1/deploy/prerequisite/longhorn-nfs-installation.yaml
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.1/deploy/longhorn.yaml
kubectl -n longhorn-system apply -f longhorn-ingress.yml
kubectl get pods \
--namespace longhorn-system 


kubectl --namespace longhorn-system port-forward --address 0.0.0.0 service/longhorn-frontend 5080:80
Stateful Kubernetes Workloads on vSphere with RKE
_________________________________________________________________

Stateful workloads in Kubernetes need to be able to access persistent volumes across the cluster. Storage Classes represent different storage types in Kubernetes. A storage provisioner backs each storage class. Most commonly used cloud providers have storage provisioners, which offer different capabilities based on the underlying cloud.

Prerequisites
VMware environment with vCenter 6.7U3+, ESXi v6.7.0+
Kubernetes cluster provisioned using RKE. Kubernetes version 1.14+
Virtual machines with hardware version 15 or later.
vmtools on each virtual machine.

1. Additions to RKE cluster.yml

vim cluster.yml
kubelet:
    extra_binds:
    - /var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com:/var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com:rshared
    - /csi:/csi:rshared
    extra_args:
    cloud-provider: external

2. Handling extra taint toleration

    RKE already taints the Master nodes with the following taints:

    node-role.kubernetes.io/controlplane=true:NoSchedule
    node-role.kubernetes.io/etcd=true:NoExecute

3. Setup CPI conf and secrets

    a) Create the vsphere-cpi.conf for setting up the CPI.
    tee $HOME/cpi-vsphere.conf > /dev/null <<EOF
    [Global]
    port = "443"
    insecure-flag = "true" #Optional. Please tweak based on setup.
    secret-name = "cpi-global-secret"
    secret-namespace = "kube-system"
    [VirtualCenter "vcenter01.kendopz.com"]
    datacenters = "DEV-DC"
    EOF

    b) Create a configmap from this file
       kubectl create configmap cloud-config --from-file=$HOME/cpi-vsphere.conf --namespace=kube-system

    c) Verify that configmap exists
       kubectl get cm cloud-config -n kube-system

4. Create a CPI secret
    a) create the cpi-secret.conf

    tee $HOME/cpi-secret.conf > /dev/null <<EOF
    apiVersion: v1
    kind: Secret
    metadata:
    name: cpi-global-secret
    namespace: kube-system
    stringData:
    vc.domain.com.username: "USERNAME"
    vc.domain.com.password: "PASSWORD"
    EOF

    b) Create the secret
    kubectl create -f $HOME/cpi-secret.conf

    b) Verify the secret was created
    kubectl get secret cpi-global-secret -n kube-system

5. Deploy CPI manifests
    a) Deploy the RBAC manifests for CPI.

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/master/manifests/controller-manager/cloud-controller-manager-roles.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/master/manifests/controller-manager/cloud-controller-manager-role-bindings.yaml

    b) The CPI manifest needs a few minor tweaks to allow it to handle the RKE taints:

tee $HOME/cloud-provider.yaml > /dev/null <<EOF
---
apiVersion: v1
kind: ServiceAccount
metadata:
name: cloud-controller-manager
namespace: kube-system
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
name: vsphere-cloud-controller-manager
namespace: kube-system
labels:
    k8s-app: vsphere-cloud-controller-manager
spec:
selector:
    matchLabels:
    k8s-app: vsphere-cloud-controller-manager
updateStrategy:
    type: RollingUpdate
template:
    metadata:
    labels:
        k8s-app: vsphere-cloud-controller-manager
    spec:
    nodeSelector:
        node-role.kubernetes.io/controlplane: "true"
    securityContext:
        runAsUser: 0
    tolerations:
    - key: node.cloudprovider.kubernetes.io/uninitialized
        value: "true"
        effect: NoSchedule
    - key: node-role.kubernetes.io/controlplane
        value: "true"
        effect: NoSchedule
    - key: node-role.kubernetes.io/etcd
        value: "true"
        effect: NoExecute
    serviceAccountName: cloud-controller-manager
    containers:
        - name: vsphere-cloud-controller-manager
        image: gcr.io/cloud-provider-vsphere/cpi/release/manager:latest
        args:
            - --v=2
            - --cloud-provider=vsphere
            - --cloud-config=/etc/cloud/cpi-vsphere.conf
        volumeMounts:
            - mountPath: /etc/cloud
            name: vsphere-config-volume
            readOnly: true
        resources:
            requests:
            cpu: 200m
    hostNetwork: true
    volumes:
    - name: vsphere-config-volume
        configMap:
        name: cloud-config
---
apiVersion: v1
kind: Service
metadata:
labels:
    component: cloud-controller-manager
name: vsphere-cloud-controller-manager
namespace: kube-system
spec:
type: NodePort
ports:
    - port: 43001
    protocol: TCP
    targetPort: 43001
selector:
    component: cloud-controller-manager
---
EOF

    c)  Apply this manifest
        kubectl apply -f $HOME/cloud-provider.yaml

5. Setup CSI secrets
    a) Create the vsphere.conf file to create the secrets
    
    tee $HOME/csi-vsphere.conf >/dev/null <<EOF
    [Global]
    cluster-id = "DEV-DC--c8"
    [VirtualCenter "vcenter01.kendopz.com"]
    insecure-flag = "true"
    user = "Administrator@vsphere.local"
    password = "DffrGggggrrrrr"
    port = "443"
    datacenters = "DEV-DC"

    b) Create the credential secret
    kubectl create secret generic vsphere-config-secret --from-file=$HOME/csi-vsphere.conf --namespace=kube-system

    c) Verify the secret
    kubectl get secret vsphere-config-secret -n kube-ssytem

    Now you can remove the csi-vsphere.conf.

6. Setting up CSI manifests
   a) Set up RBAC for CSI provider:

kind: ServiceAccount
apiVersion: v1
metadata:
name: vsphere-csi-controller
namespace: kube-system
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
name: vsphere-csi-controller-role
rules:
- apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get", "list", "watch"]
- apiGroups: ["storage.k8s.io"]
    resources: ["csidrivers"]
    verbs: ["create", "delete"]
- apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "list", "watch"]
- apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "update", "create", "delete"]
- apiGroups: ["storage.k8s.io"]
    resources: ["csinodes"]
    verbs: ["get", "list", "watch"]
- apiGroups: ["storage.k8s.io"]
    resources: ["volumeattachments"]
    verbs: ["get", "list", "watch", "update"]
- apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
- apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
- apiGroups: [""]
    resources: ["events"]
    verbs: ["list", "watch", "create", "update", "patch"]
- apiGroups: ["snapshot.storage.k8s.io"]
    resources: ["volumesnapshots"]
    verbs: ["get", "list"]
- apiGroups: ["snapshot.storage.k8s.io"]
    resources: ["volumesnapshotcontents"]
    verbs: ["get", "list"]
- apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
name: vsphere-csi-controller-binding
subjects:
- kind: ServiceAccount
    name: vsphere-csi-controller
    namespace: kube-system
roleRef:
kind: ClusterRole
name: vsphere-csi-controller-role
apiGroup: rbac.authorization.k8s.io
---

    b) Apply the manifest to the cluster
       kubectl apply -f csi-driver-rbac.yaml

7. Install the CSI controller
This involves deploying the controller and node drivers.

    a) Copy the following content to a csi-controller.yaml

kind: StatefulSet
apiVersion: apps/v1
metadata:
name: vsphere-csi-controller
namespace: kube-system
spec:
serviceName: vsphere-csi-controller
replicas: 1
updateStrategy:
    type: "RollingUpdate"
selector:
    matchLabels:
    app: vsphere-csi-controller
template:
    metadata:
    labels:
        app: vsphere-csi-controller
        role: vsphere-csi
    spec:
    serviceAccountName: vsphere-csi-controller
    nodeSelector:
        node-role.kubernetes.io/controlplane: "true"
    tolerations:
        - key: node-role.kubernetes.io/controlplane
        value: "true"
        effect: NoSchedule
        - key: node-role.kubernetes.io/etcd
        value: "true"
        effect: NoExecute
    dnsPolicy: "Default"
    containers:
        - name: csi-attacher
        image: quay.io/k8scsi/csi-attacher:v1.1.1
        args:
            - "--v=4"
            - "--timeout=300s"
            - "--csi-address=$(ADDRESS)"
        env:
            - name: ADDRESS
            value: /csi/csi.sock
        volumeMounts:
            - mountPath: /csi
            name: socket-dir
        - name: vsphere-csi-controller
        image: gcr.io/cloud-provider-vsphere/csi/release/driver:v1.0.1
        lifecycle:
            preStop:
            exec:
                command: ["/bin/sh", "-c", "rm -rf /var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com"]
        args:
            - "--v=4"
        imagePullPolicy: "Always"
        env:
            - name: CSI_ENDPOINT
            value: unix:///var/lib/csi/sockets/pluginproxy/csi.sock
            - name: X_CSI_MODE
            value: "controller"
            - name: VSPHERE_CSI_CONFIG
            value: "/etc/cloud/csi-vsphere.conf"
        volumeMounts:
            - mountPath: /etc/cloud
            name: vsphere-config-volume
            readOnly: true
            - mountPath: /var/lib/csi/sockets/pluginproxy/
            name: socket-dir
        ports:
            - name: healthz
            containerPort: 9808
            protocol: TCP
        livenessProbe:
            httpGet:
            path: /healthz
            port: healthz
            initialDelaySeconds: 10
            timeoutSeconds: 3
            periodSeconds: 5
            failureThreshold: 3
        - name: liveness-probe
        image: quay.io/k8scsi/livenessprobe:v1.1.0
        args:
            - "--csi-address=$(ADDRESS)"
        env:
            - name: ADDRESS
            value: /var/lib/csi/sockets/pluginproxy/csi.sock
        volumeMounts:
            - mountPath: /var/lib/csi/sockets/pluginproxy/
            name: socket-dir
        - name: vsphere-syncer
        image: gcr.io/cloud-provider-vsphere/csi/release/syncer:v1.0.1
        args:
            - "--v=2"
        imagePullPolicy: "Always"
        env:
            - name: FULL_SYNC_INTERVAL_MINUTES
            value: "30"
            - name: VSPHERE_CSI_CONFIG
            value: "/etc/cloud/csi-vsphere.conf"
        volumeMounts:
            - mountPath: /etc/cloud
            name: vsphere-config-volume
            readOnly: true
        - name: csi-provisioner
        image: quay.io/k8scsi/csi-provisioner:v1.2.2
        args:
            - "--v=4"
            - "--timeout=300s"
            - "--csi-address=$(ADDRESS)"
            - "--feature-gates=Topology=true"
            - "--strict-topology"
        env:
            - name: ADDRESS
            value: /csi/csi.sock
        volumeMounts:
            - mountPath: /csi
            name: socket-dir
    volumes:
        - name: vsphere-config-volume
        secret:
            secretName: vsphere-config-secret
        - name: socket-dir
        hostPath:
            path: /var/lib/csi/sockets/pluginproxy/csi.vsphere.vmware.com
            type: DirectoryOrCreate
---
apiVersion: storage.k8s.io/v1beta1
kind: CSIDriver
metadata:
name: csi.vsphere.vmware.com
spec:
attachRequired: true
podInfoOnMount: false

b) Apply the manifest:
kubectl create -f csi-controller.yaml

8. Install the CSI node driver
   a) Copy the following content to a csi-driver.yaml file:

kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: vsphere-csi-node
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: vsphere-csi-node
  updateStrategy:
    type: "RollingUpdate"
  template:
    metadata:
      labels:
        app: vsphere-csi-node
        role: vsphere-csi
    spec:
      dnsPolicy: "Default"
      containers:
        - name: node-driver-registrar
          image: quay.io/k8scsi/csi-node-driver-registrar:v1.1.0
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sh", "-c", "rm -rf /registration/csi.vsphere.vmware.com /var/lib/kubelet/plugins_registry/csi.vsphere.vmware.com /var/lib/kubelet/plugins_registry/csi.vsphere.vmware.com-reg.sock"]
          args:
            - "--v=5"
            - "--csi-address=$(ADDRESS)"
            - "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)"
          env:
            - name: ADDRESS
              value: /csi/csi.sock
            - name: DRIVER_REG_SOCK_PATH
              value: /var/lib/kubelet/plugins_registry/csi.vsphere.vmware.com/csi.sock
          securityContext:
            privileged: true
          volumeMounts:
            - name: plugin-dir
              mountPath: /csi
            - name: registration-dir
              mountPath: /registration
        - name: vsphere-csi-node
          image: gcr.io/cloud-provider-vsphere/csi/release/driver:v1.0.1
          imagePullPolicy: "Always"
          env:
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: CSI_ENDPOINT
              value: unix:///csi/csi.sock
            - name: X_CSI_MODE
              value: "node"
            - name: X_CSI_SPEC_REQ_VALIDATION
              value: "false"
            - name: VSPHERE_CSI_CONFIG
              value: "/etc/cloud/csi-vsphere.conf" # here csi-vsphere.conf is the name of the file used for creating secret using "--from-file" flag
          args:
            - "--v=4"
          securityContext:
            privileged: true
            capabilities:
              add: ["SYS_ADMIN"]
            allowPrivilegeEscalation: true
          volumeMounts:
            - name: vsphere-config-volume
              mountPath: /etc/cloud
              readOnly: true
            - name: plugin-dir
              mountPath: /csi
            - name: pods-mount-dir
              mountPath: /var/lib/kubelet
              # needed so that any mounts setup inside this container are
              # propagated back to the host machine.
              mountPropagation: "Bidirectional"
            - name: device-dir
              mountPath: /dev
          ports:
            - name: healthz
              containerPort: 9808
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /healthz
              port: healthz
            initialDelaySeconds: 10
            timeoutSeconds: 3
            periodSeconds: 5
            failureThreshold: 3
        - name: liveness-probe
          image: quay.io/k8scsi/livenessprobe:v1.1.0
          args:
            - "--csi-address=$(ADDRESS)"
          env:
            - name: ADDRESS
              value: /csi/csi.sock
          volumeMounts:
            - name: plugin-dir
              mountPath: /csi
      volumes:
        - name: vsphere-config-volume
          secret:
            secretName: vsphere-config-secret
        - name: registration-dir
          hostPath:
            path: /var/lib/kubelet/plugins_registry
            type: DirectoryOrCreate
        - name: plugin-dir
          hostPath:
            path: /var/lib/kubelet/plugins_registry/csi.vsphere.vmware.com
            type: DirectoryOrCreate
        - name: pods-mount-dir
          hostPath:
            path: /var/lib/kubelet
            type: Directory
        - name: device-dir
          hostPath:
            path: /dev

    b) Apply the manifest
    kubectl apply -f csi-driver.yaml

    c) Verify that the components are deployed
       Check csi daemonset pods are running and the CSINode CRD’s are set up
       kubectl get CSINode

9. Set up a storage class
   a) The sample manifest defines the storage class, where datastore url is the uuid for the datastore that can be referenced from vCenter.

tee storage-class.yaml > /dev/null <<EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: vsphere-csi
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: csi.vsphere.vmware.com
parameters:
  fstype: ext4
  DatastoreURL: "ds:///vmfs/volumes/5c59dcb0-c26630e3-3ae6-b8ca3aeefe3f/"
EOF

    b) Apply this storage class
    kubectl apply -f storage-class.yaml