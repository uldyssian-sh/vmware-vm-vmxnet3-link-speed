# VMware VMXNET3 Link Speed Configurator

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue)](https://github.com/PowerShell/PowerShell)
[![VMware](https://img.shields.io/badge/VMware-vSphere%207%20%7C%208-orange)](https://www.vmware.com/products/vsphere.html)
[![CI](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/actions/workflows/ci.yml/badge.svg)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/actions/workflows/ci.yml)
[![Docker](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/actions/workflows/docker.yml/badge.svg)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/actions/workflows/docker.yml)
[![Release](https://img.shields.io/github/v/release/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/releases)
[![Downloads](https://img.shields.io/github/downloads/uldyssian-sh/vmware-vm-vmxnet3-link-speed/total)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/releases)
[![Stars](https://img.shields.io/github/stars/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/stargazers)
[![Status](https://img.shields.io/badge/Status-Active-success)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed)

A PowerShell tool for configuring VMXNET3 network adapter link speed in VMware virtual machines using the advanced VMX parameter `ethernet0.linkspeed`.

> **Author**: LT - [GitHub Profile](https://github.com/uldyssian-sh) · **Version**: 1.0 · **License**: MIT

---

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Documentation](#documentation)
- [Requirements & Permissions](#requirements--permissions)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

---

## Overview
VMXNET3 does not expose a traditional "link speed" like physical NICs; however, vSphere supports an **advanced VMX parameter** `ethernet0.linkspeed` that can be configured for testing/lab purposes. This tool helps you **inspect and set** that parameter safely.

> ⚠️ **Note:** This is primarily for **lab/testing**. Production changes should follow your org's change management and vendor guidance.

---

## Features
- **PowerShell Module**: Advanced cmdlets for enterprise use
- **Multiple Adapters**: Support for ethernet0-ethernet3 configuration
- **Bulk Operations**: CSV-based mass configuration with parallel processing
- **Pipeline Support**: Full PowerShell pipeline integration
- **Graceful Power Management**: Automatic VM shutdown/startup
- **Comprehensive Logging**: Detailed operation logs and error handling
- **Cross-Platform**: Works on Windows, Linux, and macOS
- **Automated Testing**: Full test suite with Pester and PSScriptAnalyzer

---

## Quick Start

### PowerShell Module (Recommended)
```powershell
# Clone and import module
git clone https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed.git
Import-Module .\vmware-vm-vmxnet3-link-speed\VMwareVMXNET3

# Connect to vCenter
Connect-VIServer -Server "vcenter.company.com"

# Configure single VM
Set-VMXNet3LinkSpeed -VMName "MyVM" -LinkSpeed 25000

# Bulk configuration from CSV
Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv"
```

### Legacy Script
```powershell
# Run the original script
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.company.com" -VMName "MyVM"
```

## Installation

For detailed installation instructions, see [Installation Guide](docs/INSTALLATION.md).

---

## Usage

### PowerShell Module Usage
```powershell
# Single VM configuration
Set-VMXNet3LinkSpeed -VMName "WebServer01" -LinkSpeed 25000

# Multiple network adapters
Set-VMXNet3LinkSpeed -VMName "DBServer" -LinkSpeed 40000 -AdapterIndex 1

# Query current configuration
Get-VMXNet3LinkSpeed -VMName "Web*"

# Bulk configuration from CSV
Set-VMXNet3LinkSpeedBulk -CsvPath "examples/vm-config-template.csv"
```

### Legacy Script Usage
```powershell
# Original script method
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.company.com" -VMName "WebServer01"
```

---

## Examples

### Single VM Configuration
```powershell
# Configure single VM
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.lab.local" -VMName "TestVM" -LinkSpeed 25000
```

### Batch Configuration
```powershell
# Configure multiple VMs
$VMs = @("Web01", "Web02", "App01")
foreach ($VM in $VMs) {
    .\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.lab.local" -VMName $VM -LinkSpeed 10000
}
```

More examples available in the [examples](examples/) directory.

---

## Documentation

- [PowerShell Module Guide](docs/MODULE.md) - Advanced module usage and examples
- [Installation Guide](docs/INSTALLATION.md) - Detailed setup instructions
- [Performance Guide](docs/PERFORMANCE.md) - Optimization and best practices
- [Security Guide](docs/SECURITY.md) - Security considerations and compliance
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Examples](examples/) - Usage examples and CSV templates
- [Contributing](CONTRIBUTING.md) - How to contribute to the project
- [Changelog](CHANGELOG.md) - Version history and changes

---

## Requirements & Permissions

### System Requirements
- PowerShell 5.1+ (Windows) or PowerShell 7+ (cross-platform)
- VMware PowerCLI module
- Network connectivity to vCenter Server or ESXi host

### Required Permissions
- **Read permissions** on target virtual machines
- **Virtual machine configuration** > **Change Settings**
- **Virtual machine interaction** > **Power On/Off**

### Safety Considerations
- Script will gracefully shutdown VM before making changes
- Only modifies VMs that don't already have the setting configured
- Includes timeout handling for shutdown operations
- Test in non-production environment first

---

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on:
- Code of conduct
- Development setup
- Testing requirements
- Pull request process

### Development
```powershell
# Install development dependencies
Install-Module -Name Pester -Scope CurrentUser
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser

# Run tests
Invoke-Pester -Path tests

# Run code analysis
Invoke-ScriptAnalyzer -Path . -Settings ./.config/PSScriptAnalyzerSettings.psd1 -Recurse
```

---

## Support

If you encounter issues:
1. Check the [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
2. Search [existing issues](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/issues)
3. Create a [new issue](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/issues/new) with detailed information

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- VMware PowerCLI team for the excellent PowerShell modules
- VMware community for best practices and guidance
- Contributors who help improve this tool

---

**⚠️ Important**: This tool is designed for lab and testing environments. Always test thoroughly before using in production and follow your organization's change management procedures.
