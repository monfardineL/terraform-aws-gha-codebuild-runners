variable "org_name" {
  type        = string
  description = "The name of the GitHub organization where the CodeBuild runners will be used."
}

variable "create_iam_policy" {
  type        = bool
  default     = true
  description = "If the module should create the IAM Policy for the CodeBuild project. If false, you must provide the policy ARN via the 'codebuild_iam_policy_arn' variable. Default is true."
}

variable "codebuild_iam_policy_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM Policy to attach to the CodeBuild project's role. Only required if 'create_iam_policy' is false."

  validation {
    condition     = var.create_iam_policy || var.codebuild_iam_policy_arn != ""
    error_message = "The codebuild_iam_policy_arn variable must be provided when create_iam_policy is false."
  }
}

variable "codestar_connection_name" {
  type        = string
  default     = ""
  description = "The name for a new CodeStar connection to create. Mutually exclusive with 'codestar_connection_arn'."
}

variable "codestar_connection_arn" {
  type        = string
  default     = ""
  description = "The ARN of an existing CodeStar Connection to use for GitHub authentication. Mutually exclusive with 'codestar_connection_name'."
}

variable "runners" {
  type = map(object({
    compute_type = optional(string, "BUILD_GENERAL1_SMALL")
    image        = optional(string, "aws/codebuild/amazonlinux-aarch64-standard:3.0")
    type         = optional(string, "ARM_CONTAINER")
  }))
  description = "A map of runner configurations keyed by repository name, each specifying compute type, image, and environment type. Repository name is the map key."
}