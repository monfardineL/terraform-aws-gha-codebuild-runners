resource "aws_codebuild_project" "github_runner" {
  for_each = var.runners

  name                   = "github-runner-${each.key}"
  description            = "CodeBuild project for GitHub Actions runner - ${each.key}"
  service_role           = var.create_iam_policy ? aws_iam_role.codebuild_service_role[0].arn : var.codebuild_iam_policy_arn
  build_timeout          = "120"
  concurrent_build_limit = 5

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = each.value.compute_type
    image                       = each.value.image
    type                        = each.value.type
    image_pull_credentials_type = "CODEBUILD"
    #checkov:skip=CKV_AWS_316:Privileged mode is required for building docker images
    privileged_mode = true

  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.org_name}/${each.key}.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }

    auth {
      type     = "CODECONNECTIONS"
      resource = var.codestar_connection_name != "" ? aws_codestarconnections_connection.github[0].arn : var.codestar_connection_arn
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

}



resource "aws_codebuild_webhook" "github_webhook" {
  for_each = var.runners

  project_name = aws_codebuild_project.github_runner[each.key].name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "WORKFLOW_JOB_QUEUED"
    }
  }
}