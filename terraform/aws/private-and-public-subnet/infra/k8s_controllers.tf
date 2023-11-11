############################
# K8s Control Pane instances
############################

resource "aws_instance" "controller" {
    count = 3
    ami = var.amis
    #ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.controller_instance_type}"

#    iam_instance_profile = "${aws_iam_instance_profile.kubernetes.id}"

    subnet_id = "${aws_subnet.kubernetes-private.id}"
    private_ip = "${cidrhost(var.subnet-private_cidr, 50 + count.index)}"
    associate_public_ip_address = false # Instances have public, dynamic IP
    source_dest_check = false # TODO Required??

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
    key_name = "${var.keypair_name}"
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_master
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-master0-${count.index +1}"
      Department = "Global Operations"
    }
  }

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-master0-${count.index +1}"
      Department = "Global Operations"
    }

  connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user}"
    private_key = file("${var.keypair_name}.pem")
    #private_key = file("~/.ssh/terraform")
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
      "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
    ]

  }

}

###############################
## Kubernetes API Load Balancer
###############################

resource "aws_elb" "kubernetes_api" {
    name = "${var.elb_name}"
    internal           = true  # Set to true for internal ELB, false for internet-facing ELB
    instances = "${aws_instance.controller.*.id}"
    subnets = ["${aws_subnet.kubernetes-private.id}"]
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
      Name = "kubernetes"
      Owner = "${var.owner}"
      Department = "Global Operations"
    }
}

############
## Security
############

resource "aws_security_group" "kubernetes_api" {
  vpc_id = var.vpc_kubernetes
  name = "kubernetes-api"

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "TCP"
    cidr_blocks = ["${var.control_cidr}"]
  }
  
  # Allow ICMP from control host IP
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["${var.control_cidr}"]
  }
  
  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "kubernetes-api"
    Department = "Global Operations"
  }
}

############
## Outputs
############

output "kubernetes_api_dns_name" {
  value = "${aws_elb.kubernetes_api.dns_name}"
}
