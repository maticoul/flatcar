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
  description = "allow traffic from to node"
  name = "${var.guest_name_prefix}-sg-node"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all internal
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-sg-node"
    Department = "Global Operations"
  }
}


resource "aws_security_group" "kubernetes_api" {
  vpc_id = var.vpc_kubernetes
  name = "${var.guest_name_prefix}-kubernetes-api-sg"

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "TCP"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow ICMP from control host IP
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-kubernetes-api"
    Department = "Global Operations"
  }
}

###############################
## Kubernetes API Load Balancer
###############################

resource "aws_elb" "kubernetes_api" {
    name = "${var.elb_name}"
    instances = "${aws_instance.controller.*.id}"
    internal           = true  # Set to true for internal ELB, false for internet-facing ELB
    subnets =  "${aws_subnet.kubernetes-private.*.id}"  # Specify the desired subnets directly

    cross_zone_load_balancing = true

    security_groups = ["${aws_security_group.kubernetes_api.id}"]

    listener {
      lb_port = 6443
      instance_port = 6443
      lb_protocol = "TCP"
      instance_protocol = "TCP"
    }

    health_check {
      healthy_threshold = 10
      unhealthy_threshold = 2
      timeout = 2
      target = "TCP:6443"
      interval = 5
    }

    tags = {
      Name = "${var.guest_name_prefix}-kubernetes"
      Owner = "${var.owner}"
      Department = "Global Operations"
    }
   # scheme = "internet-facing" # or "internal" depending on your needs

}

############
## Outputs
############

output "controlPlane" {
  value = {
     controlPlaneEndpoint = "${aws_elb.kubernetes_api.dns_name}"
     subnet = "${var.vpc_cidr}"
  }
}

