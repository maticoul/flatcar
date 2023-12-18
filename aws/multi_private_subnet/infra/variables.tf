####### VPC Vars #######

variable "vpc_kubernetes" {
  description = "Id of the VPC"
  type = string
}

variable "subnet_public" {
  description = "Id of public subnet"
}

variable "aws_private_subnet_num" {
  description = "Number of private subnet"
  type = string
}

variable "aws_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string  
}

variable "aws_keypair_name" {
  description = "Name of the KeyPair used for all nodes"
  type = string 
}

variable "aws_owner" {
  description = "Name of owner"
  type = string
}

###### Networking setup  ######
variable "aws_region" {
  description = "which region will be installed resouces"
  type = string
}

variable "aws_azs" {
 type        = list(string)
 description = "Availability Zones"
 
}

variable "aws_vpc_cidr" {
  description = "vpc Subnet CIDR values"
}

variable "aws_private_subnet_cidr" {
 type        = list(string)
 description = "Private Subnet CIDR values"
}

####### Kubernetes Cluster #######
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

variable "kube_elb_name" {
  description = "Name of the ELB for Kubernetes API"
  type = string
}

variable "etcd_instance_type" {
  type = string
  description = "etcd instances type"
}

variable "etcd_instance_num" {
  type = string
  description = "etcd instances number"
}

variable "etcd_instance_disk" {
  type = string
  description = "etcd instances disk space"
}

variable "controller_instance_type" {
  type = string
  description = "controller instance type"
}

variable "controller_instance_num" {
  type = string
  description = "number of controller instance"
}

variable "controller_instance_disk" {
  type = string
  description = "controller instance disk space"
}

variable "worker_instance_type" {
  type = string
  description = "worker instance type"
}

variable "worker_instance_num" {
  type = string
  description = "number of worker instance"
}

variable "worker_instance_disk" {
  type = string
  description = "worker instance disk space"
}


###### Infra #####

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

variable "kube_ssh_user" {
  description = "SSH username to connect to the guest VM."
  type = string
}

variable "smb-instance_ssh_user" {
  description = "SSH username to connect to the guest VM."
  type = string
  #default = "ubuntu"
}

variable "smb-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
   
}

variable "smb-instance_disk" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
   
}

variable "windows-instance-type" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
   
}

variable "windows-instance_disk" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
   
}