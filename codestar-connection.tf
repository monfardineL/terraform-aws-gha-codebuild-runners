locals {
  # Validate CodeStar connection configuration
  codestar_both_provided    = var.codestar_connection_name != "" && var.codestar_connection_arn != ""
  codestar_neither_provided = var.codestar_connection_name == "" && var.codestar_connection_arn == ""

  validation_error = local.codestar_both_provided ? tobool("ERROR: Cannot provide both codestar_connection_name and codestar_connection_arn. Use only one.") : (
    local.codestar_neither_provided ? tobool("ERROR: Must provide either codestar_connection_name (to create) or codestar_connection_arn (to use existing).") : true
  )
}

# Create a new CodeStar connection if name is provided
resource "aws_codestarconnections_connection" "github" {
  count = var.codestar_connection_name != "" ? 1 : 0

  name          = var.codestar_connection_name
  provider_type = "GitHub"

  tags = {
    Name = var.codestar_connection_name
  }
}

# Use CodeStar connection for CodeBuild source credentials
resource "aws_codebuild_source_credential" "codeconnection_credentials" {
  count = var.codestar_connection_name != "" || var.codestar_connection_arn != "" ? 1 : 0

  auth_type   = "CODECONNECTIONS"
  server_type = "GITHUB"
  token       = var.codestar_connection_name != "" ? aws_codestarconnections_connection.github[0].arn : var.codestar_connection_arn
}
