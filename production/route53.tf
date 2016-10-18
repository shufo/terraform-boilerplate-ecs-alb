/**
 * Route53 record (apex)
 */
resource "aws_route53_record" "apex" {
    zone_id = "${data.terraform_remote_state.super_state.root_zone_id}"
    name = "dev.${var.route53_zone}"
    type = "A"
    alias {
        name = "${aws_alb.front.dns_name}"
        zone_id = "${aws_alb.front.zone_id}"
        evaluate_target_health = true
    }
}

/**
 * Route53 record (api)
 */
resource "aws_route53_record" "api" {
    zone_id = "${data.terraform_remote_state.super_state.root_zone_id}"
    name = "dev.api.${var.route53_zone}"
    type = "A"
    alias {
        name = "${aws_alb.front.dns_name}"
        zone_id = "${aws_alb.front.zone_id}"
        evaluate_target_health = true
    }
}

/**
 * Route53 record (admin)
 */
resource "aws_route53_record" "admin" {
    zone_id = "${data.terraform_remote_state.super_state.root_zone_id}"
    name = "dev.admin.${var.route53_zone}"
    type = "A"
    alias {
        name = "${aws_alb.front.dns_name}"
        zone_id = "${aws_alb.front.zone_id}"
        evaluate_target_health = true
    }
}

/**
 * Route53 record (ops)
 */
resource "aws_route53_record" "ops" {
    zone_id = "${data.terraform_remote_state.super_state.root_zone_id}"
    name = "dev.ops.${var.route53_zone}"
    type = "A"
    alias {
        name = "${aws_alb.front.dns_name}"
        zone_id = "${aws_alb.front.zone_id}"
        evaluate_target_health = true
    }
}
