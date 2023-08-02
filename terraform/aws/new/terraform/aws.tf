# Retrieve AWS credentials from env variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
provider "aws" {
  access_key = "AKIA2FW5YNJZJ2RYRVRE"
  secret_key = "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"
  region = "${var.region}"
}
