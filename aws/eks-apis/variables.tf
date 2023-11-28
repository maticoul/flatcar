variable "cluster-name" {
}

variable "vpc_name" {
}

variable control_cidr {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable "guest_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
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
