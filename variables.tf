variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_token_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing the GitHub token"
  type        = string
}

variable "buildspec_file" {
  description = "Path to the buildspec file in the repository"
  type        = string
  default     = "buildspec.yml"
}

variable "compute_type" {
  description = "CodeBuild compute type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"

  validation {
    condition = contains([
      "BUILD_GENERAL1_SMALL",
      "BUILD_GENERAL1_MEDIUM",
      "BUILD_GENERAL1_LARGE",
      "BUILD_GENERAL1_2XLARGE"
    ], var.compute_type)
    error_message = "Compute type must be one of: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE."
  }
}

variable "environment_image" {
  description = "Docker image to use for the build environment"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}

variable "privileged_mode" {
  description = "Enable privileged mode for Docker builds"
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Build timeout in minutes"
  type        = number
  default     = 60

  validation {
    condition     = var.timeout >= 5 && var.timeout <= 480
    error_message = "Timeout must be between 5 and 480 minutes."
  }
}

variable "environment_variables" {
  description = "Environment variables for the build"
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "PLAINTEXT")
  }))
  default = []
}

variable "artifacts_location" {
  description = "S3 bucket for storing build artifacts"
  type        = string
  default     = ""
}

variable "cache_type" {
  description = "Cache type for CodeBuild project"
  type        = string
  default     = "NO_CACHE"

  validation {
    condition = contains([
      "NO_CACHE",
      "S3",
      "LOCAL"
    ], var.cache_type)
    error_message = "Cache type must be one of: NO_CACHE, S3, LOCAL."
  }
}

variable "cache_location" {
  description = "S3 bucket for caching (required if cache_type is S3)"
  type        = string
  default     = ""
}

variable "vpc_config" {
  description = "VPC configuration for CodeBuild project"
  type = object({
    vpc_id             = string
    subnets            = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}