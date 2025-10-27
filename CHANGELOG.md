# 1.0.0 (2025-10-27)


### Bug Fixes

* **ci:** remove validate examples ([9c49d32](https://github.com/monfardineL/terraform-aws-gha-codebuild-runners/commit/9c49d321ccf0b6adff8fc66f7b6a61605a45e100))
* **CI:** update terraform version ([f7d6445](https://github.com/monfardineL/terraform-aws-gha-codebuild-runners/commit/f7d64450bdc79ab685a1a63502e68fb035c5bad1))


### Features

* Add complete Terraform module structure with CI/CD and Renovate ([79592c8](https://github.com/monfardineL/terraform-aws-gha-codebuild-runners/commit/79592c8a92efaf6f4e0119e04abb05e6cc7f1018))

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial release of AWS CodeBuild Runner for GitHub Actions Terraform module
- Security scanning with Checkov
- Automated documentation generation with terraform-docs
- Renovate configuration for dependency updates
- Semantic release configuration for automated versioning
- GitHub Actions workflows for CI/CD
- Basic and advanced usage examples

### Features

- Default very-permissive IAM Role
- Possibility to define a custom IAM Role
- Creation of a CodeStar Connection
- Possibility to reuse a existing CodeStar Connection
- Privileged mode support for Docker builds
- Possibility to customize settings per repository
