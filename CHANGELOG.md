# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of AWS CodeBuild Runner for GitHub Actions Terraform module
- Support for multiple compute types (SMALL, MEDIUM, LARGE, 2XLARGE)
- VPC configuration support for network isolation
- S3 integration for artifacts and caching
- Comprehensive environment variable configuration
- Security scanning with Checkov
- Automated documentation generation with terraform-docs
- Renovate configuration for dependency updates
- Semantic release configuration for automated versioning
- GitHub Actions workflows for CI/CD
- Basic and advanced usage examples

### Features
- Secure GitHub token management via AWS Secrets Manager
- Flexible caching options (NO_CACHE, S3, LOCAL)
- Privileged mode support for Docker builds
- Comprehensive tagging support
- Build timeout configuration
- Custom buildspec file support
- IAM role and policy management