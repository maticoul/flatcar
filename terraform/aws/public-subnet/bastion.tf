#########################
# Bastion instances
#########################

resource "aws_instance" "bastion" {
    ami = "ami-03f65b8614a860c29"
    instance_type = "t2.micro"

    subnet_id = "${aws_subnet.kubernetes.id}"
    private_ip = "${cidrhost(var.subnet_cidr, 200 )}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    key_name = "${var.keypair_name}"
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_Bastion
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "Bastion-lunix"
      Department = "Global Operations"
    }
  }
    provisioner "local-exec" {
     command = "chmod 400 ${var.keypair_name}"

   }
    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user-bastion}"
    private_key = file("${var.keypair_name}")
    #private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get update",
      "sudo apt install ansible -y ",
      "sudo apt install unzip",
    
    ]

  }

    tags = {
      Owner = "${var.owner}"
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
    Owner = "${var.owner}"
    Name = "bastion-sg"
    Department = "Global Operations"
  }
}


