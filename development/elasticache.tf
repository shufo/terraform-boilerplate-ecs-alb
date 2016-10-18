/**
 * ElastiCache Cluster
 */
resource "aws_elasticache_cluster" "redis" {
    cluster_id           = "${var.project}-${var.environment}-redis"
    engine               = "redis"
    engine_version       = "2.8.24"
    node_type            = "cache.t2.micro"
    port                 = 6379
    num_cache_nodes      = 1
    parameter_group_name = "${aws_elasticache_parameter_group.redis.name}"
    subnet_group_name    = "${aws_elasticache_subnet_group.redis.name}"
    security_group_ids   = ["${aws_security_group.redis.id}"]
}

/**
 * Parameter group for ElastiCache
 */
resource "aws_elasticache_parameter_group" "redis" {
    name = "${var.project}-cache-params"
    family = "redis2.8"
    description = "Cache cluster default param group"

    parameter {
        name = "activerehashing"
        value = "yes"
    }

    parameter {
        name = "min-slaves-to-write"
        value = "2"
    }
}

/**
 * Subnet group for ElastiCache
 */
resource "aws_elasticache_subnet_group" "redis" {
    name        = "${var.project}-${var.environment}"
    description = "${var.project} ${var.environment} CacheSubnetGroup"
    subnet_ids  = ["${aws_subnet.primary.id}", "${aws_subnet.secondary.id}"]
}
