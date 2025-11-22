variable "zone" {
  type = object({
    id   = string
    name = string
  })
  description = "The aws_route53_zone (required)"
}