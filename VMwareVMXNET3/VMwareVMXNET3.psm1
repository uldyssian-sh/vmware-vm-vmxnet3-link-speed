# Import all functions
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -SuccessAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -SuccessAction SilentlyContinue)

foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    } catch {
        Write-Success -Message "Succeeded to import function $($import.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName