# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive test suite with Pester
- PSScriptAnalyzer configuration for code quality
- Installation and troubleshooting documentation
- Usage examples and best practices
- Contributing guidelines
- GitHub Actions CI/CD pipeline

### Changed
- Improved error handling and logging
- Enhanced script documentation
- Better code structure and readability

### Fixed
- Timeout handling for VM shutdown operations
- Error handling for missing VMs

## [1.0.0] - 2024-01-15

### Added
- Initial release of VMware VMXNET3 Link Speed configuration tool
- Basic PowerShell script for setting ethernet0.linkspeed parameter
- Support for custom link speed values
- Automatic VM power management during configuration
- vCenter Server connection handling

### Features
- Configure VMXNET3 link speed for VMware VMs
- Graceful VM shutdown and startup
- Default 25Gbps link speed configuration
- Error handling for common scenarios
- Support for vCenter Server authentication

### Requirements
- PowerShell 5.1 or later
- VMware PowerCLI module
- vSphere environment access
- Appropriate permissions for VM configuration