/*
   DO NOT EDIT terraform.tfvars.example! Copy it instead to
   terraform.tfvars and edit that file.
*/

/* Required variables */
# default_keypair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMg7VCMel8GVMiwyPenhBQ2blwvXg54Kp2tr1Za10xtXlVA2RAY7iVC4ljTA0duxr5OEI75PyN1K0TulfWe/bDCLqXD06nBcGut1N+nivQs9Vg3M+C3t447d/435cwgTdwEx56RapXywxA+s406t/COYAhjCTxVhf+a/Sqo+HfsKyt9PrLrFOAYsdYiYgdAgf3leHtYp6hSaUeAahtIt1jRhiE/ISUxWJw5oe8sODXrXHfR4hH3NyaWlNz/KbAPOKvAX3HT+QBm23PIhd2Pqs54NrFspqXA6h+glnWZf5dDrlPiBqjGXjuIP/lKSO/btxF5ABf+OEQBVpCossoraXV k8s-apis-preprod"

disk_etcd = "30"
disk_master = "30"
disk_worker = "30"
disk_smb = "50"
disk_nfs = "1024"
disk_iics = "150"
vpc_kubernetes = ""
subnet_public = ""
ami_infra = "ami-03f65b8614a860c29"
ami_iics = "ami-0fae5ac34f36d5963"
#amis = "ami-01afff0691ed88b86"
control_cidr = "172.30.12.0/24"
keypair_name = "k8s-apis"
elb_name = "apis-lb"
owner = "Kubernetes"
region = "us-west-2"
zone = "us-west-2a"
vpc_cidr = "172.30.0.0/16"
etcd_instance_type = "t2.micro"
controller_instance_type = "t2.medium"
worker_instance_type = "t2.micro"
subnet-private_cidr = "172.30.12.0/24"
subnet-public_cidr = "172.30.13.0/24"
guest_name_prefix  = "k8s-prod"
guest_ssh_user     = "core"
guest_ssh_user-bastion  = "ubuntu"

/* Optional. Set as desired */
/* region = "us-east-1" */
/* zone = "us-east-1a, us-east-1b, us-east-1c" */

/*
   If your chosen region above doesn't have a corresponding ami
   in the "amis" variable (found in variables.tf), you can
   override the default below.
*/

/* amis = { us-west-2 = "ami-123456" } */

