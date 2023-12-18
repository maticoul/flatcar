#VPC Vars
aws_region              = "us-east-2"
aws_vpc_cidr            = "172.30.0.0/16"
aws_private_subnet_cidr = ["172.30.12.0/24", "172.30.13.0/24", "172.30.14.0/24"]
aws_private_subnet_num  = "3"
aws_azs                 = ["us-east-2a", "us-east-2b", "us-east-2c"]
aws_keypair_name        = "k8s-apis"
aws_owner               = "Kubernetes"
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
smb-instance_disk      = "50"
smb-instance-type      = "t2.medium"
smb-instance_ssh_user  = "ubuntu"
windows-instance_disk  = "150"
windows-instance-type  = "t2.medium"

