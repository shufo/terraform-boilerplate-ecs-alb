/**
 * Remote state for development environment
 *
 * ## Example
 *  `outputs.tf`
 *
 *  output "development_mysql_endpoint" {
 *    value = "${data.terraform_remote_state.development_state.development_mysql_endpoint}"
 *  }
 *
 *  $ terraform show
 */
data "terraform_remote_state" "development_state" {
  backend = "s3"
  config {
    bucket = "${var.tf_state_bucket}"
    region = "${var.region}"
    key = "${var.tf_state_key_development}"
  }
  depends_on = ["aws_s3_bucket.terraform"]
}

/**
 * Remote state for production environment
 *
 * ## Example
 *  `outputs.tf`
 *
 *  output "development_mysql_endpoint" {
 *    value = "${data.terraform_remote_state.production_state.production_mysql_endpoint}"
 *  }
 *
 *  $ terraform show
 */
data "terraform_remote_state" "production_state" {
  backend = "s3"
  config {
    bucket = "${var.tf_state_bucket}"
    region = "${var.region}"
    key = "${var.tf_state_key_production}"
  }
  depends_on = ["aws_s3_bucket.terraform"]
}
