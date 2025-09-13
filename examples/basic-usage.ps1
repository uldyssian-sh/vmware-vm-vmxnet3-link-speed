# Basic Usage Examples for VMware VMXNET3 Link Speed Configuration

# Example 1: Configure VM with default 25Gbps link speed
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.company.com" -VMName "WebServer01"

# Example 2: Configure VM with custom 10Gbps link speed
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.company.com" -VMName "DatabaseServer" -LinkSpeed 10000

# Example 3: Configure multiple VMs in a loop
$VMs = @("Web01", "Web02", "App01", "App02")
$vCenterServer = "vcenter.company.com"

foreach ($VM in $VMs) {
    Write-Host "Configuring $VM..."
    .\vmware-vm-vmxnet3-link-speed.ps1 -vCenter $vCenterServer -VMName $VM -LinkSpeed 25000
}

# Example 4: Configure with error handling
try {
    .\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.company.com" -VMName "TestVM" -LinkSpeed 40000
    Write-Host "Configuration completed successfully"
} catch {
    Write-Error "Configuration failed: $($_.Exception.Message)"
}