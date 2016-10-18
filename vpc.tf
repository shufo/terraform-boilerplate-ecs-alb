/**
 * Main VPC
 */
resource "aws_vpc" "main" {
    cidr_block           = "172.31.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags {
        Name = "${var.project}"
        Group = "${var.project}"
    }
}

/**
 * Internet gateway for main VPC
 */
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.project}"
        Group = "${var.project}"
    }
}
