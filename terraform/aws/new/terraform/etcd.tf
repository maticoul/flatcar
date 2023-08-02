#########################
# etcd cluster instances
#########################

resource "aws_instance" "etcd" {
    count = 3
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.etcd_instance_type}"

    subnet_id = "${aws_subnet.kubernetes.id}"
    private_ip = "${cidrhost(var.vpc_cidr, 10 + count.index)}"
    associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
    key_name = "${var.default_keypair_name}"

    tags = {
      Owner = "${var.owner}"
      Name = "k8s-etcd0-${count.index +1}"
      ansibleFilter = "${var.ansibleFilter}"
      ansibleNodeType = "k8s-etcd"
      ansibleNodeName = "k8s-etcd0${count.index +1}"
    }
}
