<#
.SYNOPSIS
Configure VMXNET3 link speed for a VMware VM.

.DESCRIPTION
This script checks if the advanced setting 'ethernet0.linkspeed' exists for a given VM.
If it does not exist, the VM is gracefully powered off, the setting is added with value 25000 Mbps by default,
and the VM is powered back on.

.PARAMETER vCenter
The address of the vCenter server.

.PARAMETER VMName
The name of the virtual machine to configure.

.PARAMETER LinkSpeed
The desired VMXNET3 link speed in Mbps. Default is 25000.

.AUTHOR
Paladin alias LT
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$vCenter,

    [Parameter(Mandatory=$true)]
    [string]$VMName,

    [int]$LinkSpeed = 25000
)

# Connect to vCenter
Write-Output "Connecting to vCenter: $vCenter ..."
Connect-VIServer -Server $vCenter

# Get the VM object
$vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue

if (-not $vm) {
    Write-Output "VM '$VMName' not found."
    Disconnect-VIServer -Server $vCenter -Confirm:$false
    exit
}

# Check if the advanced setting exists
$param = Get-AdvancedSetting -Entity $vm -Name "ethernet0.linkspeed" -ErrorAction SilentlyContinue

if ($param) {
    Write-Output "$($vm.Name): Ok, 'ethernet0.linkspeed' already configured."
} else {
    # Power off the VM if needed
    if ($vm.PowerState -eq "PoweredOn") {
        Write-Output "Powering off VM '$($vm.Name)'..."
        Shutdown-VMGuest -VM $vm -Confirm:$false

        # Wait until the VM is powered off
        $timeout = 30
        $elapsed = 0
        $interval = 5

        while (($vm.PowerState -ne "PoweredOff") -and ($elapsed -lt $timeout)) {
            Start-Sleep -Seconds $interval
            $elapsed += $interval
            $vm = Get-VM -Name $VMName
        }

        if ($vm.PowerState -ne "PoweredOff") {
            Write-Output "Failed to power off VM '$($vm.Name)' within timeout."
            Disconnect-VIServer -Server $vCenter -Confirm:$false
            exit
        }
    }

    # Add the advanced setting
    Write-Output "Adding 'ethernet0.linkspeed' = $LinkSpeed ..."
    New-AdvancedSetting -Entity $vm -Name "ethernet0.linkspeed" -Value $LinkSpeed -Force -Confirm:$false

    # Power on the VM
    Write-Output "Powering on VM '$($vm.Name)'..."
    Start-VM -VM $vm -Confirm:$false

    Write-Output "$($vm.Name): Ok, 'ethernet0.linkspeed' configured to $LinkSpeed."
}

# Disconnect from vCenter
Disconnect-VIServer -Server $vCenter -Confirm:$false
