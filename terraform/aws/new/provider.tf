/* Setup our aws provider */
provider "aws" {
  region = var.aws_region
}

provider "ct" {
  version = "0.6.0"
}
