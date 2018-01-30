variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-1"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

terraform {
  backend "s3" {
    bucket = "terraform-states"
    key    = "haproxy-test/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "haproxy" {
  key_name   = "haproxy-key"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "haproxy" {
  ami           = "${data.aws_ami.ubuntu.id}"
  key_name      = "${aws_key_pair.haproxy.key_name}"
  instance_type = "t2.micro"

  tags {
    Name = "HAProxy"
  }
}
