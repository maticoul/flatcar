##########################
# IAM: Policies and Roles
##########################

# The following Roles and Policy are mostly for future use

resource "aws_iam_role" "kube" {
  name = "iam-role-k8s-controller"
  assume_role_policy = <<EOF
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
EOF
   tags = {
      Owner = "${var.owner}"
      Name = "iam_role-kube-controller"
      Department = "Global Operations"
    }
}

# Role policy
resource "aws_iam_role_policy" "kube" {
  name = "iam-role-policy-kube-controller"
  role = "${aws_iam_role.kube.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action" : ["ec2:*"],
      "Effect": "Allow",
      "Resource": ["*"]
    },
    {
      "Action" : ["elasticloadbalancing:*"],
      "Effect": "Allow",
      "Resource": ["*"]
    },
    {
      "Action": "route53:*",
      "Effect": "Allow",
      "Resource": ["*"]
    },
    {
      "Action": "ecr:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
 }


# # IAM Instance Profile for Controller
resource  "aws_iam_instance_profile" "kube" {
 name = "iam-instance-profil-kube-controller"
 role = "${aws_iam_role.kube.name}" 
 tags = {
      Owner = "${var.owner}"
      Name = "aws_iam_role-k8s-controller"
      Department = "Global Operations"
    }
}



## create IAM policies and roles for the "csi-driver-iam
resource "aws_iam_policy" "csi_driver_iam_policy" {
  name        = "csi-ebs-driver-iam-policy-k8s"
  description = "IAM policy for csi-driver-iam for ebs k8s cluster"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeSnapshots",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumeAttribute",
        "ec2:DescribeVolumeStatus",
        "ec2:DetachVolume",
        "ec2:ModifyVolume",
        "ec2:ResetSnapshotAttribute",
        "ec2:ResetVolumeAttribute",
        "ec2:DescribeVolumeAttribute"
      ],
      "Resource": "*"
    }
  ]
}
EOF
 tags = {
      Owner = "${var.owner}"
      Name = "csi-ebs-driver-iam-policy-k8s"
      Department = "Global Operations"
    }
}

resource "aws_iam_role" "csi_driver_iam_role" {
  name               = "csi-ebs-driver-iam-role-k8s"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF

  tags = {
      Owner = "${var.owner}"
      Name = "csi-ebs-driver-iam-role-k8s"
      Department = "Global Operations"
    }
}

resource "aws_iam_role_policy_attachment" "csi_driver_iam_attachment" {
  policy_arn = aws_iam_policy.csi_driver_iam_policy.arn
  role       = aws_iam_role.csi_driver_iam_role.name
}