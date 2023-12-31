###################
# Bastion instances
###################

resource "aws_instance" "bastion-lunix" {
    ami = var.ami-bastion-lunix
    instance_type = var.instance_type-bastion-lunix

    subnet_id = "${aws_subnet.kubernetes-public.id}"
    private_ip = "${cidrhost(var.subnet-public_cidr, 55 )}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    key_name = "${var.keypair_name}"
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_bastion-lunix
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "bastion lunix"
      Department = "Global Operations"
    }
  }
    
    provisioner "local-exec" { 
      command = <<EOF
      chmod 400 ${var.keypair_name}.pem
      terraform output vpc_info  >> infra/terraform.tfvars
      sed -i 's/"vpc_kubernetes"/vpc_kubernetes/g' infra/terraform.tfvars
      sed -i 's/"subnet_public"/subnet_public/g' infra/terraform.tfvars
      sed -i 's/{/ /g' infra/terraform.tfvars
      sed -i 's/}/ /g' infra/terraform.tfvars
    EOF
    }

    provisioner "file" {
    source      = "infra"
    destination = "/home/ubuntu/"
  }

    provisioner "file" {
    source      = "ansible"
    destination = "/home/ubuntu/infra/"
  }

    provisioner "file" {
     source      = "${var.keypair_name}.pem"  # terraform machine
     destination = "infra/${var.keypair_name}.pem"  # remote machine
  }

    connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user-bastion}"
    private_key = file("${var.keypair_name}.pem")
    #private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get update",
      "sudo apt install ansible -y ",
      "sudo apt install unzip",
      "wget https://releases.hashicorp.com/terraform/1.6.1/terraform_1.6.1_linux_amd64.zip",
      "unzip terraform_1.6.1_linux_amd64.zip",
      "sudo mv terraform /usr/bin/",
      "sudo mv infra/ansible/hosts /etc/hosts",
      "sudo chmod 400 infra/${var.keypair_name}.pem",
      "sudo apt install dos2unix",
      "dos2unix /home/ubuntu/infra/deploy.sh"
      
    ]

  }

    tags = {
      Owner = "${var.owner}"
      Name = "Bastion-lunix"
      Department = "Global Operations"
    }
}

###########################
# Bastion Windows instances
###########################

resource "aws_instance" "bastion-Windows" {
    ami = var.ami-bastion-windows
    instance_type = var.instance_type-bastion-windows

    subnet_id = "${aws_subnet.kubernetes-public.id}"
    private_ip = "${cidrhost(var.subnet-public_cidr, 56 )}"
    #associate_public_ip_address = false # Instances have public, dynamic IP

    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_bastion-windows
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "bastion windows"
      Department = "Global Operations"
    }
  }

    availability_zone = "${var.zone}"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    key_name = "${var.keypair_name}"
    
    tags = {
      Owner = "${var.owner}"
      Name = "Bastion-windows"
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