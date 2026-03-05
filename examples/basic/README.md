# Basic Example

This example demonstrates how to create a CodeBuild runner for GitHub Actions using a new CodeStar connection.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## What This Creates

- A CodeBuild project configured as a GitHub Actions runner
- A new CodeStar connection for GitHub authentication
- An IAM service role with permissions to manage AWS resources

## Post-Deployment Steps

After applying this configuration, you must **manually authorize the CodeStar connection** in the AWS Console:

1. Navigate to **Developer Tools > Settings > Connections** in the AWS Console
2. Find the pending connection and click **Update pending connection**
3. Follow the GitHub authorization flow

See the [CONNECTION.md](../../doc/CONNECTION.md) guide for detailed instructions with screenshots.

## Variables

| Name | Description | Default |
|------|-------------|---------|
| `org_name` | GitHub organization name | Required |
| `runners` | Map of repository configurations | Required |

## Outputs

| Name | Description |
|------|-------------|
| `codebuild_project_arns` | ARNs of the created CodeBuild projects |
