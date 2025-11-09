# AWS ECR repositories for supporting infrastructure

# Ansible automation container repository
resource "aws_ecr_repository" "ansible_automation" {
  name                 = "ansible-automation"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, {
    Name = "ansible-automation"
    Type = "container-registry"
  })
}

# GitHub Actions runner container repository
resource "aws_ecr_repository" "github_runner" {
  name                 = "github-actions-runner"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, {
    Name = "github-actions-runner"
    Type = "container-registry"
  })
}

# ECR lifecycle policies
resource "aws_ecr_lifecycle_policy" "ansible_automation" {
  repository = aws_ecr_repository.ansible_automation.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "github_runner" {
  repository = aws_ecr_repository.github_runner.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# In-house developed applications
resource "aws_ecr_repository" "about_website" {
  name                 = "about-website"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.common_tags
}

resource "aws_ecr_lifecycle_policy" "about_website" {
  repository = aws_ecr_repository.about_website.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}