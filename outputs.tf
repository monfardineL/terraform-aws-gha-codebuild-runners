output "codestar_connection_arn" {
  description = "The ARN of the CodeStar connection (either created or provided)"
  value       = var.codestar_connection_name != "" ? aws_codestarconnections_connection.github[0].arn : var.codestar_connection_arn
}

output "codestar_connection_status" {
  description = "The status of the CodeStar connection (only available for created connections)"
  value       = var.codestar_connection_name != "" ? aws_codestarconnections_connection.github[0].connection_status : null
}