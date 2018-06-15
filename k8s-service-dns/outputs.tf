output "dns_record" {
  value = "${aws_route53_record.record.fqdn}"
}
