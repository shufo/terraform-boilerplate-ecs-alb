/**
 * ECS Cluster
 */
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-${var.environment}"
}

/**
 * ECS Service
 */
resource "aws_ecs_service" "api" {
  name = "api"
  cluster = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.api.arn}"
  desired_count = 2
  deployment_minimum_healthy_percent = 50
  iam_role = "${data.terraform_remote_state.super_state.instance_role}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.web.arn}"
    container_name = "nginx"
    container_port = 80
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}

/**
 * API Task definition for ECS Service
 */
resource "aws_ecs_task_definition" "api" {
  family = "${var.project}-api"
  container_definitions = "${template_file.api_container_definition.rendered}"

  volume {
    name = "nginx_conf"
    host_path = "/nginx.conf"
  }
}

/**
 * Template for task definition
 */
resource "template_file" "api_container_definition" {
    template = "${file("files/task-definitions/api.json")}"

    vars {
        environment = "${var.environment}"
        docker_repository = "${var.docker_repository}"
        mysql_endpoint = "${aws_db_instance.mysql.address}"
        redis_endpooint = "${aws_elasticache_cluster.redis.cache_nodes.0.address}"
    }
}

/**
 * Migrate Task definition for ECS Service
 */
resource "aws_ecs_task_definition" "migrate" {
  family = "${var.project}-migrate"
  container_definitions = "${template_file.migrate_task_definition.rendered}"
}

/**
 * Template for task definition
 */
resource "template_file" "migrate_task_definition" {
    template = "${file("files/task-definitions/migrate.json")}"

    vars {
        environment = "${var.environment}"
        docker_repository = "${var.docker_repository}"
        mysql_endpoint = "${aws_db_instance.mysql.address}"
        redis_endpooint = "${aws_elasticache_cluster.redis.cache_nodes.0.address}"
    }
}
