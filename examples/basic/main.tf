provider "aws" {
  region = "us-east-1"
}

# Create a secret for GitHub token (you need to populate this manually)
resource "aws_secretsmanager_secret" "github_token" {
  name                    = "github-token-for-codebuild"
  description             = "GitHub personal access token for CodeBuild"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "github_token" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = "your-github-token-here" # Replace with actual token or reference
}

module "codebuild_github_runner" {
  source = "../../"

  project_name             = "my-github-runner"
  github_repo              = "https://github.com/your-org/your-repo.git"
  github_token_secret_name = aws_secretsmanager_secret.github_token.name

  # Basic configuration
  compute_type      = "BUILD_GENERAL1_SMALL"
  environment_image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  buildspec_file    = "buildspec.yml"
  timeout           = 30

  # Environment variables
  environment_variables = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "BUILD_MODE"
      value = "release"
    }
  ]

  tags = {
    Environment = "production"
    Project     = "github-runner"
    ManagedBy   = "terraform"
  }
}