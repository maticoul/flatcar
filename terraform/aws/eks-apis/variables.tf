variable "disk_bastion-windows" {
}

variable "disk_bastion-lunix" {
}

variable "guest_ssh_user-bastion" {
}

variable "instance_type-bastion-lunix" {
}

variable "instance_type-bastion-windows" {
}

variable ami-bastion-lunix {
  
}

variable ami-bastion-windows {
}

variable "cluster-name" {
}

variable "vpc_name" {
}

variable "disk_smb" {
}

variable "disk_nfs" {
   
}

variable "disk_iics" {
   
}

variable "ami_infra" {
   
}

variable "ami_iics" {
   
}

variable control_cidr {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable "guest_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
}

variable "guest_ssh_user-infra" {
  description = "SSH username to connect to the guest VM."
}

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
}

variable "owner" {
}

# Networking setup

variable "region" {
}

variable "azs" {
 type        = list(string)
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable "vpc_cidr" {
}

variable "subnet-public_cidr" {
}

variable "private_subnet_cidr" {
 type        = list(string)
}

# Instances Setup
variable amis {
}

variable "nfs-instance-type" {
}

variable "smb-instance-type" {
}

variable "windows-instance-type" {
}
