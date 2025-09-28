output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = module.codebuild_github_runner.codebuild_project_name
}

output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project"
  value       = module.codebuild_github_runner.codebuild_project_arn
}