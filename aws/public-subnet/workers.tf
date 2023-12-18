
############################################
# K8s Worker (aka Nodes, Minions) Instances
############################################

resource "aws_instance" "worker" {
    count = var.worker_instance_num
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.worker_instance_type}"

    subnet_id = element(aws_subnet.kubernetes[*].id, count.index % 3)
    private_ip = "${cidrhost(var.aws_public_subnet_cidr[count.index % 3], 100 + count.index)}"
    #associate_public_ip_address = false # Instances have public, dynamic IP
    source_dest_check = false # TODO Required??

    availability_zone = "${var.aws_azs[count.index % 3]}"
    vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]
    key_name = "${var.aws_keypair_name}"
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.worker_instance_disk
    delete_on_termination = true

    tags = {
      Owner = "${var.aws_owner}"
      Name = "preprod-worker0-${count.index +1}"
      Department = "Global Operations"
    }
  }

    tags = {
      Owner = "${var.aws_owner}"
      Name = "preprod-worker0-${count.index +1}"
      Department = "Global Operations"
      
    }

    connection {
     type        = "ssh"
     user        = "${var.kube_ssh_user}"
     private_key = file("${var.aws_keypair_name}.pem")
  #   #private_key = file("~/.ssh/terraform")
     host        = self.public_ip
   }

   provisioner "remote-exec" {
     inline = [
       "wget https://downloads.python.org/pypy/pypy3.7-v7.3.3-linux64.tar.bz2",
       "sudo tar xf pypy3.7-v7.3.3-linux64.tar.bz2",
       "sudo mv pypy3.7-v7.3.3-linux64 /opt/bin/python"
     ]

   }

}

output "kubernetes_workers_private_ip" {
  value = "${join(",", aws_instance.worker.*.private_ip)}"
}
