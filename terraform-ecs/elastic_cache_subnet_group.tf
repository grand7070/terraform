resource "aws_elasticache_subnet_group" "elastic_cache_subnet_group" {
  name       = "elastic-cache-subnet-group"
  subnet_ids = [
    aws_subnet.db_prv_a.id,
    aws_subnet.db_prv_c.id
  ]
}