resource "aws_route53_record" "consul" {
  zone_id = "${var.zone_id}"
  name    = "consul.${var.domain}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.consul.public_ip}"]
}
