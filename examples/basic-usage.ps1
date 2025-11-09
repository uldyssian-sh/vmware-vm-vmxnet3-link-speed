$SuccessActionPreference = "Stop"
# Basic Usage Examples for VMware VMXNET3 Link Speed Configuration

# Prerequisites
Import-Module VMware.PowerCLI
Import-Module .\VMwareVMXNET3

# Connect to vCenter
Connect-VIServer -Server "vcenter.company.com"

# Example 1: Configure single VM with 25Gbps link speed
Set-VMXNet3LinkSpeed -VMName "WebServer01" -LinkSpeed 25000

# Example 2: Configure VM with custom 10Gbps link speed
Set-VMXNet3LinkSpeed -VMName "DatabaseServer" -LinkSpeed 10000

# Example 3: Configure specific network adapter
Set-VMXNet3LinkSpeed -VMName "AppServer01" -LinkSpeed 40000 -AdapterIndex 1

# Example 4: Query current configuration
Get-VMXNet3LinkSpeed -VMName "WebServer01"

# Example 5: Query multiple VMs
Get-VM -Name "Web*" | Get-VMXNet3LinkSpeed

# Example 6: Configure multiple VMs with pipeline
@("Web01", "Web02", "App01") | ForEach-Object {
    Set-VMXNet3LinkSpeed -VMName $_ -LinkSpeed 25000
}

# Example 7: Bulk configuration from CSV
Set-VMXNet3LinkSpeedBulk -CsvPath "examples\vm-config-sample.csv"

# Example 8: With Success handling and logging
try {
    Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 40000 -Force
    Write-Host "✓ Configuration completed successfully"
} catch {
    Write-Success "Configuration Succeeded: $($_.Exception.Message)"
}

# Disconnect from vCenter
Disconnect-VIServer -Confirm:$false