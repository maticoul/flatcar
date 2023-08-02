
############################################
# K8s Worker (aka Nodes, Minions) Instances
############################################

resource "aws_instance" "worker" {
    count = 6
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.worker_instance_type}"

    subnet_id = "${aws_subnet.kubernetes.id}"
    private_ip = "${cidrhost(var.vpc_cidr, 100 + count.index)}"
    associate_public_ip_address = false # Instances have public, dynamic IP
    source_dest_check = false # TODO Required??

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
    key_name = "${var.default_keypair_name}"

    tags = {
      Owner = "${var.owner}"
      Name = "preprod-worker0-${count.index +1}"
      ansibleFilter = "${var.ansibleFilter}"
      ansibleNodeType = "preprod-worker"
      ansibleNodeName = "preprod-worker0${count.index +1}"
    }
}

output "kubernetes_workers_private_ip" {
  value = "${join(",", aws_instance.worker.*.private_ip)}"
}
