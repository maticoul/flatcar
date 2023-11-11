#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "apis-cluster" {
  name = "apis-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

tags = {
    Owner = "${var.owner}"
    Name = "eks-iam_role-${var.cluster-name}"
    Department = "Global Operations"
  }
}

resource "aws_iam_role_policy_attachment" "apis-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.apis-cluster.name
}

resource "aws_iam_role_policy_attachment" "apis-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.apis-cluster.name
}

resource "aws_security_group" "apis-cluster" {
  name        = "apis-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.kubernetes.id}"
 
  # Allow all internal
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "eks-${var.cluster-name}-sg"
    Department = "Global Operations"
  }
}

resource "aws_eks_cluster" "apis" {
  name     = var.cluster-name
  role_arn = aws_iam_role.apis-cluster.arn
  version = "1.28"
  
  vpc_config {
    security_group_ids = ["${aws_security_group.apis-cluster.id}"]
    subnet_ids         = aws_subnet.kubernetes-private.*.id
    
  }

  depends_on = [
    aws_iam_role_policy_attachment.apis-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.apis-cluster-AmazonEKSVPCResourceController,
  ]
  
  tags = {
    Owner = "${var.owner}"
    Name = "eks-cluster-${var.cluster-name}"
    Department = "Global Operations"
  }
  
}
