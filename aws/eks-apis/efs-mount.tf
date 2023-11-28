resource "aws_efs_file_system" "efs" {
  creation_token = "eks-efs-${var.cluster-name}"

 # lifecycle_policy = "AFTER_7_DAYS"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  
  tags = {
      Owner = "${var.owner}"
      Name = "eks-efs-${var.cluster-name}"
      Department = "Global Operations"
    }
}

resource "aws_efs_mount_target" "efs-apis" {
  count                  = 3  # Specify the number of mount targets based on your requirements
  file_system_id         = aws_efs_file_system.efs.id
  subnet_id              = aws_subnet.kubernetes-private.*.id  #element(data.aws_subnet_ids.example.ids, count.index)
  security_groups        = [aws_security_group.efs.id]
 # lifecycle {
 #   ignore_changes = [security_groups]
 # }  


}

# data "aws_subnet_ids" "example" {
#   vpc_id = "vpc-12345678"  # Specify your VPC ID
# }

resource "aws_security_group" "efs" {
  name        = "efs-mount-sg"
  description = "Security group for example EFS"
  vpc_id      = "${aws_vpc.kubernetes.id}"  # Specify your VPC ID
  
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Owner = "${var.owner}"
      Name = "efs-mount-target-${var.cluster-name}"
      Department = "Global Operations"
    }
}

output "efs_dns_name" {
  value = aws_efs_file_system.efs.dns_name
}

output "file_system_id" {
  value = aws_efs_mount_target.efs-apis.file_system_id
}
# Additional configuration can be added as needed, such as mount targets and security groups.
