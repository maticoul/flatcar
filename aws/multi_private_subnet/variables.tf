variable "disk_Bastion-windows" {
  description = "Name of the VPC"
  #default = "30"
}

variable "disk_Bastion-lunix" {
  description = "Name of the VPC"
  #default = "30"
}

variable "guest_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  #default = "k8s"
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

variable "owner" {
  type = string
  #default = "Kubernetes"
}

# Networking setup
variable "region" {
  #default = "us-west-2"
  type = string
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 #default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable "vpc_cidr" {
  #default = "172.30.0.0/16"
}

variable "instance_type-bastion-lunix" {
  #default = ""
}

variable "instance_type-bastion-windows" {
  #default = ""
}

variable "subnet-public_cidr" {
  type        = string
  #default = "172.30.11.0/24"
}

variable amis-ubuntu {
  description = "Default AMIs to use for nodes depending on the region"
  type = map
  default = {
    ap-northeast-1 = "ami-0567c164"
    ap-southeast-1 = "ami-a1288ec2"
    cn-north-1 = "ami-d9f226b4"
    eu-central-1 = "ami-8504fdea"
    eu-west-1 = "ami-0d77397e"
    sa-east-1 = "ami-e93da085"
    us-east-1 = "ami-0e12c4fb31633888a"
    us-west-1 = "ami-6e165d0e"
    us-west-2 = "ami-a9d276c9"
  }
}

variable amis-windows {
  description = "Default AMIs to use for nodes depending on the region"
  type = map
  default = {
    ap-northeast-1 = "ami-0567c164"
    ap-southeast-1 = "ami-a1288ec2"
    cn-north-1 = "ami-d9f226b4"
    eu-central-1 = "ami-8504fdea"
    eu-west-1 = "ami-0d77397e"
    sa-east-1 = "ami-e93da085"
    us-east-1 = "ami-0e12c4fb31633888a"
    us-west-1 = "ami-6e165d0e"
    us-west-2 = "ami-a9d276c9"
  }
}
# Instances Setup
# variable ami-bastion-lunix {
#   description = "Default AMIs to use for nodes depending on the region"
  # type = map
  # default = {
  #   ap-northeast-1 = "ami-0567c164"
  #   ap-southeast-1 = "ami-a1288ec2"
  #   cn-north-1 = "ami-d9f226b4"
  #   eu-central-1 = "ami-8504fdea"
  #   eu-west-1 = "ami-0d77397e"
  #   sa-east-1 = "ami-e93da085"
  #   us-east-1 = "ami-0e12c4fb31633888a"
  #   us-west-1 = "ami-6e165d0e"
  #   us-west-2 = "ami-01afff0691ed88b86"
  # }
# }

# variable ami-bastion-windows {
#   description = "Default AMIs to use for nodes depending on the region"
#   # default = {
# }