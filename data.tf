#data block to fetch latest ami of linux/ubuntu os in primary region
data "aws_ami" "linux_Server_pr" {
  owners             = ["amazon"]
  most_recent        = true
  include_deprecated = false

  filter {
    name   = "name"
    values = ["ubuntu-pro-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}