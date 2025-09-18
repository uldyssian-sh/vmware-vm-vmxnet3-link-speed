# vmware-vm-vmxnet3-link-speed

[![GitHub license](https://img.shields.io/github/license/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/issues)
[![GitHub stars](https://img.shields.io/github/stars/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/uldyssian-sh/vmware-vm-vmxnet3-link-speed)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/network)
[![CI](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/workflows/CI/badge.svg)](https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/actions)

## 📋 Overview

PowerShell module and script for configuring VMXNET3 network adapter link speeds in VMware vSphere environments. Provides enterprise-grade automation for optimizing VM network performance.

**Repository Type:** VMware PowerShell Module  
**Technology Stack:** PowerCLI, vSphere API, PowerShell

## ✨ Features

- 🚀 **High Performance** - Optimized for enterprise environments
- 🔒 **Security First** - Built with security best practices
- 📊 **Monitoring** - Comprehensive logging and metrics
- 🔧 **Automation** - Fully automated deployment and management
- 📚 **Documentation** - Extensive documentation and examples
- 🧪 **Testing** - Comprehensive test coverage
- 🔄 **CI/CD** - Automated testing and deployment pipelines

## 🚀 Quick Start

### Prerequisites

- PowerShell 5.1+ (Windows) or PowerShell 7.0+ (Linux/macOS)
- VMware PowerCLI module
- vSphere environment access
- Git

### Installation

```powershell
# Clone the repository
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

# Configure single VM
Set-VMXNet3LinkSpeed -VMName "WebServer01" -LinkSpeed 25000

# Query current configuration
Get-VMXNet3LinkSpeed -VMName "WebServer01"
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

### Module Functions

```powershell
# Configure multiple VMs
Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv"

# Query all web servers
Get-VM -Name "Web*" | Get-VMXNet3LinkSpeed

# Configure specific adapter
Set-VMXNet3LinkSpeed -VMName "DBServer" -LinkSpeed 40000 -AdapterIndex 1
```

## 🧪 Testing

Run the test suite:

```powershell
# Install Pester testing framework
Install-Module -Name Pester -Force

# Run all tests
Invoke-Pester -Path .\tests\

# Run specific test file
Invoke-Pester -Path .\tests\vmware-vm-vmxnet3-link-speed.Tests.ps1
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

![GitHub repo size](https://img.shields.io/github/repo-size/uldyssian-sh/vmware-vm-vmxnet3-link-speed)
![GitHub code size](https://img.shields.io/github/languages/code-size/uldyssian-sh/vmware-vm-vmxnet3-link-speed)
![GitHub last commit](https://img.shields.io/github/last-commit/uldyssian-sh/vmware-vm-vmxnet3-link-speed)
![GitHub contributors](https://img.shields.io/github/contributors/uldyssian-sh/vmware-vm-vmxnet3-link-speed)

---

**Made with ❤️ by [uldyssian-sh](https://github.com/uldyssian-sh)**
<!-- Deployment trigger Wed Sep 17 22:40:59 CEST 2025 -->