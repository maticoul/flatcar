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

resource "aws_security_group" "kubernetes-etcd" {
  vpc_id = var.vpc_kubernetes
  description = "allow traffic from to node"
  name = "${var.guest_name_prefix}-sg-etcd-node"

  # Allow all internal
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  # Allow all internal
  ingress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all outbound
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-sg-etcd-node"
    Department = "Global Operations"
  }
}


resource "aws_security_group" "kubernetes-master" {
  vpc_id = var.vpc_kubernetes
  description = "allow traffic from to node"
  name = "${var.guest_name_prefix}-sg-masters-node"

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  ingress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 10257
    to_port = 10257
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 10259
    to_port = 10259
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  # Allow all internal
  ingress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all outbound
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all internal
  egress {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-sg-masters-node"
    Department = "Global Operations"
  }
}


resource "aws_security_group" "kubernetes-workers" {
  vpc_id = var.vpc_kubernetes
  description = "allow traffic from to node"
  name = "${var.guest_name_prefix}-sg-workers-node"
  
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  # Allow all internal
  ingress {
    from_port = 30000
    to_port = 32767
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all outbound
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-sg-workers-node"
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
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
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
    Name = "${var.guest_name_prefix}-kubernetes-api"
    Department = "Global Operations"
  }
}

resource "aws_security_group" "smb" {
  vpc_id = var.vpc_kubernetes
  description =  "allow from and to lunix ec2 traffic"
  name = "${var.guest_name_prefix}-smb-sg"
 
  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 139
    to_port     = 139
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow ICMP from control host IP
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["${var.vpc_cidr}"]
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
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-smb-sg"
    Department = "Global Operations"
  }
}

resource "aws_security_group" "iics" {
  vpc_id = var.vpc_kubernetes
  description =  "allow RDP traffic"
  name = "${var.guest_name_prefix}-iics-sg"

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
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "${var.guest_name_prefix}-iics-sg"
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

