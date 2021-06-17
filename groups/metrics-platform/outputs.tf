output "external_lb_dns_name" {
  value = module.external_alb.lb_dns_name
}

output "external_lb_zone_id" {
  value = module.external_alb.lb_zone_id
}

output "external_lb_id" {
  value = module.external_alb.lb_id
}

output "internal_lb_dns_name" {
  value = module.internal_alb.lb_dns_name
}

output "internal_lb_zone_id" {
  value = module.internal_alb.lb_zone_id
}

output "internal_lb_id" {
  value = module.internal_alb.lb_id
}
