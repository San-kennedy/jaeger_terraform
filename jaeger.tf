variable "access_key" {}
variable "secret_key" {}
variable "privatekey" {}
variable "deploy_key" {}
variable "subnet_id" {}
variable "region" {
  default = "ap-southeast-1"
}
variable "az" {
  default = "ap-southeast-1b"
}

provider "aws" {

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"

}


resource aws_intance "jaeger"{
  ami           = ""
  instance_type = "t2.micro"
  key_name      = "${var.deploy_key}"
  subnet_id     = "${var.subnet_id}"

}

resource aws_intance "elasticsearch"{

}
