# Retrieve AWS credentials from env variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
provider "aws" {
  shared_credentials_files = ["/home/securiport/.aws/credentials"]
  # access_key = ""
  # secret_key = ""
  region = "${var.region}"
}
