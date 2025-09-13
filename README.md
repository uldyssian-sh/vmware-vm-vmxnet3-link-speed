# VMware VMXNET3 Link Speed – Safe Configurator (PowerCLI)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue)
![vSphere](https://img.shields.io/badge/VMware-vSphere%207%20%7C%208-orange)
![Status](https://img.shields.io/badge/Status-Active-success)

A safety-first PowerCLI utility to **view and set** `vmxnet3` NIC **link speed** for a VM using the advanced setting `ethernetX.linkspeed`.  
Supports **dry-run** preview, JSON export, and idempotent updates.

> Author: LT · Version: 1.0

---

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Parameters](#parameters)
- [Examples](#examples)
- [Output](#output)
- [Permissions & Safety](#permissions--safety)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Overview
VMXNET3 does not expose a traditional “link speed” like physical NICs; however, vSphere supports an **advanced VMX parameter** `ethernetX.linkspeed` that can be read and, when needed, set for testing/lab purposes.  
This tool helps you **inspect and set** that parameter in a controlled, read-mostly way.

> ⚠️ **Note:** This is primarily for **lab/testing**. Production changes should follow your org’s change management and vendor guidance.

---

## Features
- Read current `ethernetX.linkspeed` (per NIC index)
- Safe **dry-run** mode (no writes)
- Set/update a specific NIC index (e.g., `ethernet0`)
- JSON export of results for automation
- Clear console output and non-zero exit on errors

---

## Requirements
- PowerShell **5.1** (Windows) or **7+** (Win/Linux/macOS)
- VMware **PowerCLI** (`VMware.VimAutomation.Core`)
- Access to vCenter or ESXi with read permissions (write when applying changes)

```powershell
Install-Module VMware.PowerCLI -Scope CurrentUser

---

## Installation

Clone the repository and import/run the script:
git clone https://github.com/<you>/vmware-vm-vmxnet3-link-speed.git
cd vmware-vm-vmxnet3-link-speed

---

## Usage
Read (no changes)
.\Set-VMXNET3LinkSpeed.ps1 -VM 'MyVM' -NicIndex 0 -WhatIf

Apply a linkspeed value
.\Set-VMXNET3LinkSpeed.ps1 -VM 'MyVM' -NicIndex 0 -LinkSpeedMbps 10000

## Export to JSON
.\Set-VMXNET3LinkSpeed.ps1 -VM 'MyVM' -NicIndex 0 -WhatIf -ExportPath .\out.json

---

## Examples
	•	Read current setting:
.\Set-VMXNET3LinkSpeed.ps1 -VM Web01 -NicIndex 1 -WhatIf

	•	Set and export:
.\Set-VMXNET3LinkSpeed.ps1 -VM App01 -NicIndex 0 -LinkSpeedMbps 10000 -ExportPath .\ls.json

---

## Output

Console: human-readable summary
JSON (optional): machine-friendly details (VM, NIC, current value, proposed value, timestamp)

## Permissions & Safety
	•	Read operations require read permissions on the VM.
	•	Write operations require permission to reconfigure the VM.
	•	Use -WhatIf for a safe preview before applying changes.

---

## Contributing
PRs are welcome: fork, branch, commit tests, open PR. See CONTRIBUTING.

---

## License
Licensed under the MIT License.

---

```powershell
<#
.SYNOPSIS
    Safely reads or sets VMXNET3 NIC link speed using the advanced VMX parameter 'ethernetX.linkspeed'.
.DESCRIPTION
    Reads current value for a given NIC index (X) on a VM and optionally applies a new value.
    Supports dry-run via -WhatIf and JSON export summarizing the action and results.
.PARAMETER VM
    Target VM name.
.PARAMETER NicIndex
    NIC index (e.g., 0 => ethernet0, 1 => ethernet1).
.PARAMETER LinkSpeedMbps
    Desired link speed (Mbps). If omitted, script only reads.
.PARAMETER ExportPath
    Optional path to write JSON output (object summary).
.EXAMPLE
    .\Set-VMXNET3LinkSpeed.ps1 -VM 'Web01' -NicIndex 0 -WhatIf
.EXAMPLE
    .\Set-VMXNET3LinkSpeed.ps1 -VM 'App01' -NicIndex 1 -LinkSpeedMbps 10000 -ExportPath .\out.json
.NOTES
    Author: LT | Version: 1.0
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory)][string]$VM,
    [Parameter(Mandatory)][int]$NicIndex,
    [int]$LinkSpeedMbps,
    [string]$ExportPath
)

$ErrorActionPreference = 'Stop'

function Get-VMAdvancedSettingValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][VMware.VimAutomation.ViCore.Impl.V1.Inventory.VirtualMachineImpl]$Vm,
        [Parameter(Mandatory)][int]$Index
    )
    $key = "ethernet$Index.linkspeed"
    $setting = Get-AdvancedSetting -Entity $Vm -Name $key -ErrorAction SilentlyContinue
    return [pscustomobject]@{
        Key   = $key
        Found = [bool]$setting
        Value = if ($setting) { $setting.Value } else { $null }
    }
}

