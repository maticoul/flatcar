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


##########
# Keypair
##########

resource "aws_key_pair" "keypair" {
  key_name = "${var.keypair_name}"
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
    filename = "${var.keypair_name}.pem"
}


############
## Subnets
############


# Subnet (public)
resource "aws_subnet" "kubernetes-public" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  cidr_block = "${var.subnet-public_cidr}"
  availability_zone = "${var.azs.0}"
  map_public_ip_on_launch = true  # This makes it a private subnet

  tags = {
    Name = "kubernetes-public"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  tags = {
    Name = "kubernetes-igw"
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

resource "aws_route_table_association" "kubernetes-public" {
  subnet_id = "${aws_subnet.kubernetes-public.id}"
  #gateway_id     = "${aws_internet_gateway.gw.id}"
  route_table_id = "${aws_route_table.kubernetes-public.id}"
  
}

############
## Security
############

resource "aws_security_group" "lunix" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  description =  "allow from and to lunix ec2 traffic"
  name = "${var.guest_name_prefix}-bastion-lunix-sg"

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-bastion-lunix-sg"
    Department = "Global Operations"
  }
}

resource "aws_security_group" "windows" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  description =  "allow RDP traffic"
  name = "${var.guest_name_prefix}-bastion-windows-sg"

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 3389
    to_port = 3389
    protocol = "TCP"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-bastion-windows-sg"
    Department = "Global Operations"
  }
}


############
## Output
############

output "vpc_info" {
  value = {
    subnet_public = "${aws_subnet.kubernetes-public.id}"
    vpc_kubernetes = "${aws_vpc.kubernetes.id}"
  }
}