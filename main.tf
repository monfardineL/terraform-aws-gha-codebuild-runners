# Data source to get the GitHub token from Secrets Manager
data "aws_secretsmanager_secret" "github_token" {
  name = var.github_token_secret_name
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

# IAM role for CodeBuild service
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for CodeBuild basic execution
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project_name}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = data.aws_secretsmanager_secret.github_token.arn
      }
    ]
  })
}

# Additional policy for S3 artifacts if specified
resource "aws_iam_role_policy" "codebuild_s3_policy" {
  count = var.artifacts_location != "" || var.cache_location != "" ? 1 : 0
  name  = "${var.project_name}-codebuild-s3-policy"
  role  = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = compact([
          var.artifacts_location != "" ? "${var.artifacts_location}/*" : "",
          var.cache_location != "" ? "${var.cache_location}/*" : ""
        ])
      }
    ]
  })
}

# Additional policy for VPC access if specified
resource "aws_iam_role_policy" "codebuild_vpc_policy" {
  count = var.vpc_config != null ? 1 : 0
  name  = "${var.project_name}-codebuild-vpc-policy"
  role  = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:CreateNetworkInterfacePermission"
        ]
        Resource = "*"
      }
    ]
  })
}

# CodeBuild project
resource "aws_codebuild_project" "github_runner" {
  name         = var.project_name
  description  = "CodeBuild project for GitHub Actions runner"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = var.artifacts_location != "" ? "S3" : "NO_ARTIFACTS"
    location = var.artifacts_location != "" ? var.artifacts_location : null
  }

  cache {
    type     = var.cache_type
    location = var.cache_type == "S3" ? var.cache_location : null
    modes    = var.cache_type == "LOCAL" ? ["LOCAL_DOCKER_LAYER_CACHE"] : null
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.environment_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }

    environment_variable {
      name  = "GITHUB_TOKEN"
      value = data.aws_secretsmanager_secret.github_token.name
      type  = "SECRETS_MANAGER"
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    buildspec       = var.buildspec_file

    git_submodules_config {
      fetch_submodules = true
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      vpc_id             = vpc_config.value.vpc_id
      subnets            = vpc_config.value.subnets
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  queued_timeout = var.timeout

  tags = merge(var.tags, {
    Name = var.project_name
  })
}