# defining all the variables

variable "access_key" {}
variable "secret_key" {}
variable "privatekey" {}
variable "deploy_key" {}
variable "subnet_id" {}
variable "instance_type_jaeger" {}
variable "instance_type_elastic" {}

variable "region" {
  default = "ap-southeast-1"
}
variable "az" {
  default = "ap-southeast-1b"
}

#defining aws as the provider

provider "aws" {

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"

}

# using EC2/aws_intance resource to bring up VM's

resource aws_intance "jaeger"{
  ami           = ""
  instance_type = "${var.instance_type_jaeger}"
  key_name      = "${var.deploy_key}"
  subnet_id     = "${var.subnet_id}"
  user_data     = "${file("scripts/bootstrap_jaeger.sh")}"
}

resource aws_intance "elasticsearch"{
  ami           = ""
  instance_type = "${var.instance_type_elastic}"
  key_name      = "${var.deploy_key}"
  subnet_id     = "${var.subnet_id}"
  user_data     = "${file("scripts/bootstrap_elastic.sh")}"
}
