output "${var.environment}_mysql_endpoint" {
  value = "${aws_db_instance.mysql.address}"
}

output "${var.environment}_redis_endpoint" {
  value = "${aws_elasticache_cluster.redis.cache_nodes.0.address}"
}
