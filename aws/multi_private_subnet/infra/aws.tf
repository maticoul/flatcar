# Retrieve AWS credentials from env variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
provider "aws" {
  shared_credentials_files = ["/Users/tf_user/.aws/creds"]
  # access_key = ""
  # secret_key = ""
  region = "${var.region}"
}
