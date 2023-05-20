resource "aws_s3_bucket" "s3_bucket" {
  #bucket = "ecs-s3-bucket"
  bucket = "ecs-s3-bucket-bucket-s3-ecs"
	
  force_destroy = true
}