/**
 * Security group for api
 */
resource "aws_security_group" "web" {
    name = "${var.project}-${var.environment}-web"
    description = "security group for ${var.project} web"
    vpc_id = "${data.terraform_remote_state.super_state.vpc_id}"

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP access from anywhere
    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

/**
 * Security group for ALB
 */
resource "aws_security_group" "alb" {
    name = "${var.project}-${var.environment}-alb"
    description = "security group for ${var.project} alb"
    vpc_id = "${data.terraform_remote_state.super_state.vpc_id}"

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

/**
 * Security group for MySQL
 */
resource "aws_security_group" "mysql" {
    name = "${var.project}-${var.environment}-mysql"
    description = "security group for ${var.project} mysql"
    vpc_id = "${data.terraform_remote_state.super_state.vpc_id}"

    ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

/**
 * Security group for Redis
 */
resource "aws_security_group" "redis" {
    name = "${var.project}-${var.environment}-redis"
    description = "security group for ${var.project} redis"
    vpc_id = "${data.terraform_remote_state.super_state.vpc_id}"

    ingress {
      from_port = 6379
      to_port = 6379
      protocol = "tcp"
      cidr_blocks = ["${data.terraform_remote_state.super_state.vpc_cidr_block}"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
