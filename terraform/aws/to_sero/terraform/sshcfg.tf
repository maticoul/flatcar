####################
## Generate ssh.cfg
####################

# Generate ../ssh.cfg
data "template_file" "ssh_cfg" {
    template = "${file("${path.module}/template/ssh.cfg")}"
    depends_on = [aws_instance.etcd,aws_instance.controller,aws_instance.worker]
    vars = {
      user = "${var.default_instance_user}"

      preprod-etcd0-1_ip = "${aws_instance.etcd.0.private_ip}"
      preprod-etcd0-2_ip = "${aws_instance.etcd.01.private_ip}"
      preprod-etcd0-3_ip = "${aws_instance.etcd.02.private_ip}"
      preprod-controller0-1_ip = "${aws_instance.controller.0.private_ip}"
      preprod-controller0-2_ip = "${aws_instance.controller.01.private_ip}"
      preprod-controller0-3_ip = "${aws_instance.controller.02.private_ip}"
      preprod-worker0-1_ip = "${aws_instance.worker.0.private_ip}"
      preprod-worker0-2_ip = "${aws_instance.worker.01.private_ip}"
      preprod-worker0-3_ip = "${aws_instance.worker.02.private_ip}"
      preprod-worker0-4_ip = "${aws_instance.worker.03.private_ip}"
      preprod-worker0-5_ip = "${aws_instance.worker.04.private_ip}"
      preprod-worker0-6_ip = "${aws_instance.worker.05.private_ip}"
    }
}
resource "null_resource" "ssh_cfg" {
  triggers = {
    template_rendered = "${ data.template_file.ssh_cfg.rendered }"
  }
  provisioner "local-exec" {
    command = "echo '${ data.template_file.ssh_cfg.rendered }' > ../ssh.cfg"
  }
}
