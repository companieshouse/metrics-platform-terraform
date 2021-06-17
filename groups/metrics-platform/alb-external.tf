# ------------------------------------------------------------------------------
# Security Group and rules
# ------------------------------------------------------------------------------
module "external_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.2"

  name        = "sgr-${var.application}-alb-001"
  description = "Security group for the ${var.application} external load balancer"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = var.external_lb_allow_cidr_blocks
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

#--------------------------------------------
# External ALB
#--------------------------------------------
module "external_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.2"

  name                       = "alb-${var.application}-external-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = true

  security_groups = [module.external_alb_security_group.security_group_id]
  subnets         = data.aws_subnet_ids.public.ids

  access_logs = {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  #####
  #  https listner rules not supported by module, disabling for now
  #####
  # http_tcp_listeners = [
  #   {
  #     port               = 80
  #     protocol           = "HTTP"
  #     target_group_index = 0
  #     action_type        = "redirect"
  #     redirect = {
  #       port        = "443"
  #       protocol    = "HTTPS"
  #       status_code = "HTTP_301"
  #     }
  #   },
  # ]
  # http_listener_rules = join( length(var.allowed_external_metrics_paths_http) >=1 ? [
  #   {
  #     # Allow specified paths to be forwarded to the target group
  #     https_listener_index = 0
  #     priority = 100
  #     actions = {
  #       type               = "forward"
  #       target_group_index = 0
  #     }
  #     conditions = [{
  #       path_patterns = var.allowed_external_metrics_paths_http
  #     }]
  #   }] : [],
  #   [{
  #     # Low priority default block, takes priority over default allow
  #     https_listener_index = 0
  #     priority = 1000
  #     actions = [{
  #       type         = "fixed-response"
  #       content_type = "text/plain"
  #       status_code  = 404
  #     }]
  #     conditions = [{
  #       path_patterns = "*"
  #     }]
  #   }]
  # )

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      target_group_index = 0
    },
  ]
  https_listener_rules = concat(
    length(var.allowed_external_metrics_paths_https) >= 1 ? [
      {
        # Allow specified paths to be forwarded to the target group
        https_listener_index = 0
        priority             = 100
        actions = {
          type               = "forward"
          target_group_index = 0
        }
        conditions = [{
          path_patterns = var.allowed_external_metrics_paths_https
        }]
    }] : [],

    [{
      # Low priority default block, takes priority over default allow
      https_listener_index = 0
      priority             = 1000
      actions = [{
        type         = "fixed-response"
        content_type = "text/plain"
        status_code  = 404
      }]
      conditions = [{
        path_patterns = ["*"]
      }]
    }]
  )

  target_groups = [
    {
      name                 = "tg-${var.application}-external-001"
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
# External ALB CloudWatch Merics
#--------------------------------------------
module "external_alb_metrics" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-metrics?ref=tags/1.0.26"

  load_balancer_id = module.external_alb.lb_id
  target_group_ids = module.external_alb.target_group_arns

  depends_on = [module.external_alb]
}