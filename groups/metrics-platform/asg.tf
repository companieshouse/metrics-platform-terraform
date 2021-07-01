# ------------------------------------------------------------------------------
# Security Group and rules
# ------------------------------------------------------------------------------
module "asg_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.2"

  name        = "sgr-${var.application}-asg-001"
  description = "Security group for the ${var.application} frontend asg"
  vpc_id      = data.aws_vpc.vpc.id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.internal_alb_security_group.security_group_id
    },
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.external_alb_security_group.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  egress_rules = ["all-all"]

  tags = merge(
    local.default_tags,
  )
}

resource "aws_cloudwatch_log_group" "log_group" {
  for_each = local.cw_logs

  name              = each.value["log_group_name"]
  retention_in_days = lookup(each.value, "log_group_retention", var.default_log_group_retention_in_days)
  kms_key_id        = lookup(each.value, "kms_key_id", local.logs_kms_key_id)

  tags = merge(
    local.default_tags,
  )
}

# ASG Scheduled Shutdown for non-production
resource "aws_autoscaling_schedule" "schedule-stop" {
  count = var.scheduled_stop_recurrence != null ? 1 : 0

  scheduled_action_name  = "${var.aws_account}-${var.application}-scheduled-shutdown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.scheduled_stop_recurrence
  autoscaling_group_name = module.asg.this_autoscaling_group_name
}

# ASG Scheduled Startup for non-production
resource "aws_autoscaling_schedule" "schedule-start" {
  count = var.scheduled_start_recurrence != null ? 1 : 0

  scheduled_action_name  = "${var.aws_account}-${var.application}-scheduled-startup"
  min_size               = var.web_asg_min_size
  max_size               = var.web_asg_max_size
  desired_capacity       = var.web_asg_desired_capacity
  recurrence             = var.scheduled_start_recurrence
  autoscaling_group_name = module.asg.this_autoscaling_group_name
}

# ASG Module
module "asg" {
  source = "git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling?ref=tags/1.0.36"

  name = "${var.application}-webserver"
  # Launch configuration
  lc_name       = "${var.application}-launchconfig"
  image_id      = data.aws_ami.metrics.id
  instance_type = var.web_instance_size
  security_groups = [
    module.asg_security_group.security_group_id,
    data.aws_security_group.nagios_shared.id
  ]
  root_block_device = [
    {
      volume_size = "40"
      volume_type = "gp2"
      encrypted   = true
      iops        = 0
    },
  ]
  # Auto scaling group
  asg_name                       = "${var.application}-asg"
  vpc_zone_identifier            = data.aws_subnet_ids.web.ids
  health_check_type              = "ELB"
  min_size                       = var.web_asg_min_size
  max_size                       = var.web_asg_max_size
  desired_capacity               = var.web_asg_desired_capacity
  health_check_grace_period      = 300
  wait_for_capacity_timeout      = 0
  force_delete                   = true
  enable_instance_refresh        = true
  refresh_min_healthy_percentage = 50
  refresh_triggers               = ["launch_configuration"]
  key_name                       = aws_key_pair.metrics_keypair.key_name
  termination_policies           = ["OldestLaunchConfiguration"]
  target_group_arns              = concat(module.external_alb.target_group_arns, module.internal_alb.target_group_arns)
  iam_instance_profile           = module.web_profile.aws_iam_instance_profile.name
  user_data_base64               = data.template_cloudinit_config.web_userdata_config.rendered

  tags_as_map = merge(
    local.default_tags,
  )

  depends_on = [
    module.external_alb,
    module.internal_alb
  ]
}