# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  admin_cidrs      = values(data.vault_generic_secret.internal_cidrs.data)
  s3_releases      = data.vault_generic_secret.s3_releases.data
  metrics_ec2_data = data.vault_generic_secret.metrics_ec2_data.data

  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  logs_kms_key_id        = local.kms_keys_data["logs"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]
  elb_access_logs_prefix      = "elb-access-logs"

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  #For each log map passed, add an extra kv for the log group name
  cw_logs    = { for log, map in var.web_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-web-${log}" }) }
  log_groups = compact([for log, map in local.cw_logs : lookup(map, "log_group_name", "")])

  ro_s3_bucket_names = flatten(concat(var.ro_s3_bucket_names, [local.s3_releases["release_bucket_name"], local.s3_releases["config_bucket_name"], local.s3_releases["resources_bucket_name"]]))

  web_ansible_inputs = {
    s3_bucket_releases         = local.s3_releases["release_bucket_name"]
    s3_bucket_configs          = local.s3_releases["config_bucket_name"]
    environment                = var.environment
    artifact_name              = var.metrics_app_artifact_name
    version                    = var.metrics_app_release_version
    region                     = var.aws_region
    cw_log_files               = local.cw_logs
    cw_agent_user              = "root"
    s3_json_data_source_bucket = local.s3_releases["resources_bucket_name"]
    s3_json_data_source_path   = "/performance-analytics/dashboard/json/"
  }

  default_tags = {
    Terraform   = "true"
    Application = var.application
    Region      = var.aws_region
    Account     = var.aws_account
    ServiceTeam = "${var.application}-support"
  }
}
