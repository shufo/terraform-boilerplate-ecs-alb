output "root_zone_id" {
  value = "${aws_route53_zone.primary.id}"
}

output "instance_role_name" {
  value = "${aws_iam_instance_profile.instance_role.name}"
}

output "instance_role_policy" {
  value = "${aws_iam_role_policy.instance_role_policy.name}"
}

output "instance_role" {
  value = "${aws_iam_role.instance_role.arn}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.gw.id}"
}

/** Development output
 *  Uncomment this if you want display endpoints for mysql or rds in development environment.
 */
/**
output "development_mysql_endpoint" {
  value = "${data.terraform_remote_state.development_state.development_mysql_endpoint}"
}

output "development_redis_endpoint" {
  value = "${data.terraform_remote_state.development_state.development_redis_endpoint}"
}
*/

/** Production output
 *  Uncomment this if you want display endpoints for mysql or rds in production environment.
 */
/**
output "production_mysql_endpoint" {
  value = "${data.terraform_remote_state.production_state.production_mysql_endpoint}"
}

output "production_redis_endpoint" {
  value = "${data.terraform_remote_state.production_state.production_redis_endpoint}"
}
*/
