#VPC Vars
# aws_vpc_cidr      = "172.30.0.0/16"
# aws_public_subnet_cidr = ["172.30.11.0/24", "172.30.12.0/24"]

# # single AZ deployment
#aws_public_subnet_cidr = ["172.30.11.0/24"]

# 3+ AZ deployment
#aws_public_subnet_cidr = ["172.30.11.0/24","172.30.12.0/24","172.30.13.0/24","172.30.14.0/24"]


#VPC Vars
aws_region              = "us-west-2"
aws_vpc_cidr            = "172.30.0.0/16"
aws_public_subnet_cidr  = ["172.30.11.0/24", "172.30.12.0/24", "172.30.13.0/24"]
aws_public_subnet_num   = "3"
aws_azs                 = ["us-west-2a", "us-west-2b", "us-west-2c"]
aws_keypair_name        = "k8s-apis"
aws_owner               = "Kubernetes"
aws_vpc_name            = "Kubernetes"
aws_name_prefix         = "k8s-prod"

#Kubernetes Cluster
kube_ssh_user = "core"
kube_elb_name = "apis-lb"

controller_instance_num  = "3"
controller_instance_disk = "30"
controller_instance_type = "t2.medium"

etcd_instance_num  = "3"
etcd_instance_disk = "30"
etcd_instance_type = "t2.micro"

worker_instance_num  = "6"
worker_instance_disk = "30"
worker_instance_type = "t2.micro"

#Infra
smb_instance_disk      = "50"
smb_instance_type      = "t2.medium"
smb_instance_ssh_user  = "ubuntu"
windows_instance_disk  = "150"
windows_instance_type  = "t2.medium"



/* Optional. Set as desired */
/* region = "us-east-1" */
/* zone = "us-east-1a, us-east-1b, us-east-1c" */

/*
   If your chosen region above doesn't have a corresponding ami
   in the "amis" variable (found in variables.tf), you can
   override the default below.
*/

/* amis = { us-west-2 = "ami-123456" } */
