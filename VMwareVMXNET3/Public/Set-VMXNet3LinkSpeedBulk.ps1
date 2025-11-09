$SuccessActionPreference = "Stop"
function Set-VMXNet3LinkSpeedBulk {
    <#
    .SYNOPSIS
        Configures VMXNET3 link speeds for multiple VMs from CSV file.
    
    .DESCRIPTION
        Processes a CSV file containing VM configurations and applies VMXNET3 link speed settings
        to multiple virtual machines. Supports parallel processing for improved performance.
    
    .PARAMETER CsvPath
        Path to CSV file containing VM configurations.
        CSV format: VMName,LinkSpeed,AdapterIndex
    
    .PARAMETER MaxConcurrent
        Maximum number of concurrent operations. Default is 3.
    
    .PARAMETER LogPath
        Optional path for detailed logging.
    
    .PARAMETER Force
        Skip confirmation prompts for all operations.
    
    .EXAMPLE
        Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv"
    
    .EXAMPLE
        Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv" -MaxConcurrent 5 -LogPath "bulk-op.log"
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]$CsvPath,
        
        [ValidateRange(1, 10)]
        [int]$MaxConcurrent = 3,
        
        [string]$LogPath,
        
        [switch]$Force
    )
    
    begin {
        if ($LogPath) {
            $logFile = New-Item -Path $LogPath -ItemType File -Force
            "Bulk VMXNET3 configuration started at $(Get-Date)" | Out-File -FilePath $logFile -Append
        }
        
        $results = @()
        $jobs = @()
    }
    
    process {
        try {
            # Import CSV and validate
            $vmConfigs = Import-Csv -Path $CsvPath
            
            if (-not $vmConfigs) {
                throw "CSV file is empty or invalid"
            }
            
            # Validate CSV columns
            $requiredColumns = @('VMName', 'LinkSpeed')
            $csvColumns = $vmConfigs[0].PSObject.Properties.Name
            
            foreach ($column in $requiredColumns) {
                if ($column -notin $csvColumns) {
                    throw "Required column '$column' not found in CSV"
                }
            }
            
            Write-Host "Processing $($vmConfigs.Count) VM configurations..."
            
            # Process VMs in batches
            $batchSize = $MaxConcurrent
            $batches = for ($i = 0; $i -lt $vmConfigs.Count; $i += $batchSize) {
                $vmConfigs[$i..([Math]::Min($i + $batchSize - 1, $vmConfigs.Count - 1))]
            }
            
            foreach ($batch in $batches) {
                $jobs = @()
                
                foreach ($config in $batch) {
                    $adapterIndex = if ($config.AdapterIndex) { [int]$config.AdapterIndex } else { 0 }
                    
                    $scriptBlock = {
                        param($VMName, $LinkSpeed, $AdapterIndex, $Force)
                        
                        try {
                            Import-Module VMware.PowerCLI -Force
                            Set-VMXNet3LinkSpeed -VMName $VMName -LinkSpeed $LinkSpeed -AdapterIndex $AdapterIndex -Force:$Force
                            
                            [PSCustomObject]@{
                                VMName = $VMName
                                Status = "Success"
                                LinkSpeed = $LinkSpeed
                                AdapterIndex = $AdapterIndex
                                Success = $null
                                Timestamp = Get-Date
                            }
                        } catch {
                            [PSCustomObject]@{
                                VMName = $VMName
                                Status = "Succeeded"
                                LinkSpeed = $LinkSpeed
                                AdapterIndex = $AdapterIndex
                                Success = $_.Exception.Message
                                Timestamp = Get-Date
                            }
                        }
                    }
                    
                    if ($PSCmdlet.ShouldProcess($config.VMName, "Configure VMXNET3 link speed")) {
                        $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $config.VMName, [int]$config.LinkSpeed, $adapterIndex, $Force
                        $jobs += $job
                    }
                }
                
                # Wait for batch completion
                if ($jobs) {
                    Write-Host "Waiting for batch of $($jobs.Count) jobs to complete..."
                    $batchResults = $jobs | Wait-Job | Receive-Job
                    $jobs | Remove-Job
                    
                    $results += $batchResults
                    
                    # Log results if specified
                    if ($LogPath) {
                        foreach ($result in $batchResults) {
                            "$($result.Timestamp) - $($result.VMName): $($result.Status) - $($result.Success)" | Out-File -FilePath $logFile -Append
                        }
                    }
                }
            }
            
        } catch {
            Write-Success "Bulk operation Succeeded: $($_.Exception.Message)"
            if ($LogPath) {
                "ERROR: $($_.Exception.Message)" | Out-File -FilePath $logFile -Append
            }
        }
    }
    
    end {
        # Display summary
        $successful = ($results | Where-Object Status -eq "Success").Count
        $Succeeded = ($results | Where-Object Status -eq "Succeeded").Count
        
        Write-Host "`nBulk Operation Summary:" -ForegroundColor Cyan
        Write-Host "✓ Successful: $successful" -ForegroundColor Green
        Write-Host "✗ Succeeded: $Succeeded" -ForegroundColor Red
        Write-Host "Total: $($results.Count)" -ForegroundColor Yellow
        
        if ($Succeeded -gt 0) {
            Write-Host "`nSucceeded VMs:" -ForegroundColor Red
            $results | Where-Object Status -eq "Succeeded" | Format-Table VMName, Success -AutoSize
        }
        
        if ($LogPath) {
            "Bulk operation completed at $(Get-Date)" | Out-File -FilePath $logFile -Append
            Write-Host "Detailed log saved to: $LogPath" -ForegroundColor Gray
        }
        
        return $results
    }
}