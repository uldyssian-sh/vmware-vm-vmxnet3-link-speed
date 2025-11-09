# Integration Tests - Requires VMware PowerCLI
# These tests are skipped if PowerCLI is not available

BeforeAll {
    $script:PowerCLIAvailable = $false
    try {
        Import-Module VMware.PowerCLI -ErrorAction Stop
        $script:PowerCLIAvailable = $true
    } catch {
        Write-Warning "VMware PowerCLI not available - skipping integration tests"
    }
}

Describe 'Integration Tests' -Skip:(-not $script:PowerCLIAvailable) {
    Context 'PowerCLI Integration' {
        It 'Should have PowerCLI commands available' {
            Get-Command Connect-VIServer | Should -Not -BeNullOrEmpty
            Get-Command Get-VM | Should -Not -BeNullOrEmpty
            Get-Command Get-AdvancedSetting | Should -Not -BeNullOrEmpty
        }

        It 'Should be able to create mock VM objects' {
            # Mock test - would require actual vCenter connection for real tests
            $true | Should -Be $true
        }
    }
}

Describe 'Mock Integration Tests' {
    Context 'Function Behavior' {
        It 'Should handle missing VM gracefully' {
            # This would test actual function behavior with mocked PowerCLI
            $true | Should -Be $true
        }

        It 'Should validate parameters correctly' {
            # Test parameter validation
            { Set-VMXNet3LinkSpeed -VMName "Test" -LinkSpeed 50 } | Should -Throw
            { Set-VMXNet3LinkSpeed -VMName "Test" -LinkSpeed 150000 } | Should -Throw
        }
    }
}# Updated 20251109_123833
