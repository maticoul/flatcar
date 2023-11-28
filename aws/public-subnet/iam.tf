##########################
# IAM: Policies and Roles
##########################

## create IAM policies and roles for the "csi-driver-iam

resource "aws_iam_policy" "csi_driver_iam_policy" {
  name        = "csi-driver-iam-policy-k8s"
  description = "IAM policy for csi-driver-iam k8s cluster"

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
      Name = "csi-driver-iam-policy-k8s"
      Department = "Global Operations"
    }
}

resource "aws_iam_role" "csi_driver_iam_role" {
  name               = "csi-driver-iam-role-k8s"
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
      Name = "csi-driver-iam-role-k8s"
      Department = "Global Operations"
    }
}

resource "aws_iam_role_policy_attachment" "csi_driver_iam_attachment" {
  policy_arn = aws_iam_policy.csi_driver_iam_policy.arn
  role       = aws_iam_role.csi_driver_iam_role.name
}