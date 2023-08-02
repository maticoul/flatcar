#########################
## Generate certificates
#########################

# Generate Certificates
data "template_file" "certificates" {
    template = "${file("${path.module}/template/kubernetes-csr.json")}"
    depends_on = [aws_elb.kubernetes_api,aws_instance.etcd,aws_instance.controller,aws_instance.worker]
         
    vars = {
      kubernetes_api_elb_dns_name = "${aws_elb.kubernetes_api.dns_name}"
      kubernetes_cluster_dns = "${var.kubernetes_cluster_dns}"

      # Unfortunately, variables must be primitives, neither lists nor maps
      k8s-etcd0-1_ip = "${aws_instance.etcd.0.private_ip}"
      k8s-etcd0-2_ip = "${aws_instance.etcd.01.private_ip}"
      k8s-etcd0-3_ip = "${aws_instance.etcd.02.private_ip}"
      k8s-controller0-1_ip = "${aws_instance.controller.0.private_ip}"
      k8s-controller0-2_ip = "${aws_instance.controller.01.private_ip}"
      k8s-controller0-3_ip = "${aws_instance.controller.02.private_ip}"
      k8s-worker0-1_ip = "${aws_instance.worker.0.private_ip}"
      k8s-worker0-2_ip = "${aws_instance.worker.01.private_ip}"
      k8s-worker0-3_ip = "${aws_instance.worker.02.private_ip}"
      k8s-worker0-4_ip = "${aws_instance.worker.03.private_ip}"
      k8s-worker0-5_ip = "${aws_instance.worker.04.private_ip}"
      k8s-worker0-6_ip = "${aws_instance.worker.05.private_ip}"

      k8s-etcd0-1_dns = "${aws_instance.etcd.0.private_dns}"
      k8s-etcd0-2_dns = "${aws_instance.etcd.01.private_dns}"
      k8s-etcd0-3_dns = "${aws_instance.etcd.02.private_dns}"
      k8s-controller0-1_dns = "${aws_instance.controller.0.private_dns}"
      k8s-controller0-2_dns = "${aws_instance.controller.01.private_dns}"
      k8s-controller0-3_dns = "${aws_instance.controller.02.private_dns}"
      k8s-worker0-1_dns = "${aws_instance.worker.0.private_dns}"
      k8s-worker0-2_dns = "${aws_instance.worker.01.private_dns}"
      k8s-worker0-3_dns = "${aws_instance.worker.02.private_dns}"
      k8s-worker0-4_dns = "${aws_instance.worker.03.private_dns}"
      k8s-worker0-5_dns = "${aws_instance.worker.04.private_dns}"
      k8s-worker0-6_dns = "${aws_instance.worker.05.private_dns}"
    }
}
resource "null_resource" "certificates" {
  triggers = {
    template_rendered = "${ data.template_file.certificates.rendered }"
  }
  provisioner "local-exec" {
    command = "echo '${ data.template_file.certificates.rendered }' > ../cert/kubernetes-csr.json"
  }
  provisioner "local-exec" {
    command = "cd ../cert; cfssl gencert -initca ca-csr.json | cfssljson -bare ca; cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes"
  }
}
