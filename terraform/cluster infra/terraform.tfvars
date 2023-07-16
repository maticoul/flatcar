# Provider
provider_vsphere_host     = "192.168.40.23:9443"
provider_vsphere_user     = "Administrator@vsphere.local"
provider_vsphere_password = "5ecur1p0rtM@"

# Infrastructure
deploy_vsphere_datacenter = "Securiport"
deploy_vsphere_cluster    = "Securiport"
deploy_vsphere_datastore  = "DATAS"
deploy_vsphere_network    = "VM Network"

# Guest
guest_name_prefix     = "k8s-prod"
guest_template        = "Zabbix"
guest_num_cores_per_socket    = "3"
guest_vcpu            = "6"
guest_memory          = "4096"
guest_ipv4_netmask    = "24"
guest_ipv4_gateway    = "192.168.40.1"
guest_dns_servers     = "8.8.8.8"
guest_dns_suffix      = "securiportbko.ml"
guest_domain          = "securiportbko.ml"
guest_ssh_user        = "securiport"
guest_ssh_password    = "Securiport1!"
guest_ssh_key_private = "~/.ssh/id_rsa"
guest_ssh_key_public  = "~/.ssh/id_rsa.pub"
haproxy-disk-size     = "50"
smb-srv-disk-size     = "50"
nfs-srv-disk-size     = "250"


guest_host_nfs-srv    = "192.168.40.26"
guest_host_haproxy    = "192.168.40.27"
guest_host_smb-srv    = "192.168.40.28"
subnet        = "192.168.40.0"
