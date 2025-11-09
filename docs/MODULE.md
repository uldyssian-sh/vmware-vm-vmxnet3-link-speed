# PowerShell Module Usage

## Overview

The VMwareVMXNET3 PowerShell module provides advanced functionality for managing VMXNET3 network adapter link speeds in VMware environments.

## Installation

### From Repository
```powershell
# Clone and import module
git clone https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed.git
Import-Module .\vmware-vm-vmxnet3-link-speed\VMwareVMXNET3
```

### Manual Installation
```powershell
# Copy module to PowerShell modules directory
$modulePath = "$env:USERPROFILE\Documents\PowerShell\Modules\VMwareVMXNET3"
Copy-Item -Path ".\VMwareVMXNET3" -Destination $modulePath -Recurse

# Import module
Import-Module VMwareVMXNET3
```

## Functions

### Set-VMXNet3LinkSpeed

Configure link speed for a single VM network adapter.

```powershell
# Basic usage
Set-VMXNet3LinkSpeed -VMName "WebServer01" -LinkSpeed 25000

# Specific adapter
Set-VMXNet3LinkSpeed -VMName "DBServer" -LinkSpeed 40000 -AdapterIndex 1

# Force overwrite existing setting
Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 10000 -Force
```

**Parameters:**
- `VMName` - Virtual machine name
- `LinkSpeed` - Speed in Mbps (100-100000)
- `AdapterIndex` - Network adapter index (0-3, default: 0)
- `Force` - Overwrite existing settings

### Get-VMXNet3LinkSpeed

Query current link speed configurations.

```powershell
# Single VM
Get-VMXNet3LinkSpeed -VMName "WebServer01"

# Multiple VMs with wildcards
Get-VMXNet3LinkSpeed -VMName "Web*"

# Specific adapter only
Get-VMXNet3LinkSpeed -VMName "DBServer" -AdapterIndex 0

# All VMs
Get-VM | Get-VMXNet3LinkSpeed
```

**Output:**
```
VMName       AdapterIndex LinkSpeed PowerState
------       ------------ --------- ----------
WebServer01  0            25000     PoweredOn
WebServer02  0            25000     PoweredOn
```

### Set-VMXNet3LinkSpeedBulk

Configure multiple VMs from CSV file.

```powershell
# Basic bulk operation
Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv"

# With custom concurrency and logging
Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv" -MaxConcurrent 5 -LogPath "bulk-op.log"
```

**CSV Format:**
```csv
VMName,LinkSpeed,AdapterIndex
WebServer01,10000,0
WebServer02,10000,0
AppServer01,25000,0
DBServer01,40000,0
```

## Advanced Examples

### Pipeline Operations
```powershell
# Configure all web servers
Get-VM -Name "Web*" | ForEach-Object {
    Set-VMXNet3LinkSpeed -VMName $_.Name -LinkSpeed 10000
}

# Query and export configuration
Get-VM | Get-VMXNet3LinkSpeed | Export-Csv -Path "current-config.csv" -NoTypeInformation
```

### Conditional Configuration
```powershell
# Configure based on VM role
$vmRoles = @{
    "Web*" = 10000
    "App*" = 25000
    "DB*" = 40000
}

foreach ($pattern in $vmRoles.Keys) {
    Get-VM -Name $pattern | ForEach-Object {
        Set-VMXNet3LinkSpeed -VMName $_.Name -LinkSpeed $vmRoles[$pattern]
    }
}
```

### Error Handling
```powershell
# Robust bulk configuration
$vms = @("VM1", "VM2", "VM3")
$results = foreach ($vm in $vms) {
    try {
        Set-VMXNet3LinkSpeed -VMName $vm -LinkSpeed 25000 -ErrorAction Stop
        [PSCustomObject]@{VM = $vm; Status = "Success"; Error = $null}
    } catch {
        [PSCustomObject]@{VM = $vm; Status = "Failed"; Error = $_.Exception.Message}
    }
}

$results | Format-Table -AutoSize
```

## Integration with PowerCLI

### Session Management
```powershell
# Connect to vCenter
Connect-VIServer -Server "vcenter.company.com"

# Use module functions
Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 25000

# Disconnect
Disconnect-VIServer -Confirm:$false
```

### Batch Processing with vCenter Sessions
```powershell
# Process multiple vCenter servers
$vCenters = @("vcenter1.company.com", "vcenter2.company.com")

foreach ($vCenter in $vCenters) {
    Connect-VIServer -Server $vCenter

    # Configure VMs in this vCenter
    Set-VMXNet3LinkSpeedBulk -CsvPath "config-$($vCenter.Split('.')[0]).csv"

    Disconnect-VIServer -Confirm:$false
}
```

## Performance Considerations

### Parallel Processing
The bulk function uses PowerShell's parallel processing:

```powershell
# Adjust concurrency based on environment
Set-VMXNet3LinkSpeedBulk -CsvPath "large-config.csv" -MaxConcurrent 2  # Conservative
Set-VMXNet3LinkSpeedBulk -CsvPath "small-config.csv" -MaxConcurrent 8  # Aggressive
```

### Monitoring Progress
```powershell
# Custom progress tracking
$vms = Get-VM -Name "Test*"
$total = $vms.Count
$current = 0

foreach ($vm in $vms) {
    $current++
    Write-Progress -Activity "Configuring VMs" -Status "$current of $total" -PercentComplete (($current / $total) * 100)
    Set-VMXNet3LinkSpeed -VMName $vm.Name -LinkSpeed 25000
}
```

## Troubleshooting

### Common Issues

**Module not found:**
```powershell
# Check module path
$env:PSModulePath -split ';'

# Import with full path
Import-Module "C:\Path\To\VMwareVMXNET3" -Force
```

**PowerCLI not available:**
```powershell
# Install PowerCLI
Install-Module -Name VMware.PowerCLI -Scope CurrentUser

# Verify installation
Get-Module -Name VMware.VimAutomation.Core -ListAvailable
```

**Permission errors:**
```powershell
# Check vCenter connection
Get-VIServer

# Verify VM permissions
$vm = Get-VM -Name "TestVM"
Get-VIPermission -Entity $vm
```# Updated 20251109_123833
