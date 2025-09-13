BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' 'VMwareVMXNET3'
    Import-Module $modulePath -Force
    
    # Mock PowerCLI cmdlets
    Mock Get-VM { 
        [PSCustomObject]@{
            Name = $Name
            PowerState = "PoweredOff"
        }
    }
    Mock Get-AdvancedSetting { return $null }
    Mock New-AdvancedSetting { return $true }
    Mock Set-AdvancedSetting { return $true }
    Mock Start-VM { return $true }
    Mock Shutdown-VMGuest { return $true }
}

Describe 'VMwareVMXNET3 Module' {
    Context 'Module Structure' {
        It 'Should import without errors' {
            { Import-Module (Join-Path $PSScriptRoot '..' 'VMwareVMXNET3') -Force } | Should -Not -Throw
        }
        
        It 'Should export expected functions' {
            $commands = Get-Command -Module VMwareVMXNET3
            $commands.Name | Should -Contain 'Set-VMXNet3LinkSpeed'
            $commands.Name | Should -Contain 'Get-VMXNet3LinkSpeed'
            $commands.Name | Should -Contain 'Set-VMXNet3LinkSpeedBulk'
        }
    }
    
    Context 'Set-VMXNet3LinkSpeed' {
        It 'Should accept valid parameters' {
            { Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 25000 -WhatIf } | Should -Not -Throw
        }
        
        It 'Should validate LinkSpeed range' {
            { Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 50 -WhatIf } | Should -Throw
            { Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 200000 -WhatIf } | Should -Throw
        }
        
        It 'Should validate AdapterIndex range' {
            { Set-VMXNet3LinkSpeed -VMName "TestVM" -LinkSpeed 25000 -AdapterIndex 5 -WhatIf } | Should -Throw
        }
    }
    
    Context 'Get-VMXNet3LinkSpeed' {
        It 'Should accept VM name parameter' {
            { Get-VMXNet3LinkSpeed -VMName "TestVM" } | Should -Not -Throw
        }
        
        It 'Should accept pipeline input' {
            { "TestVM" | Get-VMXNet3LinkSpeed } | Should -Not -Throw
        }
    }
    
    Context 'Set-VMXNet3LinkSpeedBulk' {
        BeforeAll {
            $testCsv = Join-Path $TestDrive "test-config.csv"
            @"
VMName,LinkSpeed,AdapterIndex
TestVM1,10000,0
TestVM2,25000,1
"@ | Out-File -FilePath $testCsv
        }
        
        It 'Should process CSV file' {
            { Set-VMXNet3LinkSpeedBulk -CsvPath $testCsv -WhatIf } | Should -Not -Throw
        }
        
        It 'Should validate CSV path' {
            { Set-VMXNet3LinkSpeedBulk -CsvPath "nonexistent.csv" -WhatIf } | Should -Throw
        }
    }
}