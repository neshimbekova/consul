resource "aws_route53_record" "consul_01" {
  zone_id = "${var.zone_id}"
  name    = "consul.${var.domain}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.consul.public_ip}"]
}
