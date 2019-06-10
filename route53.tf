resource "aws_route53_record" "consul" {
  zone_id = "${var.zone_id}"
  name    = "consul.${var.domain}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.consul_01.public_ip}"]
}
