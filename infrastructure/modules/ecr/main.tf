resource "aws_ecr_repository" "my_repo" {
  name = var.ecr_repo_name
  image_scanning_configuration {
    scan_on_push = true
  }
}