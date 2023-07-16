# Provider
provider_vsphere_host     = "172.25.100.15"
provider_vsphere_user     = "Administrator@vsphere.local"
provider_vsphere_password = "S3curiport!"

# Infrastructure
deploy_vsphere_datacenter = "DataCenter-AR-DNM"
deploy_vsphere_cluster    = "Cluster-AR-DNM"
deploy_vsphere_datastore  = "PowerStore AR-DNM"
guest_vsphere_network    = "DVS-AR-DNM-PG_MGMT"
deploy_vsphere_host       = "172.25.100.13"

# Guest
#guest_vsphere_network = "VM Network"
guest_name_prefix     = "k8s-prod"
guest_num_cores_per_socket    = "3"
guest_num_cpus        = "6"
guest_memory          = "4096"
guest_ssh_user        = "securiport"
guest_ssh_password    = "Securiport"

# etcd(s)
  guest_host_etcd-01 = "172.25.100.54"
  guest_host_etcd-02 = "172.25.100.55"
  guest_host_etcd-03 = "172.25.100.56"

# Master(s)
  guest_host_master-01 = "172.25.100.51"
  guest_host_master-02 = "172.25.100.52"
  guest_host_master-03 = "172.25.100.53"

# Worker(s)
  guest_host_worker-01 = "172.25.100.41"
  guest_host_worker-02 = "172.25.100.42"
  guest_host_worker-03 = "172.25.100.43"