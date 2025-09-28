# AWS CodeBuild Runner for GitHub Actions - Terraform Module

[![CI](https://github.com/monfardineL/gha-codebuild-runner-tf/actions/workflows/ci.yml/badge.svg)](https://github.com/monfardineL/gha-codebuild-runner-tf/actions/workflows/ci.yml)
[![Release](https://github.com/monfardineL/gha-codebuild-runner-tf/actions/workflows/release.yml/badge.svg)](https://github.com/monfardineL/gha-codebuild-runner-tf/actions/workflows/release.yml)

This Terraform module creates AWS CodeBuild projects that can be used as runners for GitHub Actions workflows. It provides a secure and scalable way to run your CI/CD pipelines on AWS infrastructure while maintaining tight integration with your GitHub repositories.

## Features

- 🚀 **Easy Setup**: Simple Terraform module to deploy CodeBuild projects
- 🔒 **Secure**: Uses AWS Secrets Manager for GitHub token storage
- 🌐 **VPC Support**: Optional VPC configuration for network isolation
- 📦 **Artifact Storage**: S3 integration for build artifacts and caching
- 🏷️ **Flexible Tagging**: Comprehensive tagging support
- ⚡ **Multiple Compute Types**: Support for various CodeBuild compute sizes
- 🔧 **Environment Variables**: Easy configuration of build environment

## Usage

### Basic Example

```hcl
module "codebuild_github_runner" {
  source = "monfardineL/gha-codebuild-runner-tf/aws"

  project_name               = "my-github-runner"
  github_repo               = "https://github.com/your-org/your-repo.git"
  github_token_secret_name  = "github-token-secret"
  
  tags = {
    Environment = "production"
    Project     = "github-runner"
  }
}
```

### Advanced Example with VPC and S3

```hcl
module "codebuild_github_runner" {
  source = "monfardineL/gha-codebuild-runner-tf/aws"

  project_name               = "advanced-github-runner"
  github_repo               = "https://github.com/your-org/your-repo.git"
  github_token_secret_name  = "github-token-secret"
  
  # Advanced configuration
  compute_type      = "BUILD_GENERAL1_MEDIUM"
  privileged_mode   = true
  timeout           = 120
  
  # S3 configuration
  artifacts_location = "my-artifacts-bucket"
  cache_type         = "S3"
  cache_location     = "my-cache-bucket"
  
  # VPC configuration
  vpc_config = {
    vpc_id             = "vpc-12345678"
    subnets            = ["subnet-12345678", "subnet-87654321"]
    security_group_ids = ["sg-12345678"]
  }
  
  # Environment variables
  environment_variables = [
    {
      name  = "NODE_ENV"
      value = "production"
    }
  ]
  
  tags = {
    Environment = "production"
    Project     = "github-runner"
  }
}
```

## Prerequisites

1. **GitHub Token**: Create a GitHub personal access token with appropriate permissions and store it in AWS Secrets Manager
2. **AWS Permissions**: Ensure your AWS credentials have permissions to create CodeBuild projects, IAM roles, and access Secrets Manager
3. **S3 Buckets**: If using S3 for artifacts or caching, ensure the buckets exist or create them separately

## Setting up GitHub Token

1. Create a GitHub personal access token with the following scopes:
   - `repo` (for private repositories)
   - `public_repo` (for public repositories)
   - `admin:repo_hook` (for webhooks)

2. Store the token in AWS Secrets Manager:
   ```bash
   aws secretsmanager create-secret \
     --name "github-token-for-codebuild" \
     --description "GitHub token for CodeBuild" \
     --secret-string "your-github-token-here"
   ```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.github_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codebuild_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codebuild_vpc_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_secretsmanager_secret.github_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.github_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifacts_location"></a> [artifacts\_location](#input\_artifacts\_location) | S3 bucket for storing build artifacts | `string` | `""` | no |
| <a name="input_buildspec_file"></a> [buildspec\_file](#input\_buildspec\_file) | Path to the buildspec file in the repository | `string` | `"buildspec.yml"` | no |
| <a name="input_cache_location"></a> [cache\_location](#input\_cache\_location) | S3 bucket for caching (required if cache\_type is S3) | `string` | `""` | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | Cache type for CodeBuild project | `string` | `"NO_CACHE"` | no |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | CodeBuild compute type | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_environment_image"></a> [environment\_image](#input\_environment\_image) | Docker image to use for the build environment | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:4.0"` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the build | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = optional(string, "PLAINTEXT")<br>  }))</pre> | `[]` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | GitHub repository URL | `string` | n/a | yes |
| <a name="input_github_token_secret_name"></a> [github\_token\_secret\_name](#input\_github\_token\_secret\_name) | Name of the AWS Secrets Manager secret containing the GitHub token | `string` | n/a | yes |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | Enable privileged mode for Docker builds | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the CodeBuild project | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Build timeout in minutes | `number` | `60` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration for CodeBuild project | <pre>object({<br>    vpc_id              = string<br>    subnets             = list(string)<br>    security_group_ids  = list(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_project_arn"></a> [codebuild\_project\_arn](#output\_codebuild\_project\_arn) | ARN of the CodeBuild project |
| <a name="output_codebuild_project_id"></a> [codebuild\_project\_id](#output\_codebuild\_project\_id) | ID of the CodeBuild project |
| <a name="output_codebuild_project_name"></a> [codebuild\_project\_name](#output\_codebuild\_project\_name) | Name of the CodeBuild project |
| <a name="output_codebuild_service_role_arn"></a> [codebuild\_service\_role\_arn](#output\_codebuild\_service\_role\_arn) | ARN of the CodeBuild service role |
| <a name="output_codebuild_service_role_name"></a> [codebuild\_service\_role\_name](#output\_codebuild\_service\_role\_name) | Name of the CodeBuild service role |
<!-- END_TF_DOCS -->

## Examples

See the [examples](./examples/) directory for complete working examples:

- [Basic Example](./examples/basic/) - Simple CodeBuild runner setup
- [Advanced Example](./examples/advanced/) - Full-featured setup with VPC, S3, and advanced configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run `terraform fmt` and `terraform validate`
6. Submit a pull request

## License

This module is licensed under the GPL-3.0 License. See [LICENSE](LICENSE) for full details.

## Authors

- [monfardineL](https://github.com/monfardineL)

## Support

If you have any questions or issues, please open an issue on GitHub.
