#########################
# smb instances
#########################

resource "aws_instance" "smb-server" {
    ami = "${var.ami_infra}"
    instance_type = "${var.smb-instance-type}"

    subnet_id = aws_subnet.kubernetes-private[0].id
    private_ip = "${cidrhost(var.private_subnet_cidr[0], 56)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_smb
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-smb-server"
      Department = "Global Operations"
    }
  }

    availability_zone = "${var.azs[0]}"
    vpc_security_group_ids = ["${var.lunix_sg}"]
    key_name = "${var.keypair_name}"

    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user-infra}"
    private_key = file("${var.keypair_name}.pem")
    #private_key = file("~/.ssh/terraform")
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install python3.9 -y",
      "sudo apt install samba -y",
    ]

  }

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-smb-server"
      Department = "Global Operations"
    }
}

#########################
# IICS SERVER instances
#########################

resource "aws_instance" "IICS-SERVER" {
    count = 1
    ami = "${var.ami_iics}"
    instance_type = "${var.windows-instance-type}"

    subnet_id = aws_subnet.kubernetes-private[0].id
    private_ip = "${cidrhost(var.private_subnet_cidr[0], 60 )}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_iics
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-iics-server"
      Department = "Global Operations"
    }
  }

    availability_zone = "${var.azs[0]}"
    vpc_security_group_ids = ["${var.windows_sg}"]
    key_name = "${var.keypair_name}"

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-IICS-SERVER"
      Department = "Global Operations"
    }
}
