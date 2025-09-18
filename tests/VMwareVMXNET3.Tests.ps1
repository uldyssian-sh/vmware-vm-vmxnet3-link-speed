BeforeAll {
    $ModulePath = Join-Path $PSScriptRoot '..' 'VMwareVMXNET3'
    Import-Module $ModulePath -Force
}

Describe 'VMwareVMXNET3 Module' {
    Context 'Module Structure' {
        It 'Should have valid module manifest' {
            $manifestPath = Join-Path $PSScriptRoot '..' 'VMwareVMXNET3' 'VMwareVMXNET3.psd1'
            { Test-ModuleManifest -Path $manifestPath } | Should -Not -Throw
        }

        It 'Should export expected functions' {
            $module = Get-Module VMwareVMXNET3
            $module.ExportedFunctions.Keys | Should -Contain 'Set-VMXNet3LinkSpeed'
            $module.ExportedFunctions.Keys | Should -Contain 'Get-VMXNet3LinkSpeed'
            $module.ExportedFunctions.Keys | Should -Contain 'Set-VMXNet3LinkSpeedBulk'
        }

        It 'Should have proper module version' {
            $manifest = Import-PowerShellDataFile -Path (Join-Path $PSScriptRoot '..' 'VMwareVMXNET3' 'VMwareVMXNET3.psd1')
            $manifest.ModuleVersion | Should -Match '^\d+\.\d+\.\d+$'
        }
    }

    Context 'Function Validation' {
        It 'Set-VMXNet3LinkSpeed should have proper parameters' {
            $command = Get-Command Set-VMXNet3LinkSpeed
            $command.Parameters.Keys | Should -Contain 'VMName'
            $command.Parameters.Keys | Should -Contain 'LinkSpeed'
            $command.Parameters.Keys | Should -Contain 'AdapterIndex'
            $command.Parameters.Keys | Should -Contain 'Force'
        }

        It 'Get-VMXNet3LinkSpeed should have proper parameters' {
            $command = Get-Command Get-VMXNet3LinkSpeed
            $command.Parameters.Keys | Should -Contain 'VMName'
            $command.Parameters.Keys | Should -Contain 'AdapterIndex'
        }

        It 'Set-VMXNet3LinkSpeedBulk should have proper parameters' {
            $command = Get-Command Set-VMXNet3LinkSpeedBulk
            $command.Parameters.Keys | Should -Contain 'CsvPath'
            $command.Parameters.Keys | Should -Contain 'MaxConcurrent'
            $command.Parameters.Keys | Should -Contain 'LogPath'
            $command.Parameters.Keys | Should -Contain 'Force'
        }
    }

    Context 'Parameter Validation' {
        It 'Set-VMXNet3LinkSpeed should validate LinkSpeed range' {
            $command = Get-Command Set-VMXNet3LinkSpeed
            $linkSpeedParam = $command.Parameters['LinkSpeed']
            $validation = $linkSpeedParam.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $validation.MinRange | Should -Be 100
            $validation.MaxRange | Should -Be 100000
        }

        It 'Set-VMXNet3LinkSpeed should validate AdapterIndex range' {
            $command = Get-Command Set-VMXNet3LinkSpeed
            $adapterParam = $command.Parameters['AdapterIndex']
            $validation = $adapterParam.Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $validation.MinRange | Should -Be 0
            $validation.MaxRange | Should -Be 3
        }
    }
}

Describe 'Script Validation' {
    Context 'Main Script' {
        BeforeAll {
            $script:mainScriptPath = Join-Path $PSScriptRoot '..' 'vmware-vm-vmxnet3-link-speed.ps1'
        }

        It 'Should have valid PowerShell syntax' {
            $content = Get-Content $script:mainScriptPath -Raw
            { [scriptblock]::Create($content) } | Should -Not -Throw
        }

        It 'Should contain required parameters' {
            $scriptContent = Get-Content $script:mainScriptPath -Raw
            $scriptContent | Should -Match 'param\s*\('
            $scriptContent | Should -Match '\$vCenter'
            $scriptContent | Should -Match '\$VMName'
            $scriptContent | Should -Match '\$LinkSpeed'
        }

        It 'Should have proper error handling' {
            $scriptContent = Get-Content $script:mainScriptPath -Raw
            $scriptContent | Should -Match 'ErrorAction\s+SilentlyContinue'
            $scriptContent | Should -Match 'if\s*\(\s*-not\s+\$vm\s*\)'
        }

        It 'Should handle VM power operations' {
            $scriptContent = Get-Content $script:mainScriptPath -Raw
            $scriptContent | Should -Match 'Shutdown-VMGuest'
            $scriptContent | Should -Match 'Start-VM'
            $scriptContent | Should -Match 'PowerState'
        }
    }
}

Describe 'Example Scripts' {
    Context 'Example Validation' {
        BeforeAll {
            $script:examplesPath = Join-Path $PSScriptRoot '..' 'examples'
        }

        It 'Should have example scripts' {
            $examples = Get-ChildItem -Path $script:examplesPath -Filter '*.ps1' -ErrorAction SilentlyContinue
            $examples.Count | Should -BeGreaterThan 0
        }

        It 'All example scripts should have valid syntax' {
            $examples = Get-ChildItem -Path $script:examplesPath -Filter '*.ps1' -ErrorAction SilentlyContinue
            foreach ($example in $examples) {
                $content = Get-Content $example.FullName -Raw
                { [scriptblock]::Create($content) } | Should -Not -Throw
            }
        }
    }
}