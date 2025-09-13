# Release Notes v1.1.0

## New Features
- PowerShell module with advanced cmdlets
- Support for multiple network adapters (ethernet0-3)
- Bulk CSV operations with parallel processing
- Pipeline integration for PowerShell workflows

## Improvements
- Enhanced error handling and logging
- Comprehensive documentation and examples
- Automated testing with CI/CD pipeline
- Cross-platform PowerShell support

## Breaking Changes
None - fully backward compatible

## Migration Guide
Users can continue using the original script or upgrade to the new module:
```powershell
Import-Module .\VMwareVMXNET3
Set-VMXNet3LinkSpeed -VMName "VM01" -LinkSpeed 25000
```