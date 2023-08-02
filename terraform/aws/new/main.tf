locals {
  kube_cluster_tag = "kubernetes.io/cluster/${var.cluster_name}"
  worker_os        = var.worker_os == "" ? var.os : var.worker_os
  ami              = var.ami == "" ? data.aws_ami.ami.id : var.ami
}

################################# DATA SOURCES #################################
data "aws_ami" "ami" {
  most_recent = true
  owners      = var.ami_filters[var.os].owners

  filter {
    name   = "name"
    values = var.ami_filters[var.os].image_name
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "template_file" "clc" {
  count = 7
  template = file("clc/server.tpl")
  vars = {
    instance_hostname = lookup(var.instance_hostnames, count.index)
  }
}

data "ct_config" "node" {
  count        = 7
  content      = element(data.template_file.clc.*.rendered, count.index)
  strict       = true
  pretty_print = false
  platform     = "ec2"
}

################################### FIREWALL ###################################

resource "aws_security_group" "common" {
  name        = "${var.cluster_name}-common"
  description = "cluster common rules"
  vpc_id      = var.vpc_id

  tags = map(
    "Cluster", var.cluster_name,
    local.kube_cluster_tag, "shared",
  )
}

resource "aws_security_group_rule" "ingress_self_allow_all" {
  type              = "ingress"
  security_group_id = aws_security_group.common.id

  description = "allow all incomming traffic from members of this group"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  self        = true
}

resource "aws_security_group_rule" "egress_allow_all" {
  type              = "egress"
  security_group_id = aws_security_group.common.id

  description = "allow all outgoing traffic"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nodeports" {
  count             = var.open_nodeports ? 1 : 0
  type              = "ingress"
  security_group_id = aws_security_group.common.id

  description = "open nodeports"
  from_port   = 30000
  to_port     = 32767
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  security_group_id = aws_security_group.common.id

  description = "open http"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  security_group_id = aws_security_group.common.id

  description = "open https"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "elb" {
  name        = "${var.cluster_name}-api-lb"
  description = "kube-api firewall"
  vpc_id      = var.vpc_id

  egress {
    description = "allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow anyone to connect to tcp/6443"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map(
    "Cluster", var.cluster_name,
  )
}

resource "aws_security_group" "ssh" {
  name        = "${var.cluster_name}-ssh"
  description = "ssh access"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow incomming SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map(
    "Cluster", var.cluster_name,
  )
}


################################## KUBE-API LB #################################

resource "aws_elb" "control_plane" {
  name                  = "${var.cluster_name}-api-lb"
  internal                      = var.internal_api_lb
  subnets                       = [var.subnet_id]
  security_groups               = [aws_security_group.elb.id, aws_security_group.common.id]
  instances                     = aws_instance.control_plane.*.id
  idle_timeout                  = 600

  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:6443/healthz"
    interval            = 30
  }
  tags = {
    Name = "TestK8s Cluster LB"
    "local.kube_cluster_tag" = "shared"
  }
}

#################################### SSH KEY ###################################
resource "aws_key_pair" "deployer" {
  key_name   = "${var.cluster_name}-deployer-key"
  public_key = file(var.ssh_public_key_file)
}

############################ CONTROL PLANE INSTANCES ###########################

resource "aws_instance" "control_plane" {
  count                 = 3
  ami                   = local.ami
  instance_type         = var.instance_type
  subnet_id             = var.subnet_id
  availability_zone     = var.az
  key_name              = aws_key_pair.deployer.key_name
  iam_instance_profile  = var.iam_profile
  private_ip            = lookup(var.instance_ips, count.index)
  user_data             = element(data.ct_config.node.*.rendered, count.index)
  source_dest_check     = false
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.ssh.id]
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
}

  tags = {
    Name = "Arg-Preprod Cluster CP ${count.index + 1}"
    "East-1-Schedule" = "DevSchedule"
    "kubernetes.io/cluster/Arg-Preprod" = "shared"
    "Container_Orchestrator" = "Kubernetes"
    "Department" = "Product Services"
    "environment" = "Test"
  }
  volume_tags = {
    Name = "Arg-Preprod Cluster CP ${count.index + 1}"
    "Container_Orchestrator" = "Kubernetes"
    "Department" = "Product Services"
    "environment" = "Test"
  }
}

####################### WORKER INSTANCES ####################################

resource "aws_instance" "worker" {
  count                 = 4
  ami                   = local.ami
  instance_type         = var.instance_type
  subnet_id             = var.subnet_id
  availability_zone     = var.az
  key_name              = aws_key_pair.deployer.key_name
  iam_instance_profile  = var.iam_profile
  private_ip            = lookup(var.instance_ips, count.index + 3)
  user_data             = element(data.ct_config.node.*.rendered, count.index +3)
  source_dest_check     = false
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.ssh.id]
  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }

  tags = {
    Name = "Arg-Preprod Cluster Worker ${count.index + 1}"
    "East-1-Schedule" = "DevSchedule"
    "kubernetes.io/cluster/Arg-Preprod" = "shared"
    "Container_Orchestrator" = "Kubernetes"
    "Department" = "Product Services"
    "environment" = "Test"
  }
  volume_tags = {
    Name = "Arg-Preprod Cluster Worker ${count.index + 1}"
    "Container_Orchestrator" = "Kubernetes"
    "Department" = "Product Services"
    "environment" = "Test"
  }
}