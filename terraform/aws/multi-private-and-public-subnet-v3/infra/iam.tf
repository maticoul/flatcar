##########################
# IAM: Policies and Roles
##########################

# The following Roles and Policy are mostly for future use

resource "aws_iam_role" "kube" {
  name = "kube"
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
}

# Role policy
resource "aws_iam_role_policy" "kube" {
  name = "kube"
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


# IAM Instance Profile for Controller
resource  "aws_iam_instance_profile" "kube" {
 name = "kube"
 role = "${aws_iam_role.kube.name}" 
}


## create IAM policies and roles for the "csi-driver-iam


resource "aws_iam_policy" "csi_driver_iam_policy" {
  name        = "csi-driver-iam-policy"
  description = "IAM policy for csi-driver-iam"

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
}

resource "aws_iam_role" "csi_driver_iam_role" {
  name               = "csi-driver-iam-role"
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
}

resource "aws_iam_role_policy_attachment" "csi_driver_iam_attachment" {
  policy_arn = aws_iam_policy.csi_driver_iam_policy.arn
  role       = aws_iam_role.csi_driver_iam_role.name
}