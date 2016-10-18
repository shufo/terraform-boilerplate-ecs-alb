/**
 * Application LoadBalancer
 */
resource "aws_alb" "front" {
  name            = "${var.project}-${var.environment}-front-alb"
  internal        = false
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]

  enable_deletion_protection = true

  access_logs {
    bucket = "${aws_s3_bucket.logs.bucket}"
    prefix = "${var.project}"
  }

  tags {
    Group = "${var.project}"
    Environment = "${var.environment}"
  }
}

/**
 * Target group for ALB
 */
resource "aws_alb_target_group" "web" {
  name     = "${var.project}-${var.environment}-tg-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.super_state.vpc_id}"

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path = "/"
  }

  tags {
    Group = "${var.project}"
    Environment = "${var.environment}"
  }
}

/**
 * HTTP Lister for ALB
 */
resource "aws_alb_listener" "front_80" {
   load_balancer_arn = "${aws_alb.front.arn}"
   port = "80"
   protocol = "HTTP"
   default_action {
     target_group_arn = "${aws_alb_target_group.web.arn}"
     type = "forward"
   }
}

/** HTTPS Listener for front ALB
 * Uncomment this If you use HTTPS.
 *
resource "aws_alb_listener" "front_443" {
   load_balancer_arn = "${aws_alb.front.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-2015-05"
   certificate_arn = "arn:aws:iam::1234567890:server-certificate/foobar"

   default_action {
     target_group_arn = "${aws_alb_target_group.web.arn}"
     type = "forward"
   }
}
*/
