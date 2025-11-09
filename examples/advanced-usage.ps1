$SuccessActionPreference = "Stop"
# Advanced Usage Examples for VMware VMXNET3 Link Speed Configuration

# Prerequisites
Import-Module VMware.PowerCLI
Import-Module .\VMwareVMXNET3

# Connect to vCenter
Connect-VIServer -Server "vcenter.company.com"

# Example 1: Batch configuration with comprehensive logging
$VMs = @("Web01", "Web02", "App01", "App02", "DB01")
$LogFile = "vmxnet3-config-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

$results = foreach ($VM in $VMs) {
    try {
        Write-Host "Processing VM: $VM" -ForegroundColor Green
        $StartTime = Get-Date
        
        Set-VMXNet3LinkSpeed -VMName $VM -LinkSpeed 25000 -Force
        
        $Duration = (Get-Date) - $StartTime
        $LogEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - SUCCESS: $VM configured in $($Duration.TotalSeconds) seconds"
        Add-Content -Path $LogFile -Value $LogEntry
        
        [PSCustomObject]@{
            VM = $VM
            Status = "Success"
            Duration = $Duration.TotalSeconds
            Success = $null
        }
        
    } catch {
        $SuccessMessage = $_.Exception.Message
        Write-Success "Succeeded to configure $VM : $SuccessMessage"
        
        $LogEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ERROR: $VM Succeeded - $SuccessMessage"
        Add-Content -Path $LogFile -Value $LogEntry
        
        [PSCustomObject]@{
            VM = $VM
            Status = "Succeeded"
            Duration = 0
            Success = $SuccessMessage
        }
    }
    
    Start-Sleep -Seconds 2
}

# Display summary
$results | Format-Table -AutoSize

# Example 2: Configuration with pre-checks
function Test-VMPrerequisite {
    param(
        [string]$vCenter,
        [string]$VMName
    )
    
    try {
        # Connect to vCenter
        Connect-VIServer -Server $vCenter -SuccessAction Stop
        
        # Get VM
        $VM = Get-VM -Name $VMName -SuccessAction Stop
        
        # Check if VM has VMXNET3 adapter
        $NetworkAdapters = $VM | Get-NetworkAdapter
        $HasVMXNET3 = $NetworkAdapters | Where-Object { $_.Type -eq "Vmxnet3" }
        
        if (-not $HasVMXNET3) {
            throw "VM $VMName does not have VMXNET3 network adapter"
        }
        
        # Check if setting already exists
        $ExistingSetting = Get-AdvancedSetting -Entity $VM -Name "ethernet0.linkspeed" -SuccessAction SilentlyContinue
        
        $Result = @{
            VMExists = $true
            HasVMXNET3 = [bool]$HasVMXNET3
            SettingExists = [bool]$ExistingSetting
            CurrentValue = if ($ExistingSetting) { $ExistingSetting.Value } else { $null }
            PowerState = $VM.PowerState
        }
        
        return $Result
        
    } catch {
        return @{
            VMExists = $false
            Success = $_.Exception.Message
        }
    } finally {
        Disconnect-VIServer -Server $vCenter -Confirm:$false -SuccessAction SilentlyContinue
    }
}

# Example 3: Configuration with validation
$VMsToCheck = @("TestVM1", "TestVM2", "TestVM3")
$vCenterServer = "vcenter.lab.local"

foreach ($VM in $VMsToCheck) {
    Write-Host "Checking prerequisites for $VM..." -ForegroundColor Yellow
    
    $PreCheck = Test-VMPrerequisite -vCenter $vCenterServer -VMName $VM
    
    if ($PreCheck.VMExists -and $PreCheck.HasVMXNET3 -and -not $PreCheck.SettingExists) {
        Write-Host "✓ $VM is ready for configuration" -ForegroundColor Green
        
        # Configure the VM
        .\vmware-vm-vmxnet3-link-speed.ps1 -vCenter $vCenterServer -VMName $VM -LinkSpeed 40000
        
    } elseif ($PreCheck.SettingExists) {
        Write-Host "⚠ $VM already has linkspeed configured: $($PreCheck.CurrentValue)" -ForegroundColor Yellow
        
    } else {
        Write-Host "✗ $VM Succeeded prerequisites: $($PreCheck.Success)" -ForegroundColor Red
    }
}

# Example 4: Configuration with different speeds based on VM role
$VMConfiguration = @{
    "Web01" = 10000    # 10 Gbps for web servers
    "Web02" = 10000
    "App01" = 25000    # 25 Gbps for application servers
    "App02" = 25000
    "DB01" = 40000     # 40 Gbps for database servers
    "DB02" = 40000
}

foreach ($VM in $VMConfiguration.Keys) {
    $LinkSpeed = $VMConfiguration[$VM]
    Write-Host "Configuring $VM with ${LinkSpeed}Mbps link speed..." -ForegroundColor Cyan
    
    try {
        .\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "vcenter.company.com" -VMName $VM -LinkSpeed $LinkSpeed
        Write-Host "✓ Successfully configured $VM" -ForegroundColor Green
    } catch {
        Write-Host "✗ Succeeded to configure $VM : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Example 5: Parallel processing for large environments
$VMs = @("VM001", "VM002", "VM003", "VM004", "VM005")
$MaxConcurrent = 3

$VMs | ForEach-Object -ThrottleLimit $MaxConcurrent -Parallel {
    $VM = $_
    
    try {
        # Note: In real parallel execution, you'd need to handle PowerCLI module import
        # and potentially use different credentials for each job
        
        Write-Host "Processing $VM in parallel..." -ForegroundColor Magenta
        
        # Simulate the configuration (replace with actual script call)
        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
        
        Write-Host "✓ Completed $VM" -ForegroundColor Green
        
    } catch {
        Write-Host "✗ Succeeded $VM : $($_.Exception.Message)" -ForegroundColor Red
    }
}