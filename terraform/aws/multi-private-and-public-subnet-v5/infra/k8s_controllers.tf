############################
# K8s Control Pane instances
############################

resource "aws_instance" "controller" {
    count = 3
    ami = var.amis
    #ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.controller_instance_type}"

    iam_instance_profile = "${aws_iam_instance_profile.kube.id}"

    subnet_id = element(aws_subnet.kubernetes-private[*].id, count.index)   # "${aws_subnet.kubernetes-private[count.index].id}"
    private_ip = "${cidrhost(var.private_subnet_cidr[count.index], 50 + count.index)}"
    associate_public_ip_address = false # Instances have public, dynamic IP
    source_dest_check = false # TODO Required??
    
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

    availability_zone = "${var.azs[count.index]}"
    vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
    key_name = "${var.keypair_name}"

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-master0-${count.index +1}"
      Department = "Global Operations"
    }

   provisioner "local-exec" { 
      command = <<EOF
      terraform output controlPlane  >> controlPlane.yml
      sed -i 's/"controlPlaneEndpoint"/controlPlaneEndpoint/g' controlPlane.yml
      sed -i 's/"subnet"/subnet/g' controlPlane.ymll
      sed -i 's/{/ /g' controlPlane.yml
      sed -i 's/}/ /g' controlPlane.yml
      cat controlPlane.yml >> ansible/0-inventory.yml
    EOF
    }

   connection {
     type        = "ssh"
     user        = "${var.guest_ssh_user}"
     private_key = file("${var.keypair_name}.pem")
    # private_key = file("~/.ssh/terraform")
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
