# Retrieve AWS credentials from env variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
provider "aws" {
  shared_credentials_files = ["C:\terraform_1.6.6_windows_amd64\redentials"]
  region = "${var.aws_region}"
}