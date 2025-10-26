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
