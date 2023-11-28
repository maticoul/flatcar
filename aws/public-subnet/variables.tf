variable "disk_etcd" {
  description = "Name of the VPC"
  default = "30"
}

variable "disk_master" {
  description = "Name of the VPC"
  default = "30"
}

variable "disk_worker" {
  description = "Name of the VPC"
  default = "30"
}

variable "disk_smb" {
  description = "Name of the VPC"
  default = "50"
}

variable "disk_nfs" {
  description = "Name of the VPC"
  default = "1024"
}

variable "disk_iics" {
  description = "Name of the VPC"
  default = "250"
}

variable "disk_Bastion" {
  description = "Name of the VPC"
  default = "250"
}

variable "ami_infra" {
  description = "Name of the VPC"
  type = string
  default = "ami-03f65b8614a860c29"
}

variable "ami_iics" {
  description = "Name of the VPC"
  type = string
  default = "ami-0fae5ac34f36d5963"
}

variable "aws_ami" {
  type = string
  default = "t2.micro"
}

variable "etcd_instance_type" {
  type = string
  default = "t2.micro"
}
variable "controller_instance_type" {
  type = string
  default = "t2.medium"
}
variable "worker_instance_type" {
  type = string
  default = "t2.micro"
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

variable control_cidr {
  description = "CIDR for maintenance: inbound traffic will be allowed from this IPs"
}

variable default_keypair_public_key {
  description = "Public Key of the default keypair"
}

variable keypair_name {
  description = "Name of the KeyPair used for all nodes"
  default = "k8s-apis"
}

variable vpc_name {
  description = "Name of the VPC"
  default = "kubernetes"
}


variable elb_name {
  description = "Name of the ELB for Kubernetes API"
  default = "apis-lb"
}

variable owner {
  default = "Kubernetes"
}

variable ansibleFilter {
  description = "`ansibleFilter` tag value added to all instances, to enable instance filtering in Ansible dynamic inventory"
  default = "Kubernetes" # IF YOU CHANGE THIS YOU HAVE TO CHANGE instance_filters = tag:ansibleFilter=Kubernetes01 in ./ansible/hosts/ec2.ini
}

# Networking setup
variable region {
  default = "us-west-2"
}

variable zone {
  default = "us-west-2a"
}

variable "guest_ssh_user" {
  description = "SSH username to connect to the guest VM."
  default = "core"
}
variable "guest_ssh_user-bastion" {
  description = "SSH username to connect to the guest VM."
  default = "ubuntu"
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable vpc_cidr {
  default = "172.30.0.0/16"
}
variable "subnet_cidr" {
  default = "172.30.12.0/24"
}
variable kubernetes_pod_cidr {
  default = "192.168.0.0/16"
}


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
variable default_instance_user {
  default = "securiport"
}

variable kubernetes_cluster_dns {
  default = "10.31.0.1"
}
