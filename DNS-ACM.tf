aws route53 list-hosted-zones

#DNS Configuration
#Get already , publicly configured Hosted Zone on Route53 - MUST EXIST
data "aws_route53_zone" "dns" {
    provider = aws.region-master
    name     = var.dns-name
}

#Create record in hosted zone for ACM Certificate Domain verification
resource "aws_route53_record" "cert_validation" {
    provider = aws.region-master
    for_each = {
        for val in aws_acm_certificate.jenkins-lb-https.domain_validation_options : val.domain_name => {
            name   = val.resource_record_name
            record = val.resource_record_value
            type   = val.resource_record_type
        }
    }
    name    = each.value.name
    records = [each.value.record]
    ttl     = 60
    type    = each.value.type
    zone_id = data.aws_route53_zone.dns.zone_id
}


#ACM CONFIGURATION
#Creates ACM certificate and requests validation via DNS(Route53)
resource "aws_acm_certificate" "jenkins-lb-https" {
  provider          = aws.region-master
  domain_name       = join(".", ["jenkins", data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = "Jenkins-ACM"
  }
}



#Validates ACM issued certificate via Route53
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.region-master
  certificate_arn         = aws_acm_certificate.jenkins-lb-https.arn
  for_each                = aws_route53_record.cert_validation
  validation_record_fqdns = [aws_route53_record.cert_validation[each.key].fqdn]
}

####ACM CONFIG END
