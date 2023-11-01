variable control_cidr {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable "guest_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  default = "k8s"
}

variable "guest_ssh_user" {
  description = "SSH username to connect to the guest VM."
  type = string
  default = "core"
}

variable "guest_ssh_user-bastion" {
  description = "SSH username to connect to the guest VM."
  type = string
  default = "ubuntu"
}

# variable default_keypair_public_key {
#   description = "Public Key of the default keypair"
# }

variable "default_keypair_name" {
  description = "Name of the KeyPair used for all nodes"
  #default = ""
  type = string
  default = "k8s-apis"
}

variable "vpc_name" {
  description = "Name of the VPC"
  #default = ""
  type = string
  default = "kubernetes"
}


variable "elb_name" {
  description = "Name of the ELB for Kubernetes API"
  #default = ""
  type = string
  default = "apis-lb"
}

variable "owner" {
  #default = ""
  type = string
  default = "Kubernetes"
}

# variable ansibleFilter {
#   description = "`ansibleFilter` tag value added to all instances, to enable instance filtering in Ansible dynamic inventory"
  #default = ""
  #default = "Kubernetes" # IF YOU CHANGE THIS YOU HAVE TO CHANGE instance_filters = tag:ansibleFilter=Kubernetes01 in ./ansible/hosts/ec2.ini
#}

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

# variable kubernetes_pod_cidr {
#   #default = ""
#   #default = "192.168.0.0/16"
# }


# Instances Setup
variable amis {
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
    us-west-2 = "ami-01afff0691ed88b86"
  }
}
# variable "default_instance_user" {
#   #default = "securiport"
# }

# variable default_instance_user {
#   default = "securiport"
# } 

variable "etcd_instance_type" {
  #default = ""
  type = string
  default = "t2.micro"
}
variable "controller_instance_type" {
  #default = ""
  type = string
  default = "t2.micro"
}
variable "worker_instance_type" {
  #default = "" 
  type = string
  default = "t2.micro"
}


# variable kubernetes_cluster_dns {
#  #default = ""
#  # default = "10.31.0.1"
# }
