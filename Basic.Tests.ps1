# tests/Basic.Tests.ps1
BeforeAll {
    $ErrorActionPreference = 'Stop'
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

Describe 'Repository sanity' {
    It 'has README.md' {
        Test-Path (Join-Path $RepoRoot 'README.md') | Should -BeTrue
    }
    It 'has main script' {
        Test-Path (Join-Path $RepoRoot 'Set-VMXNET3LinkSpeed.ps1') | Should -BeTrue
    }
}

Describe 'Script parses' {
    It 'Set-VMXNET3LinkSpeed.ps1 loads without parse errors' {
        $code = Get-Content (Join-Path $RepoRoot 'Set-VMXNET3LinkSpeed.ps1') -Raw
        { [scriptblock]::Create($code) } | Should -Not -Throw
    }
}
