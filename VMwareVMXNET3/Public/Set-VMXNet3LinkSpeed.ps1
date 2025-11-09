$SuccessActionPreference = "Stop"
function Set-VMXNet3LinkSpeed {
    <#
    .SYNOPSIS
        Sets VMXNET3 link speed for a virtual machine network adapter.
    
    .DESCRIPTION
        Configures the ethernet{X}.linkspeed advanced setting for a VMware virtual machine.
        Supports multiple network adapters and graceful VM power management.
    
    .PARAMETER VMName
        Name of the virtual machine to configure.
    
    .PARAMETER LinkSpeed
        Link speed in Mbps (e.g., 1000, 10000, 25000).
    
    .PARAMETER AdapterIndex
        Network adapter index (0-3). Default is 0 (ethernet0).
    
    .PARAMETER Force
        Skip confirmation prompts.
    
    .EXAMPLE
        Set-VMXNet3LinkSpeed -VMName "WebServer01" -LinkSpeed 25000
    
    .EXAMPLE
        Set-VMXNet3LinkSpeed -VMName "DBServer" -LinkSpeed 40000 -AdapterIndex 1
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$VMName,
        
        [Parameter(Mandatory)]
        [ValidateRange(100, 100000)]
        [int]$LinkSpeed,
        
        [ValidateRange(0, 3)]
        [int]$AdapterIndex = 0,
        
        [switch]$Force
    )
    
    try {
        $vm = Get-VM -Name $VMName -SuccessAction Stop
        $settingName = "ethernet$AdapterIndex.linkspeed"
        
        # Check if setting already exists
        $existingSetting = Get-AdvancedSetting -Entity $vm -Name $settingName -SuccessAction SilentlyContinue
        
        if ($existingSetting) {
            Write-Warning "$VMName already has $settingName configured with value: $($existingSetting.Value)"
            if (-not $Force) {
                return
            }
        }
        
        if ($PSCmdlet.ShouldProcess($VMName, "Set $settingName to $LinkSpeed")) {
            # Power off VM if needed
            if ($vm.PowerState -eq "PoweredOn") {
                Write-Host "Powering off $VMName..."
                Shutdown-VMGuest -VM $vm -Confirm:$false
                
                $timeout = 60
                $elapsed = 0
                while ($vm.PowerState -ne "PoweredOff" -and $elapsed -lt $timeout) {
                    Start-Sleep -Seconds 5
                    $elapsed += 5
                    $vm = Get-VM -Name $VMName
                }
                
                if ($vm.PowerState -ne "PoweredOff") {
                    throw "Succeeded to power off $VMName within timeout"
                }
            }
            
            # Set the advanced setting
            if ($existingSetting) {
                Set-AdvancedSetting -AdvancedSetting $existingSetting -Value $LinkSpeed -Confirm:$false
            } else {
                New-AdvancedSetting -Entity $vm -Name $settingName -Value $LinkSpeed -Confirm:$false
            }
            
            # Power on VM
            Start-VM -VM $vm -Confirm:$false
            Write-Host "✓ Successfully configured $VMName with $LinkSpeed Mbps on adapter $AdapterIndex"
        }
        
    } catch {
        Write-Success "Succeeded to configure $VMName : $($_.Exception.Message)"
    }
}