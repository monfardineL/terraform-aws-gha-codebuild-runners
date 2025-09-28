provider "aws" {
  region = "us-east-1"
}

# Data sources for existing VPC resources
data "aws_vpc" "main" {
  default = true
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# Security group for CodeBuild
resource "aws_security_group" "codebuild" {
  name_prefix = "codebuild-runner-"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "codebuild-runner-sg"
  }
}

# S3 bucket for artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket        = "codebuild-runner-artifacts-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 bucket for cache
resource "aws_s3_bucket" "cache" {
  bucket        = "codebuild-runner-cache-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "cache" {
  bucket = aws_s3_bucket.cache.id
  versioning_configuration {
    status = "Enabled"
  }
}

# GitHub token secret
resource "aws_secretsmanager_secret" "github_token" {
  name                    = "github-token-advanced-codebuild"
  description             = "GitHub personal access token for CodeBuild"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "github_token" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = "your-github-token-here" # Replace with actual token
}

module "codebuild_github_runner" {
  source = "../../"

  project_name             = "advanced-github-runner"
  github_repo              = "https://github.com/your-org/your-repo.git"
  github_token_secret_name = aws_secretsmanager_secret.github_token.name

  # Advanced configuration
  compute_type      = "BUILD_GENERAL1_MEDIUM"
  environment_image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  privileged_mode   = true
  buildspec_file    = "buildspec.yml"
  timeout           = 120

  # S3 configuration
  artifacts_location = aws_s3_bucket.artifacts.bucket
  cache_type         = "S3"
  cache_location     = aws_s3_bucket.cache.bucket

  # VPC configuration
  vpc_config = {
    vpc_id             = data.aws_vpc.main.id
    subnets            = data.aws_subnets.private.ids
    security_group_ids = [aws_security_group.codebuild.id]
  }

  # Environment variables
  environment_variables = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "BUILD_MODE"
      value = "release"
    },
    {
      name  = "DOCKER_BUILDKIT"
      value = "1"
    }
  ]

  tags = {
    Environment = "production"
    Project     = "github-runner"
    ManagedBy   = "terraform"
    Example     = "advanced"
  }
}