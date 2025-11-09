# Installation Guide

## Prerequisites

### PowerShell Requirements
- **Windows**: PowerShell 5.1 or later
- **Linux/macOS**: PowerShell 7.0 or later

### VMware PowerCLI
Install VMware PowerCLI module:

```powershell
# Install for current user (recommended)
Install-Module -Name VMware.PowerCLI -Scope CurrentUser

# Install system-wide (requires admin privileges)
Install-Module -Name VMware.PowerCLI -Scope AllUsers
```

### vSphere Permissions
The user account needs the following permissions:
- **Read permissions** on the target VM
- **Virtual machine configuration** > **Change Settings** permission
- **Virtual machine interaction** > **Power On/Off** permissions

## Installation Steps

### Method 1: Git Clone
```bash
git clone https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed.git
cd vmware-vm-vmxnet3-link-speed
```

### Method 2: Download ZIP
1. Download the ZIP file from GitHub
2. Extract to your desired location
3. Navigate to the extracted folder

## Verification

Test the installation:
```powershell
# Check PowerCLI installation
Get-Module -Name VMware.PowerCLI -ListAvailable

# Test script syntax
Get-Content .\vmware-vm-vmxnet3-link-speed.ps1 | Out-Null
```

## Configuration

### PowerCLI Configuration
Configure PowerCLI for your environment:

```powershell
# Set PowerCLI configuration
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false
```

### Execution Policy
If you encounter execution policy issues:

```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy for current user (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Troubleshooting

### Common Issues

1. **PowerCLI not found**
   - Ensure VMware.PowerCLI module is installed
   - Restart PowerShell session after installation

2. **Execution policy restrictions**
   - Set appropriate execution policy
   - Use `-ExecutionPolicy Bypass` parameter when running

3. **Certificate errors**
   - Configure PowerCLI to ignore invalid certificates
   - Or properly configure SSL certificates in your environment# Updated 20251109_123833
# Updated Sun Nov  9 12:49:26 CET 2025
# Updated Sun Nov  9 12:52:37 CET 2025
