#########################
# smb instances
#########################

resource "aws_instance" "smb-server" {
    #ami = "${var.amis-ubuntu}"
    ami = "${lookup(var.amis-ubuntu, var.region)}"
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
    vpc_security_group_ids = ["${aws_security_group.smb.id}"]
    key_name = "${var.keypair_name}"
    
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
    ami = "${lookup(var.amis-windows, var.region)}"
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
    vpc_security_group_ids = ["${aws_security_group.iics.id}"]
    key_name = "${var.keypair_name}"

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-IICS-SERVER"
      Department = "Global Operations"
    }
}
