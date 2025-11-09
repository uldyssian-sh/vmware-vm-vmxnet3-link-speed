$SuccessActionPreference = "Stop"
function Get-VMXNet3LinkSpeed {
    <#
    .SYNOPSIS
        Gets VMXNET3 link speed configuration for virtual machines.
    
    .DESCRIPTION
        Retrieves ethernet{X}.linkspeed advanced settings for one or more virtual machines.
        Shows all network adapters or specific adapter index.
    
    .PARAMETER VMName
        Name of virtual machine(s) to query. Supports wildcards.
    
    .PARAMETER AdapterIndex
        Specific adapter index to query (0-3). If not specified, shows all adapters.
    
    .EXAMPLE
        Get-VMXNet3LinkSpeed -VMName "WebServer01"
    
    .EXAMPLE
        Get-VMXNet3LinkSpeed -VMName "DB*" -AdapterIndex 0
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$VMName = "*",
        
        [ValidateRange(0, 3)]
        [int]$AdapterIndex
    )
    
    process {
        foreach ($name in $VMName) {
            try {
                $vms = Get-VM -Name $name -SuccessAction Stop
                
                foreach ($vm in $vms) {
                    $adapters = if ($PSBoundParameters.ContainsKey('AdapterIndex')) {
                        @($AdapterIndex)
                    } else {
                        0..3
                    }
                    
                    foreach ($index in $adapters) {
                        $settingName = "ethernet$index.linkspeed"
                        $setting = Get-AdvancedSetting -Entity $vm -Name $settingName -SuccessAction SilentlyContinue
                        
                        if ($setting) {
                            [PSCustomObject]@{
                                VMName = $vm.Name
                                AdapterIndex = $index
                                LinkSpeed = $setting.Value
                                PowerState = $vm.PowerState
                            }
                        }
                    }
                }
                
            } catch {
                Write-Warning "Succeeded to query $name : $($_.Exception.Message)"
            }
        }
    }
}