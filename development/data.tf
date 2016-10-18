# Super state config
data "terraform_remote_state" "super_state" {
  backend = "s3"
  config {
    bucket = "${var.tf_state_bucket}"
    region = "${var.region}"
    key = "${var.tf_state_key_super}"
  }
}
# Data resource for availability zone
data "aws_availability_zones" "available" {}
# Data resource for elb service account id
data "aws_elb_service_account" "main" { }
# AMI selector for ECS-Optimized AMI
data "aws_ami" "ecs_optimized_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["*ecs-optimized*"]
  }
  name_regex = "^amzn-ami-.*-amazon-ecs-optimized$"
  owners = ["amazon"]
}
