############
## VPC
############

resource "aws_vpc" "kubernetes" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}

# # DHCP Options are not actually required, being identical to the Default Option Set
# resource "aws_vpc_dhcp_options" "dns_resolver" {
#   domain_name = "compute.internal"
#   domain_name_servers = ["8.8.8.8", "8.8.4.4"]

#   tags = {
#     Name = "${var.vpc_name}"
#     Owner = "${var.owner}"
#   }
# }

# resource "aws_vpc_dhcp_options_association" "dns_resolver" {
#   vpc_id ="${aws_vpc.kubernetes.id}"
#   dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
# }

##########
# Keypair
##########

resource "aws_key_pair" "default_keypair" {
  key_name = "${var.keypair_name}"
#  public_key = "${var.default_keypair_public_key}"
  public_key = tls_private_key.rsa.public_key_openssh

  tags = {
    Name = "${var.vpc_name}"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "${var.keypair_name}"
}


############
## Subnets
############

# Subnet (private)
resource "aws_subnet" "kubernetes-private" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  cidr_block = "${var.subnet-private_cidr}"
  availability_zone = "${var.zone}"

  tags = {
    Name = "kubernetes-private"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}

# Subnet (public)
resource "aws_subnet" "kubernetes-public" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  cidr_block = "${var.subnet-public_cidr}"
  availability_zone = "${var.zone}"
  map_public_ip_on_launch = true  # This makes it a private subnet

  tags = {
    Name = "kubernetes-public"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}

resource "aws_eip" "kubernetes-eip" {
  domain = "vpc"
  #vpc      = true

  tags = {
    Name = "kubernetes-eip"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  tags = {
    Name = "kubernetes-igw"
    Owner = "${var.owner}"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.kubernetes-eip.id}"
  subnet_id = "${aws_subnet.kubernetes-public.id}"
  tags = {
    Name = "kubernetes-ngw"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}
############
## Routing
############

resource "aws_route_table" "kubernetes-public" {
    vpc_id = "${aws_vpc.kubernetes.id}"

    # Default route through Internet Gateway
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags = {
      Name = "kubernetes-public"
      Owner = "${var.owner}"
      Department = "Global Operations"
    }
}
resource "aws_route_table" "kubernetes-private" {
    vpc_id = "${aws_vpc.kubernetes.id}"

    # Default route through Internet Gateway
    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.ngw.id}"
    }

    tags = {
      Name = "kubernetes-private"
      Owner = "${var.owner}"
      Department = "Global Operations"
    }
}
resource "aws_route_table_association" "kubernetes-public" {
  subnet_id = "${aws_subnet.kubernetes-public.id}"
  #gateway_id     = "${aws_internet_gateway.gw.id}"
  route_table_id = "${aws_route_table.kubernetes-public.id}"
  
}

resource "aws_route_table_association" "kubernetes-private" {
  subnet_id = "${aws_subnet.kubernetes-private.id}"
  route_table_id = "${aws_route_table.kubernetes-private.id}"
}

############
## Security
############

resource "aws_security_group" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  name = "kubernetes"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP from control host IP
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.control_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all traffic from the API ELB
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${aws_security_group.kubernetes_api.id}"]
  }

  # Allow all traffic from control host IP
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.control_cidr}"]
  }

# Allow all traffic from control host IP
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.kubernetes_api.id}"]
  }
  tags = {
    Owner = "${var.owner}"
    Name = "kubernetes"
    Department = "Global Operations"
  }
}
