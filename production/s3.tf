/**
 * S3 bucket for ECS
 */
resource "aws_s3_bucket" "ecs" {
    bucket = "${var.project}.${var.environment}.ecs"

    tags {
        Name = "${var.project}"
        Group = "${var.project}"
    }
}

/**
 * ECS config file
 */
resource "aws_s3_bucket_object" "ecs_config" {
    bucket = "${aws_s3_bucket.ecs.id}"
    key = "ecs.config"
    source = "${template_file.ecs_config.rendered}"
}

# Template for ecs config
resource "template_file" "ecs_config" {
    template = "${file("files/ecs.config")}"

    vars {
        ecs_auth_data = "${var.ecs_auth_data}"
        project = "${var.project}"
    }
}

/**
 * nginx conf file
 */
resource "aws_s3_bucket_object" "nginx_conf" {
    bucket = "${aws_s3_bucket.ecs.id}"
    key = "nginx.conf"
    source = "${template_file.nginx_conf.rendered}"
}

# Template for nginx conf
resource "template_file" "nginx_conf" {
    template = "${file("files/nginx.conf")}"

    vars {
        cidr_block = "${data.terraform_remote_state.super_state.vpc_cidr_block}"
    }
}

/**
 * S3 bucket for assets files
 */
resource "aws_s3_bucket" "assets" {
    bucket = "${var.project}.${var.environment}.assets"
    acl = "public-read"

    tags {
        Name = "${var.project}"
        Group = "${var.project}"
    }
}

/**
 * S3 bucket for ALB log files
 */
resource "aws_s3_bucket" "logs" {
    bucket = "${var.project}.${var.environment}.logs"
    acl = "authenticated-read"
    policy = <<EOL
{
  "Id": "",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.id}"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.project}.${var.environment}.logs/${var.project}/AWSLogs/${var.aws_account_id}/*"
    }
  ]
}
EOL

    tags {
        Name = "${var.project}"
        Group = "${var.project}"
    }

    lifecycle {
      ignore_changes = ["policy"]
    }
}
