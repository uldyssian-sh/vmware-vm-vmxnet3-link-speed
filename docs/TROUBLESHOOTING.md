# Troubleshooting Guide

## Common Issues and Solutions

### 1. VM Not Found Error

**Error**: `VM 'VMName' not found.`

**Causes**:
- VM name is incorrect or case-sensitive
- VM is in a different datacenter/folder
- Insufficient permissions

**Solutions**:
```powershell
# List all VMs to verify name
Get-VM | Select-Object Name | Sort-Object Name

# Search for VM with partial name
Get-VM | Where-Object {$_.Name -like "*partial-name*"}

# Check current connection
$global:DefaultVIServer
```

### 2. PowerCLI Connection Issues

**Error**: `Connect-VIServer` fails

**Solutions**:
```powershell
# Test connectivity
Test-NetConnection -ComputerName "vcenter.company.com" -Port 443

# Connect with credentials
$credential = Get-Credential
Connect-VIServer -Server "vcenter.company.com" -Credential $credential

# Ignore certificate warnings
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
```

### 3. VM Shutdown Timeout

**Error**: VM doesn't power off within timeout period

**Solutions**:
- Increase timeout value in script
- Ensure VMware Tools are installed and running
- Use forced power off as last resort:

```powershell
# Force power off (use with caution)
Stop-VM -VM $vm -Confirm:$false
```

### 4. Permission Denied

**Error**: Insufficient privileges to perform operation

**Solutions**:
- Verify user has required permissions
- Check role assignments in vSphere Client
- Use account with administrator privileges for testing

### 5. Advanced Setting Already Exists

**Behavior**: Script reports setting already configured

**Verification**:
```powershell
# Check current value
$vm = Get-VM -Name "VMName"
Get-AdvancedSetting -Entity $vm -Name "ethernet0.linkspeed"

# Modify existing setting
$setting = Get-AdvancedSetting -Entity $vm -Name "ethernet0.linkspeed"
Set-AdvancedSetting -AdvancedSetting $setting -Value 10000 -Confirm:$false
```

### 6. Multiple Network Adapters

**Issue**: VM has multiple network adapters

**Solution**: Modify script to handle multiple adapters:
```powershell
# Check all ethernet adapters
for ($i = 0; $i -lt 4; $i++) {
    $param = Get-AdvancedSetting -Entity $vm -Name "ethernet$i.linkspeed" -ErrorAction SilentlyContinue
    if ($param) {
        Write-Output "ethernet$i.linkspeed = $($param.Value)"
    }
}
```

## Debugging Tips

### Enable Verbose Output
```powershell
# Run with verbose output
$VerbosePreference = "Continue"
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter" -VMName "VM" -Verbose
```

### Check VM Configuration
```powershell
# View VM advanced settings
$vm = Get-VM -Name "VMName"
Get-AdvancedSetting -Entity $vm | Where-Object {$_.Name -like "*ethernet*"}

# Check VM network adapters
$vm | Get-NetworkAdapter
```

### Validate Network Adapter Type
```powershell
# Ensure adapter is VMXNET3
$vm = Get-VM -Name "VMName"
$vm | Get-NetworkAdapter | Select-Object Name, Type
```

## Performance Considerations

### Link Speed Values
Common values for different network speeds:
- 1 Gbps: `1000`
- 10 Gbps: `10000`
- 25 Gbps: `25000`
- 40 Gbps: `40000`
- 100 Gbps: `100000`

### Best Practices
1. Test in non-production environment first
2. Document changes for compliance
3. Monitor VM performance after changes
4. Consider impact on vMotion and HA

## Getting Help

### Log Collection
```powershell
# Enable PowerCLI logging
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false
```

### Support Information
- VMware PowerCLI version: `Get-Module VMware.PowerCLI`
- PowerShell version: `$PSVersionTable`
- vSphere version: Check vCenter Server version# Updated 20251109_123833
# Updated Sun Nov  9 12:49:26 CET 2025
