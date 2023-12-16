variable "disk_etcd" {
  description = "Name of the VPC"
  #default = "30"
}

variable "disk_master" {
  description = "Name of the VPC"
  #default = "30"
}

variable "disk_worker" {
  description = "Name of the VPC"
  #default = "30"
}

variable "disk_smb" {
  description = "Name of the VPC"
  #default = "50"
}

variable "disk_nfs" {
  description = "Name of the VPC"
  #default = "1024"
}

variable "disk_iics" {
  description = "Name of the VPC"
  #default = "250"
}

variable "vpc_kubernetes" {
  description = "Name of the VPC"
  type = string
  #default = ""
}

variable "subnet_public" {
  description = "Name of the VPC"
  type = string
  #default = ""
}

# variable "ami_infra" {
#   description = "Name of the VPC"
#   type = string
#   #default = "ami-03f65b8614a860c29"
# }

# variable "ami_iics" {
#   description = "Name of the VPC"
#   type = string
#   #default = "ami-0fae5ac34f36d5963"
# }

variable amis {
  description = "Default AMIs to use for nodes depending on the region"
  type = map
  default = {      
	af-south-1 = "ami-097488680d71eca73"
    ap-east-1 = "ami-0f07205ae67bbc643"
    ap-northeast-1 ="ami-0be127e34b9de2d91"
    ap-northeast-2 = "ami-00a28d7b6c3a2941f"
    ap-south-1 = "ami-099f89600a3e7be42"
    ap-southeast-1 = "ami-0e0f99ffaff15079c"
    ap-southeast-2 = "ami-014e556d2ec06e2f5"
    ap-southeast-3 = "ami-04e436d2335818662"
    ca-central-1 = "ami-04a8af4c3cad13e04"
    eu-central-1 = "ami-067d5917875d02d3a"
    eu-north-1 = "ami-01d0b8725ca46b427"
    eu-south-1 = "ami-09305d5acfe5301a1"
    eu-west-1 = "ami-00608b016ff882bc5"
    eu-west-2 = "ami-083d828d4f91e462a"
    eu-west-3 = "ami-02afddc708a6316e2"
    me-south-1 = "ami-0294e745bbb404605"
    sa-east-1 = "ami-04c86686205b2968c"
    us-east-1 = "ami-068c9f344cfa33323"
    us-east-2 = "ami-0108e09121726fc88"
    us-west-1 = "ami-0b2bc1a1493b4b95f"
    us-west-2 = "ami-0acf5f8c6f38cfe9e"
    	}
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

variable amis-flatcar {
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

variable "guest_ssh_user-infra" {
  description = "SSH username to connect to the guest VM."
  type = string
  #default = "ubuntu"
}

variable "keypair_name" {
  description = "Name of the KeyPair used for all nodes"
  type = string
  #default = "k8s-apis"
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

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 #default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable "vpc_cidr" {
  #default = "172.30.0.0/16"
}

variable "subnet-public_cidr" {
  type        = string
  #default = "172.30.11.0/24"
}

variable "private_subnet_cidr" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 #default     = ["172.30.12.0/24", "172.30.13.0/24", "172.30.14.0/24"]
}

variable "etcd_instance_type" {
  type = string
  #default = "t2.micro"
}
variable "controller_instance_type" {
  type = string
  #default = "t2.medium"
}
variable "worker_instance_type" {
  type = string
  #default = "t2.micro"
}

variable "nfs-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  #default = ""
}

variable "smb-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  #default = ""
}

variable "windows-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  #default = ""
}
