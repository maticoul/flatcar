variable "aws_bastion_windows_disk" {
  description = "Name of the VPC"
  #default = "30"
}

variable "aws_bastion_lunix_disk" {
  description = "Name of the VPC"
  #default = "30"
}

variable "aws_name_prefix" {
  description = "VM / hostname prefix for the kubernetes cluster."
  type = string
  #default = "k8s"
}

variable "aws_ssh_user-bastion" {
  description = "SSH username to connect to the guest VM."
  type = string
  #default = "ubuntu"
}

variable "aws_keypair_name" {
  description = "Name of the KeyPair used for all nodes"
  type = string
  #default = "k8s-apis"
}

variable "aws_vpc_name" {
  description = "Name of the VPC"
  type = string
  #default = "kubernetes"
}

variable "aws_owner" {
  type = string
  #default = "Kubernetes"
}

# Networking setup
variable "aws_region" {
  #default = "us-west-2"
  type = string
}

variable "aws_azs" {
 type        = list(string)
 description = "Availability Zones"
 #default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

### VARIABLES BELOW MUST NOT BE CHANGED ###

variable "aws_vpc_cidr" {
  #default = "172.30.0.0/16"
}

variable "aws_bastion_lunix_type" {
  #default = ""
}

variable "aws_bastion_windows_type" {
  #default = ""
}

variable "aws_cidr_subnets_public_cidr" {
  type        = string
  #default = "172.30.11.0/24"
}

###### Infra #####

variable amis_ubuntu {
  description = "Default AMIs to use for nodes depending on the region"
  type = map
  default = {
    af-south-1	 	 =  ami-0e878fcddf2937686
    ap-east-1	 	   =  ami-0d96ec8a788679eb2	 
    ap-south-1	 	 =  ami-03f4878755434977f
    ap-south-2	   =	ami-0bbc2f7f6287d5ca6
    ap-northeast-1 =	ami-07c589821f2b353aa	 
    ap-northeast-2 =  ami-0f3a440bbcff3d043
    ap-northeast-3 =	ami-05ff0b3a7128cd6f8
    ap-southeast-1 =	ami-0fa377108253bf620	
    ap-southeast-2 =	ami-04f5097681773b989 
    ap-southeast-3 =	ami-02157887724ade8ba
    ap-southeast-4 = 	ami-03842bc45d2ad8394
    ca-central-1   =	ami-0a2e7efb4257c0907	 
    cn-north-1	 	 =  ami-0da6624a66d5efea8	 
    cn-northwest-1 =	ami-017ca9a70aea59fd2
    eu-central-1	 =  ami-0faab6bdbac9486fb
    eu-central-2	 =  ami-02e901e47eb942582
    eu-north-1	 	 =  ami-0014ce3e52359afbd
    eu-south-1	 	 =  ami-056bb2662ef466553
    eu-south-2	 	 =  ami-0a9e7160cebfd8c12	
    eu-west-1	 	   =  ami-0905a3c97561e0b69	 
    eu-west-2	 	   =  ami-0e5f882be1900e43b		 
    eu-west-3		   =  ami-01d21b7be69801c2f
    il-central-1	 =  ami-0fd2d59e9df02d839
    me-south-1	 	 =  ami-0ce1025465c85da8d	 
    me-central-1	 =  ami-0b98fa71853d8d270	 
    us-east-1	 	   =  ami-0c7217cdde317cfec	  
    us-east-2		   =  ami-05fb0b8c1424f266b	 
    us-west-1	 	   =  ami-0ce2cb35386fc22e9
    us-west-2	 	   =  ami-008fe2fc65df48dac	  
    sa-east-1	 	   =  ami-0fb4cf3a99aa89f72
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