############
## Subnets
############

resource "aws_subnet" "kubernetes-private" {
 count      = 3
 vpc_id = var.vpc_kubernetes
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
  subnet_id = var.subnet_public
  tags = {
    Name = "kubernetes-ngw"
    Owner = "${var.owner}"
    Department = "Global Operations"
  }
}
############
## Routing
############

resource "aws_route_table" "kubernetes-private" {
    vpc_id = var.vpc_kubernetes

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

############
## Security
############

resource "aws_security_group" "kubernetes" {
  vpc_id = var.vpc_kubernetes
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
    Name = "${var.guest_name_prefix}-kubernetes"
    Department = "Global Operations"
  }
}
