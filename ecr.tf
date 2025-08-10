resource "aws_ecr_repository" "go_rest_api_repo" {
  name                 = "go-rest-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
