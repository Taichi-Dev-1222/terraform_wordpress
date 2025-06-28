resource "aws_route53_zone" "main" {
  name = "dev-tf-wp.com"
}

# ルートドメイン Aレコード
resource "aws_route53_record" "root_a_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = aws_route53_zone.main.name  # dev-tf-wp.com
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

# サブドメイン wp.dev-tf-techbull.com 用 Aレコード
resource "aws_route53_record" "wp_subdomain_a_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "wp.${aws_route53_zone.main.name}"  # dev-tf-wp.com
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}