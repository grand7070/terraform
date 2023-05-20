resource "aws_ecr_repository" "ecr_repository" {
  name = "ecr_repository"
  force_delete = true
}