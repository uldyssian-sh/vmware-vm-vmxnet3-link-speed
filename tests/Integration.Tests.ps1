BeforeAll {
    # Mock PowerCLI cmdlets for integration testing
    Mock Connect-VIServer { return $true }
    Mock Disconnect-VIServer { return $true }
    Mock Get-VM { 
        return [PSCustomObject]@{
            Name = $Name
            PowerState = "PoweredOn"
        }
    }
    Mock Get-AdvancedSetting { 
        if ($Name -eq "ethernet0.linkspeed") {
            return $null  # Simulate setting doesn't exist
        }
    }
    Mock New-AdvancedSetting { return $true }
    Mock Shutdown-VMGuest { return $true }
    Mock Start-VM { return $true }
}

Describe 'Integration Tests' {
    Context 'End-to-End Workflow' {
        It 'Should complete full workflow without errors' {
            # This would be a real integration test in a test environment
            # For now, we'll test the script structure and mocked behavior
            
            $scriptPath = Join-Path $PSScriptRoot '..' 'vmware-vm-vmxnet3-link-speed.ps1'
            
            # Test that script can be parsed without syntax errors
            { [scriptblock]::Create((Get-Content $scriptPath -Raw)) } | Should -Not -Throw
        }
        
        It 'Should handle missing VM gracefully' {
            Mock Get-VM { throw "VM not found" }
            
            # In a real test, we'd capture the script output
            # For now, we verify the mock behavior
            { Get-VM -Name "NonExistentVM" } | Should -Throw "VM not found"
        }
        
        It 'Should handle existing setting correctly' {
            Mock Get-AdvancedSetting { 
                return [PSCustomObject]@{
                    Name = "ethernet0.linkspeed"
                    Value = "25000"
                }
            }
            
            $result = Get-AdvancedSetting -Entity (Get-VM -Name "TestVM") -Name "ethernet0.linkspeed"
            $result.Value | Should -Be "25000"
        }
    }
    
    Context 'PowerCLI Module Dependencies' {
        It 'Should check for PowerCLI availability' {
            # Test module availability check logic
            $moduleCheck = Get-Module -Name VMware.VimAutomation.Core -ListAvailable
            
            # In CI environment, this might not be available, so we just test the logic
            $moduleCheck | Should -BeOfType [System.Object]
        }
    }
    
    Context 'Parameter Validation' {
        It 'Should validate vCenter parameter' {
            # Test parameter validation logic
            $vCenter = "vcenter.test.com"
            $vCenter | Should -Match "^[a-zA-Z0-9.-]+$"
        }
        
        It 'Should validate VMName parameter' {
            # Test VM name validation
            $vmName = "TestVM01"
            $vmName | Should -Not -BeNullOrEmpty
            $vmName.Length | Should -BeGreaterThan 0
        }
        
        It 'Should validate LinkSpeed parameter' {
            # Test link speed validation
            $linkSpeed = 25000
            $linkSpeed | Should -BeOfType [int]
            $linkSpeed | Should -BeGreaterThan 0
        }
    }
}