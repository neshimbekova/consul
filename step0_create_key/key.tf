resource "aws_key_pair" "app-rsa" {
  key_name   = "app-rsa"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
