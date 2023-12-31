#########################
# etcd cluster instances
#########################

resource "aws_instance" "etcd" {
    count = 3
    #ami = var.amis
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.etcd_instance_type}"

    subnet_id = "${aws_subnet.kubernetes-private.id}"
    private_ip = "${cidrhost(var.subnet-private_cidr, 10 + count.index)}"
    associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
    key_name = "${var.keypair_name}"
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_etcd
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-etcd0-${count.index +1}"
      Department = "Global Operations"
    }
  }

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-etcd0-${count.index +1}"
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
