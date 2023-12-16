
############################################
# K8s Worker (aka Nodes, Minions) Instances
############################################

resource "aws_instance" "worker" {
    count = 6
    #ami = var.amis
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.worker_instance_type}"

    subnet_id = element(aws_subnet.kubernetes-private[*].id, count.index % 3)   #"${aws_subnet.kubernetes-private[count.index].id}"
    private_ip = "${cidrhost(var.private_subnet_cidr[count.index % 3], 100 + count.index)}"
    associate_public_ip_address = false # Instances have public, dynamic IP
    source_dest_check = false # TODO Required??
    
    root_block_device {
    volume_type           = "gp2"
    volume_size           = var.disk_worker
    delete_on_termination = true

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-worker0-${count.index +1}"
      Department = "Global Operations"
    }
  }

    availability_zone = "${var.azs[count.index % 3]}"
    vpc_security_group_ids = ["${aws_security_group.kubernetes-workers.id}"]
    key_name = "${var.keypair_name}"

    tags = {
      Owner = "${var.owner}"
      Name = "${var.guest_name_prefix}-worker0-${count.index +1}"
      Department = "Global Operations"
     }

  provisioner "local-exec" {
    command = "sleep 180"  # Adjust the sleep duration as needed
  }
  
  depends_on = [aws_route_table_association.kubernetes-private]

  connection {
    type        = "ssh"
    user        = "${var.guest_ssh_user}"
    private_key = file("${var.keypair_name}.pem")
    #private_key = file("~/.ssh/terraform")
    host        = self.private_ip
    timeout     = "360s"
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.python.org/pypy/pypy3.10-v7.3.13-linux64.tar.bz2",
      "sudo tar xf pypy3.10-v7.3.13-linux64.tar.bz2",
      "sudo mv pypy3.10-v7.3.13-linux64 /opt/bin/python"
    ]

  } 

}

output "kubernetes_workers_private_ip" {
  value = "${join(",", aws_instance.worker.*.private_ip)}"
}
