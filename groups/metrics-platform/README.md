<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_asg"></a> [asg](#module\_asg) | git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling | tags/1.0.36 |
| <a name="module_asg_alarms"></a> [asg\_alarms](#module\_asg\_alarms) | git@github.com:companieshouse/terraform-modules//aws/asg-cloudwatch-alarms | tags/1.0.116 |
| <a name="module_asg_security_group"></a> [asg\_security\_group](#module\_asg\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.2 |
| <a name="module_cloudwatch_sns_notifications"></a> [cloudwatch\_sns\_notifications](#module\_cloudwatch\_sns\_notifications) | terraform-aws-modules/sns/aws | 3.3.0 |
| <a name="module_cloudwatch_sns_ooh"></a> [cloudwatch\_sns\_ooh](#module\_cloudwatch\_sns\_ooh) | terraform-aws-modules/sns/aws | 3.3.0 |
| <a name="module_external_alb"></a> [external\_alb](#module\_external\_alb) | terraform-aws-modules/alb/aws | ~> 6.10.0 |
| <a name="module_external_alb_metrics"></a> [external\_alb\_metrics](#module\_external\_alb\_metrics) | git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms | tags/1.0.116 |
| <a name="module_external_alb_security_group"></a> [external\_alb\_security\_group](#module\_external\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.2 |
| <a name="module_internal_alb"></a> [internal\_alb](#module\_internal\_alb) | terraform-aws-modules/alb/aws | ~> 6.10.0 |
| <a name="module_internal_alb_metrics"></a> [internal\_alb\_metrics](#module\_internal\_alb\_metrics) | git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms | tags/1.0.116 |
| <a name="module_internal_alb_security_group"></a> [internal\_alb\_security\_group](#module\_internal\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.2 |
| <a name="module_web_profile"></a> [web\_profile](#module\_web\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile | tags/1.0.59 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_autoscaling_schedule.schedule-start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.schedule-stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_key_pair.metrics_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.internal_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.metrics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.nagios_shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_cloudinit_config.web_userdata_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.web_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.metrics_ec2_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.s3_releases](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_allowed_external_metrics_paths_http"></a> [allowed\_external\_metrics\_paths\_http](#input\_allowed\_external\_metrics\_paths\_http) | List of URL path matching strings to allow access from the external load balancer via HTTP. All non-matched paths will return a 404 from external sources | `set(string)` | `[]` | no |
| <a name="input_allowed_external_metrics_paths_https"></a> [allowed\_external\_metrics\_paths\_https](#input\_allowed\_external\_metrics\_paths\_https) | List of URL path matching strings to allow access from the external load balancer via HTTPS. All non-matched paths will return a 404 from external sources | `set(string)` | `[]` | no |
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_default_log_group_retention_in_days"></a> [default\_log\_group\_retention\_in\_days](#input\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_enable_sns_topic"></a> [enable\_sns\_topic](#input\_enable\_sns\_topic) | A boolean value to alter deployment of an SNS topic for CloudWatch actions | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_external_lb_allow_cidr_blocks"></a> [external\_lb\_allow\_cidr\_blocks](#input\_external\_lb\_allow\_cidr\_blocks) | List of CIDR blocks allowed access to web ports in the external LB security group | `list(string)` | `[]` | no |
| <a name="input_internal_lb_allow_cidr_blocks"></a> [internal\_lb\_allow\_cidr\_blocks](#input\_internal\_lb\_allow\_cidr\_blocks) | List of CIDR blocks allowed access to web ports in the internal LB security group | `list(string)` | `[]` | no |
| <a name="input_metrics_ami_name_filter"></a> [metrics\_ami\_name\_filter](#input\_metrics\_ami\_name\_filter) | Name of the AMI to use in the Auto Scaling configuration for metrics web server(s) | `string` | `"metrics-platform-*"` | no |
| <a name="input_metrics_app_artifact_name"></a> [metrics\_app\_artifact\_name](#input\_metrics\_app\_artifact\_name) | Name of the application artifact to download for deployment to web server(s) | `string` | `"performance-analysis"` | no |
| <a name="input_metrics_app_release_version"></a> [metrics\_app\_release\_version](#input\_metrics\_app\_release\_version) | Version of the application to download for deployment to web server(s) | `string` | n/a | yes |
| <a name="input_public_allow_cidr_blocks"></a> [public\_allow\_cidr\_blocks](#input\_public\_allow\_cidr\_blocks) | cidr block for allowing inbound users from internet | `list(any)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_ro_s3_bucket_names"></a> [ro\_s3\_bucket\_names](#input\_ro\_s3\_bucket\_names) | List of S3 buckets to grant read only access to (e.g. for configuration downloads) | `list(string)` | `[]` | no |
| <a name="input_scheduled_start_recurrence"></a> [scheduled\_start\_recurrence](#input\_scheduled\_start\_recurrence) | Cloudwatch schedule expression for scheduled start of instances. Null to disable scheduled start. | `string` | `null` | no |
| <a name="input_scheduled_stop_recurrence"></a> [scheduled\_stop\_recurrence](#input\_scheduled\_stop\_recurrence) | Cloudwatch schedule expression for scheduled stop of instances. Null to disable scheduled stop. | `string` | `null` | no |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_web_asg_desired_capacity"></a> [web\_asg\_desired\_capacity](#input\_web\_asg\_desired\_capacity) | The desired capacity of ASG | `number` | n/a | yes |
| <a name="input_web_asg_max_size"></a> [web\_asg\_max\_size](#input\_web\_asg\_max\_size) | The max size of the ASG | `number` | n/a | yes |
| <a name="input_web_asg_min_size"></a> [web\_asg\_min\_size](#input\_web\_asg\_min\_size) | The min size of the ASG | `number` | n/a | yes |
| <a name="input_web_cw_logs"></a> [web\_cw\_logs](#input\_web\_cw\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_web_health_check_path"></a> [web\_health\_check\_path](#input\_web\_health\_check\_path) | Target group health check path | `string` | `"/dashboard/"` | no |
| <a name="input_web_instance_size"></a> [web\_instance\_size](#input\_web\_instance\_size) | The size of the ec2 instances to build | `string` | n/a | yes |
| <a name="input_web_service_port"></a> [web\_service\_port](#input\_web\_service\_port) | Target group backend port | `number` | `80` | no |
| <a name="input_web_service_protocol"></a> [web\_service\_protocol](#input\_web\_service\_protocol) | Target group backend protocol, default HTTP | `string` | `"HTTP"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_external_lb_dns_name"></a> [external\_lb\_dns\_name](#output\_external\_lb\_dns\_name) | n/a |
| <a name="output_external_lb_id"></a> [external\_lb\_id](#output\_external\_lb\_id) | n/a |
| <a name="output_external_lb_zone_id"></a> [external\_lb\_zone\_id](#output\_external\_lb\_zone\_id) | n/a |
| <a name="output_internal_alb_dns"></a> [internal\_alb\_dns](#output\_internal\_alb\_dns) | n/a |
| <a name="output_internal_lb_dns_name"></a> [internal\_lb\_dns\_name](#output\_internal\_lb\_dns\_name) | n/a |
| <a name="output_internal_lb_id"></a> [internal\_lb\_id](#output\_internal\_lb\_id) | n/a |
| <a name="output_internal_lb_zone_id"></a> [internal\_lb\_zone\_id](#output\_internal\_lb\_zone\_id) | n/a |
<!-- END_TF_DOCS -->