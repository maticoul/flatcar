#########################
# nfs instances
#########################

resource "aws_instance" "nfs-server" {
    ami = "${var.aws_ami}"
    instance_type = "${var.nfs-instance-type}"

    subnet_id = "${var.aws_subnet}"
    private_ip = "${cidrhost(var.subnet-private_cidr, 55)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = "${var.security_group.bastion}"
    key_name = "${var.keypair_name}"
    
    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user}"
    private_key = file("${var.keypair_name}")
    #private_key = file("~/.ssh/terraform")
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo -S apt-get -qq install python -y",
      "sudo apt install nfs-kernel-server",
      "mkdir -p /mnt/nfs_share",
      "chown -R nobody:nogroup /mnt/nfs_share/",
      "chmod 777 /mnt/nfs_share/"
    ]
 }

  provisioner "file" {
    content     = "/mnt/nfs_share ${var.control_cidr}(rw,sync,no_subtree_check)"
    destination = "/tmp/file.log"
  }
    tags = {
      Owner = "${var.owner}"
      Name = "nfs-server"
      Department = "Global Operations"
    }
}

#########################
# smb instances
#########################

resource "aws_instance" "smb-server" {
    ami = "${var.aws_ami}"
    instance_type = "${var.smb-instance-type}"

    subnet_id = "${var.aws_subnet}"
    private_ip = "${cidrhost(var.subnet-private_cidr, 56)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    key_name = "${var.keypair_name}"
    
    provisioner "file" {
     source      = "${var.keypair_name}"      # terraform machine
     destination = "${var.keypair_name}" # remote machine
  }
    
    provisioner "local-exec" {
     command = "chmod 400 ${var.keypair_name}"
   
   }
    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user}"
    private_key = file("${var.keypair_name}")
    #private_key = file("~/.ssh/terraform")
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo -S apt-get -qq install python -y",
      "sudo apt install samba",
    ]

  }
  provisioner "file" {
    source     = "smb.conf"
    destination = "/etc/samba/smb.conf"
  }
    tags = {
      Owner = "${var.owner}"
      Name = "smb-server"
      Department = "Global Operations"
    }
}

#########################
# ha-proxy instances
#########################

resource "aws_instance" "ha-proxy" {
    count = 2
    ami = "${var.aws_ami}"
    instance_type = "${var.ha-instance-type}"

    subnet_id = "${var.aws_subnet}"
    private_ip = "${cidrhost(var.subnet-private_cidr, 57 + count.index)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = "${var.security_group.bastion}"
    key_name = "${var.keypair_name}"
    

    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user}"
    private_key = file("${var.keypair_name}")
    #private_key = file("~/.ssh/terraform")
    host        = self.private_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo -S apt-get -qq install python -y",
      "sudo apt-get install -y haproxy",
    ]

  }

    tags = {
      Owner = "${var.owner}"
      Name = "haproxy-0${count.index +1}"
      Department = "Global Operations"
    }
}


#########################
# IICS SERVER instances
#########################

resource "aws_instance" "IICS-SERVER" {
    count = 1
    ami = "${var.aws_ami}"
    instance_type = "${var.windows-instance-type}"

    subnet_id = "${var.aws_subnet}"
    private_ip = "${cidrhost(var.subnet-private_cidr, 60 )}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    key_name = "${var.keypair_name}"
  
    tags = {
      Owner = "${var.owner}"
      Name = "IICS-SERVER"
      Department = "Global Operations"
    }
}