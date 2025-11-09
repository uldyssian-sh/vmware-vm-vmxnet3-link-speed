# Publish VMwareVMXNET3 module to PowerShell Gallery
# Run this script to publish the module

param(
    [Parameter(Mandatory)]
    [string]$ApiKey
)

# Prepare module for publishing
$modulePath = Join-Path $PSScriptRoot "VMwareVMXNET3"

# Test module manifest
Test-ModuleManifest -Path (Join-Path $modulePath "VMwareVMXNET3.psd1")

# Publish to PowerShell Gallery
try {
    Publish-Module -Path $modulePath -NuGetApiKey $ApiKey -Verbose
    Write-Host "✓ Module published successfully to PowerShell Gallery" -ForegroundColor Green
} catch {
    Write-Error "Failed to publish module: $($_.Exception.Message)"
}

# Instructions for users
Write-Host @"

Module published! Users can now install with:
Install-Module -Name VMwareVMXNET3 -Scope CurrentUser

"@ -ForegroundColor Cyan# Updated 20251109_123833
# Updated Sun Nov  9 12:52:37 CET 2025
