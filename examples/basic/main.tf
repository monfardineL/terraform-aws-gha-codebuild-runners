# Basic Example - AWS CodeBuild Runner for GitHub Actions
#
# This example creates a CodeBuild runner for a single repository
# with a new CodeStar connection for GitHub authentication.

module "codebuild-runners" {
  source = "../../"

  org_name                 = "myorg"
  create_iam_policy        = true
  codestar_connection_name = "github-myorg"

  runners = {
    # Repository name as key, configuration as value
    "my-terraform-repo" = {
      compute_type = "BUILD_GENERAL1_SMALL"
      image        = "aws/codebuild/amazonlinux-aarch64-standard:3.0"
      type         = "ARM_CONTAINER"
    }
  }
}

# Output the CodeBuild project ARNs
output "codebuild_project_arns" {
  description = "ARNs of the created CodeBuild projects"
  value       = module.codebuild-runners.codebuild_project_arns
}
