variable "domain" {}
variable "subdomain" {}

##########################################################################
# AWS route53
##########################################################################

resource "aws_route53_zone" "app-zone" {
  name    = var.domain
  comment = "Zone for ${var.domain}"
}

resource "aws_route53_record" "app-record" {
  zone_id = aws_route53_zone.app-zone.zone_id
  name    = var.subdomain
  type    = "A"
  ttl     = 300
  records = [aws_eip.interface_eip.public_ip]
}