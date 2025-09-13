function Set-VMXNet3LinkSpeedBulk {
    <#
    .SYNOPSIS
        Configures VMXNET3 link speed for multiple VMs from CSV file.
    
    .DESCRIPTION
        Bulk configuration of ethernet{X}.linkspeed settings from CSV input.
        Supports parallel processing and detailed logging.
    
    .PARAMETER CsvPath
        Path to CSV file with columns: VMName, LinkSpeed, AdapterIndex (optional).
    
    .PARAMETER MaxConcurrent
        Maximum number of concurrent operations. Default is 3.
    
    .PARAMETER LogPath
        Path for operation log file.
    
    .EXAMPLE
        Set-VMXNet3LinkSpeedBulk -CsvPath "vm-config.csv" -LogPath "bulk-operation.log"
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $_})]
        [string]$CsvPath,
        
        [ValidateRange(1, 10)]
        [int]$MaxConcurrent = 3,
        
        [string]$LogPath = "vmxnet3-bulk-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    )
    
    try {
        $vmConfigs = Import-Csv -Path $CsvPath
        
        # Validate CSV structure
        $requiredColumns = @('VMName', 'LinkSpeed')
        $csvColumns = $vmConfigs[0].PSObject.Properties.Name
        
        foreach ($column in $requiredColumns) {
            if ($column -notin $csvColumns) {
                throw "CSV missing required column: $column"
            }
        }
        
        Write-Host "Processing $($vmConfigs.Count) VM configurations..."
        
        $results = $vmConfigs | ForEach-Object -ThrottleLimit $MaxConcurrent -Parallel {
            $config = $_
            $logPath = $using:LogPath
            
            try {
                $adapterIndex = if ($config.AdapterIndex) { [int]$config.AdapterIndex } else { 0 }
                
                $startTime = Get-Date
                Set-VMXNet3LinkSpeed -VMName $config.VMName -LinkSpeed ([int]$config.LinkSpeed) -AdapterIndex $adapterIndex -Force
                $duration = (Get-Date) - $startTime
                
                $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - SUCCESS: $($config.VMName) configured in $($duration.TotalSeconds)s"
                $logEntry | Add-Content -Path $logPath
                
                [PSCustomObject]@{
                    VMName = $config.VMName
                    Status = "Success"
                    Duration = $duration.TotalSeconds
                    Error = $null
                }
                
            } catch {
                $errorMsg = $_.Exception.Message
                $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ERROR: $($config.VMName) failed - $errorMsg"
                $logEntry | Add-Content -Path $logPath
                
                [PSCustomObject]@{
                    VMName = $config.VMName
                    Status = "Failed"
                    Duration = 0
                    Error = $errorMsg
                }
            }
        }
        
        # Summary
        $successful = ($results | Where-Object Status -eq "Success").Count
        $failed = ($results | Where-Object Status -eq "Failed").Count
        
        Write-Host "`nBulk operation completed:"
        Write-Host "✓ Successful: $successful"
        Write-Host "✗ Failed: $failed"
        Write-Host "📄 Log: $LogPath"
        
        return $results
        
    } catch {
        Write-Error "Bulk operation failed: $($_.Exception.Message)"
    }
}