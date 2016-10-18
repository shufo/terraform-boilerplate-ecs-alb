/**
 * S3 bucket for tfstate
 */
resource "aws_s3_bucket" "terraform" {
    bucket = "${var.tf_state_bucket}"

    tags {
        Name = "${var.project}"
        Group = "${var.project}"
    }
}
