resource "aws_vpc_endpoint_policy" "s3_endpoint_policy" {
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement: [
			{
				Sid: "For ECS",
				Effect: "Allow",
			  Principal: "*",
				Action: [
					"s3:ListBucket",
					"s3:PutObject"
				],
				Resource: [
	        aws_s3_bucket.s3_bucket.arn,
	        "${aws_s3_bucket.s3_bucket.arn}/*"
				],
			  Condition: {
					ArnEquals: {
						"aws:PrincipalArn": aws_iam_role.ecs_task_role.arn
					}
				}
			},
			{
				Sid: "For ECR",
				Effect: "Allow",
				Principal: "*",
				Action: "s3:GetObject",
				Resource: "arn:aws:s3:::prod-ap-northeast-2-starport-layer-bucket/*"
			}
		]
  })
}