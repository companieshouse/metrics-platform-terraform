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
  ingress_rules       = length(var.external_lb_allow_cidr_blocks) >= 1 ? ["http-80-tcp", "https-443-tcp"] : []
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

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      target_group_index = 0
    },
  ]
  https_listener_rules = concat(
    # If we have paths to allow externally, create a new rule for each 5 entries in the list
    length(var.allowed_external_metrics_paths_https) >= 1 ? [for paths in chunklist(var.allowed_external_metrics_paths_https, 5) :
      {
        # Allow specified paths to be forwarded to the target group
        https_listener_index = 0
        priority             = 100 + index(chunklist(var.allowed_external_metrics_paths_https, 5), paths)
        actions = [{
          type               = "forward"
          target_group_index = 0
        }]
        conditions = [{
          path_patterns = paths
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

  source = "git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms?ref=tags/1.0.116"

  alb_arn_suffix            = module.external_alb.lb_arn_suffix
  target_group_arn_suffixes = module.external_alb.target_group_arn_suffixes

  prefix                    = "metrics-external-"
  response_time_threshold   = "100"
  evaluation_periods        = "3"
  statistic_period          = "60"
  maximum_4xx_threshold     = "2"
  maximum_5xx_threshold     = "2"
  unhealthy_hosts_threshold = "1"

  # If actions are used then all alarms will have these applied, do not add any actions which you only want to be used for specific alarms
  # The module has lifecycle hooks to ignore changes via the AWS Console so in this use case the alarm can be modified there.
  actions_alarm = var.enable_sns_topic ? [module.cloudwatch_sns_notifications[0].sns_topic_arn] : []
  actions_ok    = var.enable_sns_topic ? [module.cloudwatch_sns_notifications[0].sns_topic_arn] : []

  depends_on = [module.external_alb]
}
