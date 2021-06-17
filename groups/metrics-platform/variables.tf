# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "public_allow_cidr_blocks" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "cidr block for allowing inbound users from internet"
}

# ------------------------------------------------------------------------------
# Web server variables - ALB 
# ------------------------------------------------------------------------------

variable "web_service_port" {
  type        = number
  default     = 80
  description = "Target group backend port"
}

variable "web_service_protocol" {
  type        = string
  default     = "HTTP"
  description = "Target group backend protocol, default HTTP"
}

variable "web_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path"
}

variable "default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "release_version" {
  type        = string
  description = "Version of the application to download for deployment to web server(s)"
}

variable "ami_name_filter" {
  type        = string
  default     = "metrics-platform-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for metrics web server(s)"
}

variable "web_instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "web_asg_min_size" {
  type        = number
  description = "The min size of the ASG"
}

variable "web_asg_max_size" {
  type        = number
  description = "The max size of the ASG"
}

variable "web_asg_desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "web_cw_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}

variable "scheduled_stop_recurrence" {
  type        = string
  default     = null
  description = "Cloudwatch schedule expression for scheduled stop of instances. Null to disable scheduled stop."
}

variable "scheduled_start_recurrence" {
  type        = string
  default     = null
  description = "Cloudwatch schedule expression for scheduled start of instances. Null to disable scheduled start."
}

variable "allowed_external_metrics_paths_http" {
  type        = set(string)
  default     = []
  description = "List of URL path matching strings to allow access from the external load balancer via HTTP. All non-matched paths will return a 404 from external sources"
}

variable "allowed_external_metrics_paths_https" {
  type        = set(string)
  default     = []
  description = "List of URL path matching strings to allow access from the external load balancer via HTTPS. All non-matched paths will return a 404 from external sources"
}

variable "ro_s3_bucket_names" {
  type        = list(string)
  default     = []
  description = "List of S3 buckets to grant read only access to (e.g. for configuration downloads)"
}

variable "external_lb_allow_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks allowed access to web ports in the external LB security group"
}

variable "internal_lb_allow_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks allowed access to web ports in the internal LB security group"
}