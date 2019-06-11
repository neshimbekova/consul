provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "consul" {
  instance_type               = "${var.instance_type}"
  ami                         = "${var.ami}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "true"
  security_groups             = ["allow_ssh_and_consul"]

  #This will help you provision file
  provisioner "file" {
    source      = "config.json"
    destination = "/tmp/config.json"

    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.user}"
      private_key = "${file(var.ssh_key_location)}"
    }
  }

  provisioner "file" {
    source      = "consul.service"
    destination = "/tmp/consul.service"

    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.user}"
      private_key = "${file(var.ssh_key_location)}"
    }
  }

  provisioner "remote-exec" {
    # connection {  #   host        = "${self.public_ip}"  #   type        = "ssh"  #   user        = "${var.user}"  #   private_key = "${file(var.ssh_key_location)}"    # }

    inline = [
      "sudo hostnamectl set-hostname consul.acirrustech.com --static",
      "setenforce 0",
      "sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config",
      "sudo yum install unzip  wget -y",
      "sudo wget https://releases.hashicorp.com/consul/1.5.1/consul_1.5.1_linux_amd64.zip",
      "sudo unzip consul_1.5.1_linux_amd64.zip",
      "sudo mv consul /usr/local/bin/",
      "sudo groupadd --system consul",
      "sudo useradd -s /sbin/nologin --system -g consul consul",
      "sudo mkdir -p /var/lib/consul /etc/consul.d",
      "sudo chown -R consul:consul /var/lib/consul /etc/consul.d",
      "sudo chmod -R 775 /var/lib/consul /etc/consul.d",
      "sudo echo ${self.private_ip} consul.acirrustech.com consul-01 | sudo tee -a /etc/hosts",
      "sudo cp /tmp/config.json /etc/consul.d/",
      "sudo sed -i 's/ad_addr_tobe_replaced/${self.private_ip}/g' /etc/consul.d/config.json",
      "sudo sed -i 's/bind_addr_tobe_replaced/${self.private_ip}/g' /etc/consul.d/config.json",
      "consul_keygen=$(consul keygen)",
      "sudo sed -i \"s/key_tobe_replaced/$consul_keygen/\" /etc/consul.d/config.json",
      "sudo cp /tmp/consul.service /etc/systemd/system/",
      "sudo sed -i 's/advertise_tobe_replaced/${self.private_ip}/g' /etc/systemd/system/consul.service",
      "sudo sed -i 's/bind_tobe_replaced/${self.private_ip}/g' /etc/systemd/system/consul.service",
      "sudo systemctl start consul",
      "sudo systemctl enable consul",
    ]
  }
}
