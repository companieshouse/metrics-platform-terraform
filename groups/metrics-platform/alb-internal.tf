# ------------------------------------------------------------------------------
# Security Group and rules
# ------------------------------------------------------------------------------
module "internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.2"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} internal load balancer"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = var.internal_lb_allow_cidr_blocks
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

#--------------------------------------------
# Internal ALB
#--------------------------------------------
resource "aws_route53_record" "internal_alb" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "performance-analytics"
  type    = "A"

  alias {
    name                   = module.internal_alb.lb_dns_name
    zone_id                = module.internal_alb.lb_zone_id
    evaluate_target_health = true
  }
}

module "internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.2"

  name                       = "alb-${var.application}-internal-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "application"
  enable_deletion_protection = true

  security_groups = [module.internal_alb_security_group.security_group_id]
  subnets         = data.aws_subnet_ids.web.ids

  access_logs = {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]


  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      target_group_index = 0
    },
  ]


  target_groups = [
    {
      name                 = "tg-${var.application}-internal-001"
      backend_protocol     = var.web_service_protocol
      backend_port         = var.web_service_port
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.web_health_check_path
        port                = var.web_service_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    },
  ]

  tags = local.default_tags
}

#--------------------------------------------
# Internal ALB CloudWatch Merics
#--------------------------------------------
module "internal_alb_metrics" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-metrics?ref=tags/1.0.26"

  load_balancer_id = module.internal_alb.lb_id
  target_group_ids = module.internal_alb.target_group_arns

  depends_on = [module.internal_alb]
}
