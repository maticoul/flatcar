variable control_cidr {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable "aws_subnet" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = ""
}

variable "ha-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = ""
}

variable "nfs-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = ""
}

variable "smb-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = ""
}

variable "windows-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = ""
}

variable "security_group.bastion" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = ""
}

variable "aws_ami" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = "ami-03f65b8614a860c29"
}

variable "guest_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = "k8s"
}

variable "guest_ssh_user" {
  description = "SSH username to connect to the guest VM."
  type = string
  default = "ubuntu"
}

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
  #default = ""
  type = string
  default = "k8s-apis"
}

variable "owner" {
  #default = ""
  type = string
  default = "Kubernetes"
}

# Networking setup
variable "region" {
  default = "us-west-2"
  type = string
}

variable "zone" {
  default = "us-west-2a"
  type = string
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable "vpc_cidr" {
  #default = ""
  #type = string
  default = "172.30.0.0/16"
}

variable "subnet-private_cidr" {
  type        = string
  default = "172.30.12.0/24"
}
variable "subnet-public_cidr" {
  type        = string
  default = "172.30.13.0/24"
}

