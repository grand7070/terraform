resource "aws_vpc_endpoint" "s3_endpoint" {
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"
	
  vpc_id            = aws_vpc.vpc.id
	route_table_ids = [aws_route_table.prv_app_rt.id]
	
}

resource "aws_vpc_endpoint" "ecs_endpoint" {
  service_name      = "com.amazonaws.ap-northeast-2.ecs"
  vpc_endpoint_type = "Interface"

  vpc_id            = aws_vpc.vpc.id
	subnet_ids          = [
		aws_subnet.app_prv_a.id,
		aws_subnet.app_prv_c.id
	]
  
	security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true # ?
}

resource "aws_vpc_endpoint" "ecs_agent_endpoint" {
  service_name      = "com.amazonaws.ap-northeast-2.ecs-agent"
  vpc_endpoint_type = "Interface"

  vpc_id            = aws_vpc.vpc.id
	subnet_ids          = [
		aws_subnet.app_prv_a.id,
		aws_subnet.app_prv_c.id
	]
  
	security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true # ?
}

resource "aws_vpc_endpoint" "ecs_telemetry_endpoint" {
  service_name      = "com.amazonaws.ap-northeast-2.ecs-telemetry"
  vpc_endpoint_type = "Interface"

  vpc_id            = aws_vpc.vpc.id
	subnet_ids          = [
		aws_subnet.app_prv_a.id,
		aws_subnet.app_prv_c.id
	]
  
	security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true # ?
}

resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  service_name      = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type = "Interface"

  vpc_id            = aws_vpc.vpc.id
	subnet_ids          = [
		aws_subnet.app_prv_a.id,
		aws_subnet.app_prv_c.id
	]
  
	security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true # ?
}

resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  service_name      = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"

  vpc_id            = aws_vpc.vpc.id
	subnet_ids          = [
		aws_subnet.app_prv_a.id,
		aws_subnet.app_prv_c.id
	]
  
	security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true # ?
}

resource "aws_vpc_endpoint" "cloudatch_log_endpoint" {
  service_name      = "com.amazonaws.ap-northeast-2.logs"
  vpc_endpoint_type = "Interface"

  vpc_id            = aws_vpc.vpc.id
	subnet_ids          = [
		aws_subnet.app_prv_a.id,
		aws_subnet.app_prv_c.id
	]
  
	security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true # ?
}