# defining all the variables

variable "access_key" {}
variable "secret_key" {}
variable "privatekey" {}
variable "deploy_key" {}
variable "subnet_id" {}
variable "instance_type_jaeger" {}
variable "instance_type_elastic" {}
variable "sg_id" {}
variable "ami" {
  default = "ami-0c5199d385b432989"
}

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

# using EC2/aws_instance resource to bring up VM's

resource aws_instance "jaeger"{
  ami           = "${var.ami}"
  instance_type = "${var.instance_type_jaeger}"
  key_name      = "${var.deploy_key}"
  subnet_id     = "${var.subnet_id}"
  availability_zone  = "${var.az}"
  vpc_security_group_ids  = ["${var.sg_id}"]
  user_data     = "${file("scripts/bootstrap_jaeger.sh")}"
  root_block_device =  {
    volume_size = 10
   }
  tags {
    Name = "jaeger_collector-ui"
  }
  depends_on = ["aws_instance.elasticsearch"]

  provisioner "file" {
    source      = "scripts/jaeger_startup.sh"
    destination = "/home/ubuntu/jaeger_startup.sh"
    connection {
    user        = "ubuntu"
    private_key = "${var.privatekey}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "chmod +x /home/ubuntu/jaeger_startup.sh",
      "/home/ubuntu/jaeger_startup.sh ${aws_instance.elasticsearch.private_ip}",
      "sleep 20",
    ]
    connection {
    user        = "ubuntu"
    private_key = "${var.privatekey}"
    }
  }
}

resource aws_instance "elasticsearch"{
  ami           = "${var.ami}"
  instance_type = "${var.instance_type_elastic}"
  key_name      = "${var.deploy_key}"
  subnet_id     = "${var.subnet_id}"
  availability_zone  = "${var.az}"
  vpc_security_group_ids  = ["${var.sg_id}"]
  user_data     = "${file("scripts/bootstrap_elastic.sh")}"
  root_block_device =  {
   volume_size = 20
}
tags {
  Name = "jaeger_elastic"
}
}

output "Jaeger host ip" {
    value = "${aws_instance.jaeger.private_ip}"
}

output "Jaeger elastic ip" {
    value = "${aws_instance.elasticsearch.private_ip}"
}
