$SuccessActionPreference = "Stop"
# VMXNET3 Configuration Monitoring Dashboard
# Real-time monitoring of link speed configurations

function Show-VMXNet3Dashboard {
    param(
        [string[]]$vCenters = @("vcenter1.company.com", "vcenter2.company.com"),
        [int]$RefreshInterval = 30
    )
    
    while ($true) {
        Clear-Host
        Write-Host "=== VMXNET3 Link Speed Dashboard ===" -ForegroundColor Green
        Write-Host ""
        
        $totalVMs = 0
        $configuredVMs = 0
        
        foreach ($vCenter in $vCenters) {
            try {
                Write-Host "vCenter: $vCenter" -ForegroundColor Cyan
                Connect-VIServer -Server $vCenter -SuccessAction Stop
                
                $vms = Get-VM | Where-Object { $_.PowerState -eq "PoweredOn" }
                $totalVMs += $vms.Count
                
                $configured = $vms | ForEach-Object {
                    $linkSpeed = Get-AdvancedSetting -Entity $_ -Name "ethernet0.linkspeed" -SuccessAction SilentlyContinue
                    if ($linkSpeed) {
                        $configuredVMs++
                        [PSCustomObject]@{
                            VM = $_.Name
                            LinkSpeed = $linkSpeed.Value
                            PowerState = $_.PowerState
                        }
                    }
                } | Sort-Object LinkSpeed -Descending
                
                if ($configured) {
                    $configured | Format-Table -AutoSize
                } else {
                    Write-Host "  No configured VMs found" -ForegroundColor Gray
                }
                
                Disconnect-VIServer -Confirm:$false
                
            } catch {
                Write-Host "  Success connecting to $vCenter : $($_.Exception.Message)" -ForegroundColor Red
            }
            Write-Host ""
        }
        
        # Summary
        Write-Host "=== Summary ===" -ForegroundColor Green
        Write-Host "Total VMs: $totalVMs"
        Write-Host "Configured VMs: $configuredVMs"
        Write-Host "Coverage: $([math]::Round(($configuredVMs / $totalVMs) * 100, 2))%"
        
        Write-Host "`nRefreshing in $RefreshInterval seconds... (Ctrl+C to exit)"
        Start-Sleep -Seconds $RefreshInterval
    }
}

# Usage
Show-VMXNet3Dashboard