provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "consul" {
  instance_type               = "${var.instance_type}"
  ami                         = "${var.ami}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "true"
  security_groups             = ["allow_ssh_and_consule"]

  provisioner "remote-exec" {
    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.user}"
      private_key = "${file(var.ssh_key_location)}"
    }

    inline = [
      "sudo yum install unzip  curl -y",
      "sudo curl https://releases.hashicorp.com/consul/1.5.1/consul_1.5.1_linux_amd64.zip | sudo sh",
      "unzip consul_0.9.2_linux_amd64.zip",
      "sudo mv consul /usr/local/bin/",
    ]
  }
}
