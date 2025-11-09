BeforeAll {
    # Test configuration
    $script:scriptPath = Join-Path $PSScriptRoot '..' 'vmware-vm-vmxnet3-link-speed.ps1'
}

Describe 'vmware-vm-vmxnet3-link-speed.ps1' {
    Context 'Script Structure' {
        It 'Should have proper PowerShell syntax' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            { [scriptblock]::Create($scriptContent) } | Should -Not -Throw
        }

        It 'Should contain required parameters' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match 'param\s*\('
            $scriptContent | Should -Match '\$vCenter'
            $scriptContent | Should -Match '\$VMName'
            $scriptContent | Should -Match '\$LinkSpeed'
        }

        It 'Should have default LinkSpeed value' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match '\$LinkSpeed\s*=\s*25000'
        }
    }

    Context 'Script Content Validation' {
        It 'Should connect to vCenter' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match 'Connect-VIServer'
        }

        It 'Should get VM object' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match 'Get-VM'
        }

        It 'Should check advanced settings' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match 'Get-AdvancedSetting'
            $scriptContent | Should -Match 'ethernet0\.linkspeed'
        }

        It 'Should handle VM power operations' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match 'Shutdown-VMGuest'
            $scriptContent | Should -Match 'Start-VM'
        }

        It 'Should disconnect from vCenter' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match 'Disconnect-VIServer'
        }
    }

    Context 'Error Handling' {
        It 'Should handle VM not found scenario' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match 'ErrorAction\s+SilentlyContinue'
        }

        It 'Should have timeout handling for shutdown' {
            $scriptContent = Get-Content $script:scriptPath -Raw
            $scriptContent | Should -Match '\$timeout'
            $scriptContent | Should -Match 'Start-Sleep'
        }
    }
}# Updated 20251109_123833
