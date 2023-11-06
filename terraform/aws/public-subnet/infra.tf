#########################
# nfs instances
#########################

resource "aws_instance" "nfs-server" {
    ami = "${var.ami_infra}"
    instance_type = "${var.nfs-instance-type}"

    subnet_id = "${aws_subnet.kubernetes.id}"
    private_ip = "${cidrhost(var.subnet_cidr, 55)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_nfs
    delete_on_termination = true
  }

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.infra.id}"]
    key_name = "${var.keypair_name}"

    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user-bastion}"
    private_key = file("${var.keypair_name}.pem")
    #private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install python3.9 -y",
      "sudo apt install nfs-kernel-server -y",
      "sudo mkdir -p /mnt/nfs_share",
      "sudo chown -R nobody:nogroup /mnt/nfs_share/",
      "sudo chmod 777 /mnt/nfs_share/"
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
    ami = "${var.ami_infra}"
    instance_type = "${var.smb-instance-type}"

    subnet_id = "${aws_subnet.kubernetes.id}"
    private_ip = "${cidrhost(var.subnet_cidr, 56)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_smb
    delete_on_termination = true
  }

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.infra.id}"]
    key_name = "${var.keypair_name}"

    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user-bastion}"
    private_key = file("${var.keypair_name}.pem")
    #private_key = file("~/.ssh/terraform")
    host        = self.public_ip
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
      Name = "smb-server"
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

    subnet_id = "${aws_subnet.kubernetes.id}"
    private_ip = "${cidrhost(var.subnet_cidr, 60)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_iics
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "iics-server"
      Department = "Global Operations"
    }
  }

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.infra.id}"]
    key_name = "${var.keypair_name}"

    tags = {
      Owner = "${var.owner}"
      Name = "IICS-SERVER"
      Department = "Global Operations"
    }
}

############
## Security
############

resource "aws_security_group" "infra" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  name = "infra-sg"

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all traffic from control host IP
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
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
    Name = "infra-sg"
    Department = "Global Operations"
  }
}