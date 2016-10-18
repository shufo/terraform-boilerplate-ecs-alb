/**
 * RDS instance
 */
resource "aws_db_instance" "mysql" {
    identifier                = "${var.project}-${var.environment}"
    allocated_storage         = 20
    storage_type              = "gp2"
    engine                    = "mysql"
    engine_version            = "5.7.10"
    instance_class            = "db.t2.micro"
    name                      = "${var.project}"
    username                  = "${var.project}"
    password                  = "foobar"
    port                      = 3306
    publicly_accessible       = false
    security_group_names      = []
    vpc_security_group_ids    = ["${aws_security_group.mysql.id}"]
    db_subnet_group_name      = "${aws_db_subnet_group.mysql.id}"
    parameter_group_name      = "${aws_db_parameter_group.mysql.name}"
    multi_az                  = false
    backup_retention_period   = 0
    backup_window             = "05:20-05:50"
    maintenance_window        = "sun:04:00-sun:04:30"
    final_snapshot_identifier = "${var.project}-${var.environment}-final"

    tags = {
      Name = "${var.project}-${var.environment}"
      Group = "${var.project}"
    }
}

/**
 * Parameter group for MySQL
 */
resource "aws_db_parameter_group" "mysql" {
  name = "${var.project}-${var.environment}-pg"
  family = "mysql5.7"
  description = "RDS parameter group for ${var.project}"

  parameter {
    name = "character_set_server"
    value = "utf8"
  }

  parameter {
    name = "character_set_client"
    value = "utf8"
  }
}

/**
 * Subnet group for RDS
 */
resource "aws_db_subnet_group" "mysql" {
    name = "${var.project}-${var.environment}"
    description = "${var.project} group of subnets"
    subnet_ids = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]
    tags {
        Name = "${var.project} DB subnet group"
    }
}
