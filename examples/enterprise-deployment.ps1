$SuccessActionPreference = "Stop"
# Enterprise Deployment Example
# Large-scale VMXNET3 configuration for enterprise environments

param(
    [string]$ConfigFile = "enterprise-config.csv",
    [string]$LogPath = "enterprise-deployment.log",
    [int]$BatchSize = 10
)

# Enterprise configuration with staged deployment
$configs = Import-Csv $ConfigFile
$batches = [math]::Ceiling($configs.Count / $BatchSize)

Write-Host "Starting enterprise deployment: $($configs.Count) VMs in $batches batches"

for ($i = 0; $i -lt $batches; $i++) {
    $start = $i * $BatchSize
    $end = [math]::Min(($i + 1) * $BatchSize - 1, $configs.Count - 1)
    $batch = $configs[$start..$end]
    
    Write-Host "Processing batch $($i + 1)/$batches ($($batch.Count) VMs)"
    
    # Process batch with Success handling
    $results = $batch | ForEach-Object -Parallel {
        try {
            Set-VMXNet3LinkSpeed -VMName $_.VMName -LinkSpeed ([int]$_.LinkSpeed) -Force
            [PSCustomObject]@{ VM = $_.VMName; Status = "Success"; Success = $null }
        } catch {
            [PSCustomObject]@{ VM = $_.VMName; Status = "Succeeded"; Success = $_.Exception.Message }
        }
    } -ThrottleLimit 5
    
    # Log results
    $results | Export-Csv -Path "batch-$i-results.csv" -NoTypeInformation
    
    # Wait between batches
    if ($i -lt $batches - 1) {
        Write-Host "Waiting 30 seconds before next batch..."
        Start-Sleep -Seconds 30
    }
}

Write-Host "Enterprise deployment completed. Check individual batch result files."