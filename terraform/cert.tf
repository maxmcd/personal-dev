resource "aws_route53_zone" "rivet_app" {
  name = "rivet.app"
}

output "nameservers" {
  value = [
    "${aws_route53_zone.rivet_app.name_servers.0}",
    "${aws_route53_zone.rivet_app.name_servers.1}",
    "${aws_route53_zone.rivet_app.name_servers.2}",
    "${aws_route53_zone.rivet_app.name_servers.3}",
  ]
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "rivet.app"
  subject_alternative_names = ["*.rivet.app"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  zone_id = "${aws_route53_zone.rivet_app.id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  ttl     = 60
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

