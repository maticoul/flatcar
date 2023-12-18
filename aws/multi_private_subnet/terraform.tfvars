/*
   DO NOT EDIT terraform.tfvars.example! Copy it instead to
   terraform.tfvars and edit that file.
*/

/* Required variables */
# default_keypair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMg7VCMel8GVMiwyPenhBQ2blwvXg54Kp2tr1Za10xtXlVA2RAY7iVC4ljTA0duxr5OEI75PyN1K0TulfWe/bDCLqXD06nBcGut1N+nivQs9Vg3M+C3t447d/435cwgTdwEx56RapXywxA+s406t/COYAhjCTxVhf+a/Sqo+HfsKyt9PrLrFOAYsdYiYgdAgf3leHtYp6hSaUeAahtIt1jRhiE/ISUxWJw5oe8sODXrXHfR4hH3NyaWlNz/KbAPOKvAX3HT+QBm23PIhd2Pqs54NrFspqXA6h+glnWZf5dDrlPiBqjGXjuIP/lKSO/btxF5ABf+OEQBVpCossoraXV k8s-apis-preprod"


#VPC Vars
# aws_vpc_cidr      = "172.30.0.0/16"
# aws_cidr_subnets_public_cidr = ["172.30.11.0/24", "172.30.12.0/24"]

# # single AZ deployment
#aws_cidr_subnets_public_cidr = ["172.30.11.0/24"]

# 3+ AZ deployment
#aws_cidr_subnets_public_cidr = ["172.30.11.0/24","172.30.12.0/24","172.30.13.0/24","172.30.14.0/24"]


aws_bastion_lunix_type   = "t2.micro"
aws_bastion_windows_type = "t2.medium"
aws_bastion_lunix_disk   = "60"
aws_bastion_windows_disk = "250"
aws_region               = "us-east-2"
aws_azs                  = ["us-east-2a", "us-east-2b", "us-east-2c"]
aws_keypair_name         = "k8s-apis"
aws_vpc_name             = "Kubernetes"
aws_owner                = "Kubernetes"
aws_vpc_cidr             = "172.30.0.0/16"
aws_name_prefix          = "k8s-prod"
aws_ssh_user-bastion     = "ubuntu"
aws_cidr_subnets_public_cidr = "172.30.11.0/24"


/* Optional. Set as desired */
/* region = "us-east-1" */
/* zone = "us-east-1a, us-east-1b, us-east-1c" */

/*
   If your chosen region above doesn't have a corresponding ami
   in the "amis" variable (found in variables.tf), you can
   override the default below.
*/

/* amis = { us-west-2 = "ami-123456" } */

