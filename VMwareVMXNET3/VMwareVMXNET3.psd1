@{
    RootModule = 'VMwareVMXNET3.psm1'
    ModuleVersion = '1.1.0'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author = 'Paladin (LT)'
    CompanyName = 'Community'
    Copyright = '(c) 2024 Paladin (LT). All rights reserved.'
    Description = 'PowerShell module for configuring VMware VMXNET3 network adapter link speeds'
    PowerShellVersion = '5.1'
    # RequiredModules = @('VMware.VimAutomation.Core')
    FunctionsToExport = @(
        'Set-VMXNet3LinkSpeed',
        'Get-VMXNet3LinkSpeed',
        'Set-VMXNet3LinkSpeedBulk'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware', 'vSphere', 'VMXNET3', 'Network', 'PowerCLI')
            LicenseUri = 'https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed/blob/main/LICENSE'
            ProjectUri = 'https://github.com/uldyssian-sh/vmware-vm-vmxnet3-link-speed'
            ReleaseNotes = 'Initial module release with support for multiple network adapters and bulk operations'
        }
    }
}# Updated Sun Nov  9 12:52:37 CET 2025