function Set-VMAdvancedSettingValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][VMware.VimAutomation.ViCore.Impl.V1.Inventory.VirtualMachineImpl]$Vm,
        [Parameter(Mandatory)][string]$Key,
        [Parameter(Mandatory)][string]$Value
    )
    $existing = Get-AdvancedSetting -Entity $Vm -Name $Key -ErrorAction SilentlyContinue
    if ($existing) {
        Set-AdvancedSetting -AdvancedSetting $existing -Value $Value -Confirm:$false | Out-Null
    } else {
        New-AdvancedSetting -Entity $Vm -Name $Key -Value $Value -Confirm:$false | Out-Null
    }
}

try {
    # Ensure PowerCLI context
    if (-not (Get-Module -Name VMware.VimAutomation.Core -ListAvailable)) {
        throw "VMware.VimAutomation.Core module not found. Install-Module VMware.PowerCLI -Scope CurrentUser"
    }

    $vmObj = Get-VM -Name $VM -ErrorAction Stop
    $current = Get-VMAdvancedSettingValue -Vm $vmObj -Index $NicIndex

    $result = [pscustomobject]@{
        VM            = $VM
        NicIndex      = $NicIndex
        Key           = $current.Key
        CurrentValue  = $current.Value
        DesiredValue  = $null
        Action        = if ($PSBoundParameters.ContainsKey('LinkSpeedMbps')) { 'Set' } else { 'Read' }
        Changed       = $false
        TimestampUtc  = [DateTime]::UtcNow.ToString('o')
        DryRun        = $WhatIfPreference -or -not $PSCmdlet.ShouldProcess("$VM", "Change $($current.Key)")
        Error         = $null
    }

    if ($PSBoundParameters.ContainsKey('LinkSpeedMbps')) {
        $result.DesiredValue = "$LinkSpeedMbps"
        if ($result.DryRun) {
            Write-Host "[DRY-RUN] Would set $($current.Key) from '$($current.Value)' to '$($result.DesiredValue)' on VM '$VM'"
        } else {
            Set-VMAdvancedSettingValue -Vm $vmObj -Key $current.Key -Value $result.DesiredValue
            $verify = Get-AdvancedSetting -Entity $vmObj -Name $current.Key -ErrorAction Stop
            $result.Changed = ($verify.Value -eq $result.DesiredValue)
            Write-Host "Set $($current.Key) to '$($result.DesiredValue)' on VM '$VM' (Changed=$($result.Changed))"
        }
    } else {
        Write-Host "Current $($current.Key) on '$VM' is '$($current.Value)' (found=$($current.Found))"
    }

    if ($ExportPath) {
        $result | ConvertTo-Json -Depth 6 | Set-Content -Path $ExportPath -Encoding UTF8
        Write-Host "JSON exported to $ExportPath"
    }

    if (-not $result.DryRun -and $result.Action -eq 'Set' -and -not $result.Changed) {
        throw "Setting not applied (verification failed)."
    }

} catch {
    Write-Error $_.Exception.Message
    exit 1
}
