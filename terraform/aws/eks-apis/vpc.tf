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

resource "aws_subnet" "kubernetes-private" {
 count      = 3
 vpc_id = "${aws_vpc.kubernetes.id}"
 cidr_block = var.private_subnet_cidr[count.index]
 availability_zone = var.azs[count.index]

 tags = {
   Name = "Kubernetes-Private ${count.index + 1}"
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

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.kubernetes-eip.id}"
  subnet_id = aws_subnet.kubernetes-public.id
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

resource "aws_route_table_association" "kubernetes-public" {
  subnet_id = "${aws_subnet.kubernetes-public.id}"
  #gateway_id     = "${aws_internet_gateway.gw.id}"
  route_table_id = "${aws_route_table.kubernetes-public.id}"
  
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

resource "aws_route_table_association" "kubernetes-private" {
 count = length(var.private_subnet_cidr)
 subnet_id      = element(aws_subnet.kubernetes-private[*].id, count.index)
 route_table_id = "${aws_route_table.kubernetes-private.id}"
}