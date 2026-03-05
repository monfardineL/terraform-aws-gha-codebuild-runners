# AWS CodeBuild Runner for GitHub Actions

[![CI](https://github.com/monfardineL/terraform-aws-gha-codebuild-runners/actions/workflows/ci.yaml/badge.svg)](https://github.com/monfardineL/terraform-aws-gha-codebuild-runners/actions/workflows/ci.yaml)
[![Release](https://github.com/monfardineL/terraform-aws-gha-codebuild-runners/actions/workflows/release.yaml/badge.svg)](https://github.com/monfardineL/terraform-aws-gha-codebuild-runners/actions/workflows/release.yaml)

This Terraform module creates AWS CodeBuild projects that can be used as runners for GitHub Actions workflows. It provides a secure and scalable way to run your CI/CD pipelines on AWS infrastructure while maintaining tight integration with your GitHub repositories.

## Usage

### Basic Example

```hcl
module "codebuild-runners" {
  source  = "monfardineL/gha-codebuild-runners/aws"
  version = "~> 1.0"

  org_name                 = "myorg"
  create_iam_policy        = true
  codestar_connection_name = "github-myorg"

  runners = {
    "my-repo" = {
      compute_type = "BUILD_GENERAL1_SMALL"
      image        = "aws/codebuild/amazonlinux-aarch64-standard:3.0"
      type         = "ARM_CONTAINER"
    }
  }
}
```

### IAM Policy

By default, the module creates an IAM role with broad permissions to allow CodeBuild runners to manage AWS resources (useful for infrastructure-as-code pipelines like Terraform). This behavior is controlled by the `create_iam_policy` variable:

- **`create_iam_policy = true`** (default): Creates a service role with extensive permissions including EC2, S3, IAM, Lambda, ECS, and many other AWS services. This is suitable for runners that need to deploy infrastructure.

- **`create_iam_policy = false`**: Skips IAM role creation. You must provide your own IAM role ARN via `codebuild_iam_policy_arn`. Use this when you need fine-grained access control:

```hcl
module "codebuild-runners" {
  source  = "monfardineL/gha-codebuild-runners/aws"
  version = "~> 1.0"

  org_name                 = "myorg"
  create_iam_policy        = false
  codebuild_iam_policy_arn = aws_iam_role.custom_codebuild_role.arn
  codestar_connection_name = "github-myorg"

  runners = {
    "my-app" = {}
  }
}
```

> **⚠️ Security Note**: The default IAM policy grants extensive permissions. For production use, consider providing a custom role with least-privilege permissions tailored to your specific pipeline needs.

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.18 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.github_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.codeconnection_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_webhook.github_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook) | resource |
| [aws_codestarconnections_connection.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_iam_role.codebuild_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild_service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codebuild_iam_policy_arn"></a> [codebuild\_iam\_policy\_arn](#input\_codebuild\_iam\_policy\_arn) | The ARN of the IAM Policy to attach to the CodeBuild project's role. Only required if 'create\_iam\_policy' is false. | `string` | `""` | no |
| <a name="input_codestar_connection_arn"></a> [codestar\_connection\_arn](#input\_codestar\_connection\_arn) | The ARN of an existing CodeStar Connection to use for GitHub authentication. Mutually exclusive with 'codestar\_connection\_name'. | `string` | `""` | no |
| <a name="input_codestar_connection_name"></a> [codestar\_connection\_name](#input\_codestar\_connection\_name) | The name for a new CodeStar connection to create. Mutually exclusive with 'codestar\_connection\_arn'. | `string` | `""` | no |
| <a name="input_create_iam_policy"></a> [create\_iam\_policy](#input\_create\_iam\_policy) | If the module should create the IAM Policy for the CodeBuild project. If false, you must provide the policy ARN via the 'codebuild\_iam\_policy\_arn' variable. Default is true. | `bool` | `true` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | The name of the GitHub organization where the CodeBuild runners will be used. | `string` | n/a | yes |
| <a name="input_runners"></a> [runners](#input\_runners) | A map of runner configurations keyed by repository name, each specifying compute type, image, and environment type. Repository name is the map key. | <pre>map(object({<br/>    compute_type = optional(string, "BUILD_GENERAL1_SMALL")<br/>    image        = optional(string, "aws/codebuild/amazonlinux-aarch64-standard:3.0")<br/>    type         = optional(string, "ARM_CONTAINER")<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_project_arns"></a> [codebuild\_project\_arns](#output\_codebuild\_project\_arns) | Map of CodeBuild project ARNs keyed by repository name |
| <a name="output_codebuild_project_names"></a> [codebuild\_project\_names](#output\_codebuild\_project\_names) | Map of CodeBuild project names keyed by repository name |
| <a name="output_codestar_connection_arn"></a> [codestar\_connection\_arn](#output\_codestar\_connection\_arn) | The ARN of the CodeStar connection (either created or provided) |
| <a name="output_codestar_connection_status"></a> [codestar\_connection\_status](#output\_codestar\_connection\_status) | The status of the CodeStar connection (only available for created connections) |
<!-- END_TF_DOCS -->

## Examples

See the [examples](./examples/) directory for complete working examples:

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
