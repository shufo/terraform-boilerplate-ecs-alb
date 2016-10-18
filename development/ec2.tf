/**
 * Autoscaling group.
 */
resource "aws_autoscaling_group" "asg" {
    name                 = "${var.project}-${var.environment}-autoscaling-group"
    launch_configuration = "${aws_launch_configuration.as_conf.name}"
    /* @todo - variablize */
    min_size             = 2
    max_size             = 2
    desired_capacity     = 2
    vpc_zone_identifier = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]

    tag {
      key = "Name"
      value = "${var.project}-${var.environment}"
      propagate_at_launch = true
    }

    tag {
      key = "Group"
      value = "${var.project}"
      propagate_at_launch = true
    }
}
/**
 * Launch configuration
 */
resource "aws_launch_configuration" "as_conf" {
    name                 = "${var.project}-${var.environment}-web"
    image_id             = "${data.aws_ami.ecs_optimized_ami.image_id}"
    instance_type        = "t2.micro"
    key_name             = "administrator"
    iam_instance_profile = "${data.terraform_remote_state.super_state.instance_role_name}"
    security_groups      = ["${aws_security_group.web.id}"]
    user_data            = "${template_file.user_data.rendered}"

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 20
        delete_on_termination = true
    }

    depends_on = ["aws_s3_bucket.ecs"]
}

# Template for userdata
resource "template_file" "user_data" {
    template = "${file("files/userdata.sh")}"

    vars {
        project = "${var.project}"
        region  = "${var.region}"
        environment = "${var.environment}"
    }
}
