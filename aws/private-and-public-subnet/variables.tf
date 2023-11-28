variable "ami-bastion-lunix" {
  description = "Name of the VPC"
  #default = "30"
}

variable "ami-bastion-windows" {
  description = "Name of the VPC"
  #default = "30"
}

variable "instance_type-bastion-lunix" {
  description = "Name of the VPC"
  #default = "30"
}

variable "instance_type-bastion-windows" {
  description = "Name of the VPC"
  #default = "50"
}

variable "disk_bastion-lunix" {
  description = "Name of the VPC"
  #default = "250"
}

variable "disk_bastion-windows" {
  description = "Name of the VPC"
  #default = "250"
}

variable control_cidr {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable "guest_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  #default = "k8s"
}

variable "guest_ssh_user" {
  description = "SSH username to connect to the guest VM."
  type = string
  #default = "core"
}

variable "guest_ssh_user-bastion" {
  description = "SSH username to connect to the guest VM."
  type = string
  #default = "ubuntu"
}

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
  type = string
  #default = "k8s-apis"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type = string
  #default = "kubernetes"
}


variable "elb_name" {
  description = "Name of the ELB for Kubernetes API"
  type = string
  #default = "apis-lb"
}

variable "owner" {
  type = string
  #default = "Kubernetes"
}

# Networking setup
variable "region" {
  #default = "us-west-2"
  type = string
}

variable "zone" {
  #default = "us-west-2a"
  type = string
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable "vpc_cidr" {
  type = string
  #default = "172.30.0.0/16"
}

variable "subnet-private_cidr" {
  type        = string
  #default = "172.30.12.0/24"
}
variable "subnet-public_cidr" {
  type        = string
  #default = "172.30.13.0/24"
}

# Instances Setup
variable ami-ami-bastion-lunix {
  description = "Default AMIs to use for nodes depending on the region"
  #default = ""
}

# Instances Setup
variable ami-ami-bastion-windows {
  description = "Default AMIs to use for nodes depending on the region"
  #default = ""
  
}