#########################
# smb instances
#########################

resource "aws_instance" "smb-server" {
    ami = "${lookup(var.amis_ubuntu, var.aws_region)}"
    instance_type = "${var.smb_instance_type}"

    subnet_id = "${aws_subnet.kubernetes[0].id}"
    private_ip = "${cidrhost(var.aws_public_subnet_cidr[0], 56)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.smb_instance_disk
    delete_on_termination = true
  }

    availability_zone = "${var.aws_azs[0]}"
    vpc_security_group_ids = ["${aws_security_group.infra.id}"]
    key_name = "${var.aws_keypair_name}"

    connection {
    type        = "ssh"
    user        = "${var.smb_instance_ssh_user}"
    private_key = file("${var.aws_keypair_name}.pem")
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
      Owner = "${var.aws_owner}"
      Name = "smb-server"
      Department = "Global Operations"
    }
}

#########################
# IICS SERVER instances
#########################

resource "aws_instance" "iics-server" {
    #count = 1
    ami = "${lookup(var.amis_windows, var.aws_region)}"
    instance_type = "${var.windows_instance_type}"

    subnet_id = "${aws_subnet.kubernetes[0].id}"
    private_ip = "${cidrhost(var.aws_public_subnet_cidr[0], 60)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.windows_instance_disk
    delete_on_termination = true

    tags = {
      Owner = "${var.aws_owner}"
      Name = "iics-server"
      Department = "Global Operations"
    }
  }

    availability_zone = "${var.aws_azs[0]}"
    vpc_security_group_ids = ["${aws_security_group.infra.id}"]
    key_name = "${var.aws_keypair_name}"

    tags = {
      Owner = "${var.aws_owner}"
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
    cidr_blocks = ["${var.aws_vpc_cidr}"]
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
    Name = "infra-sg"
    Department = "Global Operations"
  }
}


resource "aws_security_group" "windows" {
  vpc_id = "${aws_vpc.kubernetes.id}"
  description =  "allow RDP traffic"
  name = "windows-sg"

  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all traffic from control host IP
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.aws_vpc_cidr}"]
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
    Name = "windows-sg"
    Department = "Global Operations"
  }
}