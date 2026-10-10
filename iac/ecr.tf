resource "aws_ecr_repository" "app" {
  name                 = "aws-devops-demo"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Remove untagged images after seven days"
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 7
      }
      action = {
        type = "expire"
      }
    }]
  })
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
