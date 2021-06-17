
resource "aws_key_pair" "metrics_keypair" {
  key_name   = var.application
  public_key = local.metrics_ec2_data["public-key"]
}
