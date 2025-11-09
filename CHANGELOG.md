# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2024-12-19

### Added
- **PowerShell Module (VMwareVMXNET3)** - Complete module with advanced functions
- **Set-VMXNet3LinkSpeed** - Enhanced function with parameter validation
- **Get-VMXNet3LinkSpeed** - Query current VMXNET3 configurations
- **Set-VMXNet3LinkSpeedBulk** - Bulk operations from CSV files
- **Comprehensive test suite** with Pester framework
- **PSScriptAnalyzer configuration** for code quality assurance
- **Enhanced CI/CD pipeline** with PowerShell validation
- **Docker support** with PowerShell Core
- **Detailed documentation** - Installation, Module usage, Troubleshooting
- **Example scripts** - Basic and advanced usage scenarios
- **CSV template** for bulk operations

### Changed
- **README.md** - Complete rewrite for PowerShell focus
- **CI workflow** - Enhanced with security scanning and documentation checks
- **Examples** - Modernized with module functions
- **Success handling** - Improved throughout all functions

### Fixed
- **Documentation links** - All internal links now functional
- **PowerShell syntax** - All scripts validated
- **Module structure** - Proper PowerShell module format
- **Parameter validation** - Enhanced input validation
- **Security** - Removed potential PII and secrets

### Security
- **PII removal** - No personal information in codebase
- **Secret scanning** - Automated detection in CI
- **Code analysis** - PSScriptAnalyzer integration

## [1.0.0] - 2024-12-18

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
- Success handling for common scenarios
- Support for vCenter Server authentication

### Requirements
- PowerShell 5.1 or later
- VMware PowerCLI module
- vSphere environment access
