resource "aws_elasticache_cluster" "elastic_cache" {
  engine               = "redis"
	# 클러스터 모드 ?
  cluster_id           = "elastic-cache"
	# 다중 AZ ?
	# 자동 장애 조치 ?
  engine_version       = "7.0"
  port                 = 6379
  parameter_group_name = "default.redis7"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1

	subnet_group_name = aws_elasticache_subnet_group.elastic_cache_subnet_group.name

	security_group_ids = [redis_sg.id]

	snapshot_retention_limit = 0
}