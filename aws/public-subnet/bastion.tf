#########################
# Bastion instances
#########################

resource "aws_instance" "bastion" {
    ami = "${lookup(var.amis_ubuntu, var.aws_region)}"
    instance_type = "t2.micro"

    subnet_id = "${aws_subnet.kubernetes[0].id}"
    private_ip = "${cidrhost(var.aws_public_subnet_cidr[0], 200 )}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.aws_azs[0]}"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    key_name = "${var.aws_keypair_name}"
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.smb_instance_disk
    delete_on_termination = true

    tags = {
      Owner = "${var.aws_owner}"
      Name = "Bastion-lunix"
      Department = "Global Operations"
    }

  }

    provisioner "file" {
    source      = "ansible"
    destination = "/home/ubuntu/"
  }

   provisioner "file" {
     source      = "${var.aws_keypair_name}.pem"  # terraform machine
     destination = "${var.aws_keypair_name}.pem"  # remote machine
  }

    connection {
    type        = "ssh"
    user        = "${var.smb_instance_ssh_user}"
    private_key = file("${var.aws_keypair_name}.pem")
    #private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get update",
      "sudo apt install ansible -y ",
      "sudo apt install unzip",
      "sudo mv /ansible/template/hosts /etc/hosts",
      "sudo chmod 400 ${var.aws_keypair_name}.pem",
      "sudo apt install dos2unix",
      "dos2unix /home/ubuntu/ansible/deploy.sh",
     # "sh /home/ubuntu/deploy.sh"
   #   "sudo chmod 400 ${var.keypair_name}.pem",
    
    ]

  }

    tags = {
      Owner = "${var.aws_owner}"
      Name = "Bastion"
      Department = "Global Operations"
    }
}


############
## Security
############

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  name = "bastion-sg"

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "${var.aws_owner}"
    Name = "bastion-sg"
    Department = "Global Operations"
  }
}


