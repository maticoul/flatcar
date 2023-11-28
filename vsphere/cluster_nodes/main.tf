terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0"
    }
  }
}

##### Provider
provider "vsphere" {
  user           = var.provider_vsphere_user
  password       = var.provider_vsphere_password
  vsphere_server = var.provider_vsphere_host

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.deploy_vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.deploy_vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.deploy_vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "default" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = var.deploy_vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.guest_vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "etcd01" {
  name                 = "${var.guest_name_prefix}-etcd01"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-etcd
  # num_cpus             = var.guest_num_cpus-etcd
  num_cpus             = var.guest_vcpu-etcd
  memory               = var.guest_memory-etcd 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/etcd01.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_etcd-01
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_etcd01}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_etcd01}
  #   EOF
  # }
}

## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "etcd02" {
  name                 = "${var.guest_name_prefix}-etcd02"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-etcd
  # num_cpus             = var.guest_num_cpus-etcd
  num_cpus             = var.guest_vcpu-etcd 
  memory               = var.guest_memory-etcd 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/etcd02.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_etcd-02
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_etcd02}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_etcd02}
  #   EOF
  # }
}

## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "etcd03" {
  name                 = "${var.guest_name_prefix}-etcd03"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-etcd
  # num_cpus             = var.guest_num_cpus-etcd 
  num_cpus             = var.guest_vcpu-etcd
  memory               = var.guest_memory-etcd 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/etcd03.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_etcd-03
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_etcd03}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_etcd03}
  #   EOF
  # }
}

## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "master01" {
  name                 = "${var.guest_name_prefix}-master01"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-masters
  # num_cpus             = var.guest_num_cpus-masters 
  num_cpus             = var.guest_vcpu-masters
  memory               = var.guest_memory-masters 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/master01.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_master-01
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_master01}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_master01}
  #   EOF
  # }
}

 
## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "master02" {
  name                 = "${var.guest_name_prefix}-master02"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-mastres
  # num_cpus             = var.guest_num_cpus-masters
  num_cpus             = var.guest_vcpu-masters 
  memory               = var.guest_memory-masters 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/master02.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_master-02
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_master02}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_master02}
  #   EOF
  # }
}
  
## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "master03" {
  name                 = "${var.guest_name_prefix}-master03"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-masters
  # num_cpus             = var.guest_num_cpus-masters 
  num_cpus             = var.guest_vcpu-masters
  memory               = var.guest_memory-masters 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/master03.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_master-03
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_master03}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_master03}
  #   EOF
  # }
}

## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "worker01" {
  name                 = "${var.guest_name_prefix}-worker01"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-workers
  # num_cpus             = var.guest_num_cpus-workers
  num_cpus             = var.guest_vcpu-workers 
  memory               = var.guest_memory-workers 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/worker01.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_worker-01
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_worker01}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_worker01}
  #   EOF
  # }
}


## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "worker02" {
  name                 = "${var.guest_name_prefix}-worker02"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-workers
  # num_cpus             = var.guest_num_cpus-workers 
  num_cpus             = var.guest_vcpu-workers
  memory               = var.guest_memory-workers 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/worker02.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_worker-02
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]
  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_worker02}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_worker02}
  #   EOF
  # }
}

## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "worker03" {
  name                 = "${var.guest_name_prefix}-worker03"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  # num_cores_per_socket = var.guest_num_cores_per_socket-workers
  # num_cpus             = var.guest_num_cpus-workers
  num_cpus             = var.guest_vcpu-workers 
  memory               = var.guest_memory-workers 
#  guest_id             = "other5xLinux64Guest"
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  disk {
    label       = "disk0"
    size        = "30"
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "./flatcar_production_vmware_ova.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.network.id
      "Network 2" = data.vsphere_network.network.id
    }
  }
  extra_config = {
    "guestinfo.ignition.config.data.encoding" = "base64"
    "guestinfo.ignition.config.data" = "${base64encode(file("./templates/worker03.json"))}"
  }

  connection {
    type        = "ssh"
    host        = var.guest_host_worker-03
    user        = var.guest_ssh_user
    password    = var.guest_ssh_password
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]

  } 

  # provisioner "local-exec" {
  #   command = <<EOF
  #     ssh-keygen -R -y ${var.guest_host_worker03}
  #     echo ${var.guest_ssh_password} | ssh-copy-id -i ~/.ssh/id_rsa.pub ${var.guest_ssh_user}@${var.guest_host_worker03}
  #   EOF
  # }
}