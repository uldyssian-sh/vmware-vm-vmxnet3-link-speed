BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot '..' 'vmware-vm-vmxnet3-link-speed.ps1'
    $script = Get-Content $scriptPath -Raw
}

Describe 'vmware-vm-vmxnet3-link-speed.ps1' {
    Context 'Script Structure' {
        It 'Should have proper PowerShell syntax' {
            { [scriptblock]::Create($script) } | Should -Not -Throw
        }

        It 'Should contain required parameters' {
            $script | Should -Match 'param\s*\('
            $script | Should -Match '\$vCenter'
            $script | Should -Match '\$VMName'
            $script | Should -Match '\$LinkSpeed'
        }

        It 'Should have default LinkSpeed value' {
            $script | Should -Match '\$LinkSpeed\s*=\s*25000'
        }
    }

    Context 'Script Content Validation' {
        It 'Should connect to vCenter' {
            $script | Should -Match 'Connect-VIServer'
        }

        It 'Should get VM object' {
            $script | Should -Match 'Get-VM'
        }

        It 'Should check advanced settings' {
            $script | Should -Match 'Get-AdvancedSetting'
            $script | Should -Match 'ethernet0\.linkspeed'
        }

        It 'Should handle VM power operations' {
            $script | Should -Match 'Shutdown-VMGuest'
            $script | Should -Match 'Start-VM'
        }

        It 'Should disconnect from vCenter' {
            $script | Should -Match 'Disconnect-VIServer'
        }
    }

    Context 'Error Handling' {
        It 'Should handle VM not found scenario' {
            $script | Should -Match 'ErrorAction\s+SilentlyContinue'
        }

        It 'Should have timeout handling for shutdown' {
            $script | Should -Match '\$timeout'
            $script | Should -Match 'Start-Sleep'
        }
    }
}