variable "aws_region" {
    description = "AWS Region"
    default = "us-east-1"
}


variable "ami" {
  description = "AMI ID, use it to fixate control-plane AMI in order to avoid force-recreation it at later times"
  default     = ""
}

variable "ami_filters" {
  description = "map with AMI filters"
  default = {
    ubuntu = {
      owners     = ["099720109477"] # Canonical
      image_name = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    centos = {
      owners     = ["125523088429"] # CentOS
      image_name = ["CentOS 8.2.* x86_64"]
    }

    flatcar = {
      owners     = ["075585003325"] # Kinvolk
      image_name = ["Flatcar-stable-*-hvm"]
    }

    rhel = {
      owners     = ["309956199498"] # Red Hat
      image_name = ["RHEL-8*_HVM-*-x86_64-*"]
    }
  }
}


variable "instance_type" {
  description = "Instance type"
  default = "m5.2xlarge"
}

variable "az" {
  description = "Availabilty zone"
  default = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
  default = "vpc-0d93d7272e3a8c774"
}
variable "key_name" {
    description = "SSH Key Name"
    default = "mcoulibaly"
}

variable "iam_profile" {
    description = "IAM Profile Name"
    default = "swarmProvisioning"
}

variable "subnet_id" {
  description = "Subnet ID"
  default = "subnet-0ae6733d6a5ce43b8"
}

variable "cluster_name" {
  description = "Cluster Name"
  default = "ARG-Preprod"
}

variable "ssh_public_key_file" {
  description = "SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_port" {
  description = "SSH port to be used to provision instances"
  default     = 22
}

variable "ssh_username" {
  description = "SSH user, used only in output"
  default     = "ubuntu"
}

variable "ssh_private_key_file" {
  description = "SSH private key file used to access instances"
  default     = ""
}

variable "ssh_agent_socket" {
  description = "SSH Agent socket, default to grab from $SSH_AUTH_SOCK"
  default     = "env:SSH_AUTH_SOCK"
}

variable "internal_api_lb" {
  default     = false
  description = "make kubernetes API loadbalancer internal (reachible only from inside the VPC)"
}

variable "open_nodeports" {
  default     = false
  description = "open NodePorts flag"
}

variable "initial_machinedeployment_replicas" {
  default     = 1
  description = "number of replicas per MachineDeployment"
}

variable "os" {
  description = "Operating System to use in AMI filtering and MachineDeployment"

  # valid choices are:
  # * ubuntu
  # * centos
  # * rhel
  # * flatcar
  default = "ubuntu"
}

variable "worker_os" {
  description = "OS to run on worker machines, default to var.os"

  # valid choices are:
  # * ubuntu
  # * centos
  # * flatcar
  # * rhel
  default = ""
}
variable "instance_ips" {
  default = {
    "0" = "172.30.12.50"
    "1" = "172.30.12.51"
    "2" = "172.30.12.52"
    "3" = "172.30.12.100"
    "4" = "172.30.12.101"
    "5" = "172.30.12.102"
    "6" = "172.30.12.103"
  }
}

variable "instance_hostnames" {
  default = {
    "0" = "ip-172-30-12-50.ec2.internal"
    "1" = "ip-172-30-12-51.ec2.internal"
    "2" = "ip-172-30-12-52.internal"
    "3" = "ip-172-30-12-100.ec2.internal"
    "4" = "ip-172-30-12-101.ec2.internal"
    "5" = "ip-172-30-12-102.ec2.internal"
    "6" = "ip-172-30-12-103.ec2.internal"
  }
}
