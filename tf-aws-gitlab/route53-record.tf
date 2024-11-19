####################################################

### Optional 
### For CloudFlare only 

####################################################

# data "cloudflare_zone" "this" {
#   name = var.domain
# }

# Create an A record in the hosted zone
resource "aws_route53_record" "emagetech" {
  zone_id    = "Z06639414QTF8GXLZVRH"
  name       = "gitlab"
  type       = "A"
  ttl        = "300"
  records    = [aws_eip.gitlab_eip.public_ip]
  depends_on = [aws_instance.gitlab]
}
