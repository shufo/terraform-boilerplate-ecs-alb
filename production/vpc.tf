/**
 * Primary subnet
 */
resource "aws_subnet" "primary" {
    vpc_id = "${data.terraform_remote_state.super_state.vpc_id}"
    cidr_block = "172.31.0.0/20"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    map_public_ip_on_launch = true
    tags {
            Name = "${var.project}-${var.environment}"
    }
}

/**
 * Secondary subnet
 */
resource "aws_subnet" "secondary" {
    vpc_id = "${data.terraform_remote_state.super_state.vpc_id}"
    cidr_block = "172.31.16.0/20"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"
    map_public_ip_on_launch = true
    tags {
            Name = "${var.project}-${var.environment}"
    }
}

/**
 * Route table for vpc
 */
resource "aws_route_table" "rt" {
    vpc_id = "${data.terraform_remote_state.super_state.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${data.terraform_remote_state.super_state.internet_gateway_id}"
    }

    tags {
        Name = "${var.project}-${var.environment}"
    }
}

/**
 * Route table association for primary subnet
 */
resource "aws_route_table_association" "primary" {
    subnet_id = "${aws_subnet.primary.id}"
    route_table_id = "${aws_route_table.rt.id}"
}

/**
 * Route table association for secondary subnet
 */
resource "aws_route_table_association" "secondary" {
    subnet_id = "${aws_subnet.secondary.id}"
    route_table_id = "${aws_route_table.rt.id}"
}
