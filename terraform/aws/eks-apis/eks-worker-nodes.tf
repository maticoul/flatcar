#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "apis-node" {
  name = "apis-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

tags = {
    Owner = "${var.owner}"
    Name = "eks-iam_role-${var.cluster-name}-node"
    Department = "Global Operations"
  }
  
}

resource "aws_iam_role_policy_attachment" "apis-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.apis-node.name
}

resource "aws_iam_role_policy_attachment" "apis-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.apis-node.name
}

resource "aws_iam_role_policy_attachment" "apis-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.apis-node.name
}

resource "aws_eks_node_group" "apis" {
  #ami_type = var.amis
  cluster_name    = aws_eks_cluster.apis.name
  node_group_name = "apis"
  node_role_arn   = aws_iam_role.apis-node.arn
  subnet_ids      = aws_subnet.kubernetes-private.*.id
  #disk_size       = 30
  instance_types   = ["t2.medium"]
  
  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.apis-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.apis-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.apis-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  
  launch_template {
    id = aws_launch_template.eks-apis.id
    version = "$Latest"
  #  name = "eks-launch-template"
  }

  tags_all = {
    Owner = "${var.owner}"
    Name = "eks-${var.cluster-name}-node-group"
    Department = "Global Operations"
  }

  # remote_access {
  #   ec2_ssh_key = "${var.keypair_name}"  # SSH key pair name for remote access
  #   source_security_group_ids = ["0.0.0.0/0"]

  # }
}

resource "aws_launch_template" "eks-apis" {
  name = "eks-apis"
  description    = "First version"
  # name_prefix   = "eks-apis"
  # instance_type = "t2.medium"
  # image_id      = var.amis
  key_name = "${var.keypair_name}"
  vpc_security_group_ids = [aws_security_group.apis-cluster.id]
  
  block_device_mappings {
      device_name = "/dev/xvda"  # Device name may vary, depending on the AMI
      ebs {
        volume_size = 30  # Specify the desired disk size (in GB)
        volume_type = "gp2"  # Specify the volume type (e.g., gp2 for General Purpose SSD)
      }
    }

  tags = {
    Owner = "${var.owner}"
    Department = "Global Operations"
    Name = "eks-launch-template-${var.cluster-name}"
  }
}

resource "aws_eks_addon" "efs-csi-driver" {
  cluster_name                = aws_eks_cluster.apis.name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = "v1.5.8-eksbuild.1" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = aws_eks_cluster.apis.name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.28.1-eksbuild.1" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name                = aws_eks_cluster.apis.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.14.1-eksbuild.1" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "ebs-csi-driver" {
  cluster_name                = aws_eks_cluster.apis.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.22.0-eksbuild.2" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.apis.name
  addon_name                  = "coredns"
  addon_version               = "v1.9.3-eksbuild.7" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"
}