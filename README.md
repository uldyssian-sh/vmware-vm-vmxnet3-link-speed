# vmware-vm-vmxnet3-link-speed

[![License](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/status-active-brightgreen?style=flat-square)](#)
[![Languages](https://img.shields.io/github/languages/count/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](#)
[![Size](https://img.shields.io/github/repo-size/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](#)
[![Security Scan](https://img.shields.io/badge/security-scanned-green?style=flat-square)](#)

[![License](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/status-active-brightgreen?style=flat-square)](#)
[![Languages](https://img.shields.io/github/languages/count/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](#)
[![Size](https://img.shields.io/github/repo-size/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](#)
[![Security Scan](https://img.shields.io/badge/security-scanned-green?style=flat-square)](#)

[![GitHub license](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/issues)
[![GitHub stars](https://img.shields.io/github/stars/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/network)
[![CI](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/workflows/CI/badge.svg)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/actions)

## 📋 Overview

Enterprise-grade PowerShell module for configuring VMXNET3 network adapter link speeds in VMware vSphere environments. Features comprehensive automation, bulk operations, and production-ready CI/CD pipeline.

**Repository Type:** VMware PowerShell Module  
**Technology Stack:** PowerCLI, vSphere API, PowerShell, Docker, GitHub Actions

## ✨ Features

- 🚀 **PowerShell Module** - VMwareVMXNET3 with 3 core functions
- 🔧 **Bulk Operations** - CSV-based mass configuration
- 📊 **Monitoring** - Real-time dashboard and reporting
- 🧪 **Testing** - 26+ Pester tests with full validation
- 🔒 **Security** - Automated scanning and verified commits
- 🔄 **CI/CD** - GitHub Actions with multi-stage validation
- 📚 **Documentation** - Complete guides and examples
- 🐳 **Docker** - PowerShell Core container support

## 🚀 Quick Start

### Prerequisites

- PowerShell 5.1+ (Windows) or PowerShell 7.0+ (Linux/macOS)
- VMware PowerCLI module
- vSphere environment access
- Git

### Installation

```powershell
# Clone the repository

[![License](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/status-active-brightgreen?style=flat-square)](#)
[![Languages](https://img.shields.io/github/languages/count/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](#)
[![Size](https://img.shields.io/github/repo-size/uldyssian-sh/vmware-vm-vmxnet3-link-speed?style=flat-square)](#)
[![Security Scan](https://img.shields.io/badge/security-scanned-green?style=flat-square)](#)
git clone https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed.git
cd vmware-vm-vmxnet3-link-speed

# Install VMware PowerCLI
Install-Module -Name VMware.PowerCLI -Scope CurrentUser

# Import the module
Import-Module .\VMwareVMXNET3
```

### Basic Usage

```powershell
# Connect to vCenter
Connect-VIServer -Server "vcenter.company.com"

# Configure single VM (25 Gbps)
Set-VMXNet3LinkSpeed -VMName "WebServer01" -LinkSpeed 25000

# Query current configuration
Get-VMXNet3LinkSpeed -VMName "WebServer01"

# Bulk configuration from CSV
Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv"
```

## 📖 Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Module Usage](docs/MODULE.md)
- [Examples](examples/)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🔧 Configuration

Configuration options:

1. **PowerCLI Settings** - Certificate validation, CEIP participation
2. **vCenter Connection** - Server, credentials, session management
3. **Link Speed Values** - 1000, 10000, 25000, 40000, 100000 Mbps

Example PowerCLI configuration:

```powershell
# Configure PowerCLI
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false
```

## 📊 Usage Examples

### Script Usage

```powershell
# Basic script execution
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.company.com" -VMName "WebServer01" -LinkSpeed 25000
```

### Advanced Usage

```powershell
# Configure specific network adapter
Set-VMXNet3LinkSpeed -VMName "DBServer" -LinkSpeed 40000 -AdapterIndex 1

# Query multiple VMs with pipeline
Get-VM -Name "Web*" | Get-VMXNet3LinkSpeed

# Bulk operations with logging
Set-VMXNet3LinkSpeedBulk -CsvPath "config.csv" -LogPath "deployment.log" -MaxConcurrent 5

# Force overwrite existing settings
Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 10000 -Force
```

## 🧪 Testing

**Test Coverage:** 26 tests across 3 test files

```powershell
# Install testing framework
Install-Module -Name Pester -Force

# Run all tests (26 tests)
Invoke-Pester -Path .\tests\

# Run specific test suite
Invoke-Pester -Path .\tests\VMwareVMXNET3.Tests.ps1

# Code quality analysis
Invoke-ScriptAnalyzer -Path . -Recurse
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

### Development Setup

```powershell
# Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/vmware-vm-vmxnet3-link-speed.git
cd vmware-vm-vmxnet3-link-speed

# Install required modules
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
Install-Module -Name Pester -Scope CurrentUser
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser

# Import the module for development
Import-Module .\VMwareVMXNET3 -Force
```

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to your branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📧 **Email**: [Create an issue](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/issues/new)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/discussions)
- 🐛 **Bug Reports**: [Issue Tracker](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/issues)

## 🙏 Acknowledgments

- VMware Community
- Open Source Contributors
- Enterprise Automation Teams
- Security Research Community

## 📈 Project Stats

- **Module Functions:** 3 (Set, Get, Bulk)
- **Test Coverage:** 26 tests
- **CI/CD Stages:** 3 (Validation, Security, Documentation)
- **Supported Speeds:** 100 Mbps - 100 Gbps
- **Docker Support:** ✅ PowerShell Core
- **GitHub Free Tier:** ✅ Optimized


---


<!-- Deployment trigger Wed Sep 17 22:40:59 CEST 2025 -->
## Support

- **Issues**: [GitHub Issues](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/issues)
- **Security**: [Security Policy](SECURITY.md)
- **Contributing**: [Contributing Guidelines](CONTRIBUTING.md)

---

**⭐ Star this repository if you find it helpful!**
