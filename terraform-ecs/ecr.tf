resource "aws_ecr_repository" "ecr_repository" {
  name = "ecr-repository"
  force_delete = true
}