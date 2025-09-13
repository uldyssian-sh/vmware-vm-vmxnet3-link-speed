# Performance Guide

## Understanding VMXNET3 Link Speed Configuration

### What is ethernet0.linkspeed?

The `ethernet0.linkspeed` parameter is an advanced VMX setting that allows you to specify the advertised link speed for VMXNET3 network adapters. This setting affects how the guest operating system perceives the network adapter's capabilities.

### Performance Impact

#### Positive Effects
- **Guest OS Optimization**: The guest OS can optimize network stack parameters based on perceived link speed
- **Application Tuning**: Applications may adjust buffer sizes and connection pooling based on detected bandwidth
- **Monitoring Accuracy**: Network monitoring tools display more accurate speed information

#### Considerations
- **Actual Throughput**: The setting doesn't change actual network performance, only the advertised speed
- **Driver Behavior**: Some network drivers may behave differently based on reported link speed
- **Testing Scenarios**: Useful for testing applications under different perceived network conditions

## Common Link Speed Values

### Standard Network Speeds
```
1 Gbps    = 1000 Mbps
10 Gbps   = 10000 Mbps
25 Gbps   = 25000 Mbps
40 Gbps   = 40000 Mbps
100 Gbps  = 100000 Mbps
```

### Recommended Values by Use Case

#### Development/Testing
- **1 Gbps (1000)**: Simulate standard enterprise network
- **10 Gbps (10000)**: Modern datacenter standard
- **25 Gbps (25000)**: High-performance computing environments

#### Production Considerations
- Match the actual physical network infrastructure
- Consider the ESXi host's physical network capabilities
- Account for network oversubscription ratios

## Performance Testing

### Before Configuration
```powershell
# Test current network performance
$VM = Get-VM -Name "TestVM"
$NetworkAdapter = $VM | Get-NetworkAdapter
Write-Host "Current adapter type: $($NetworkAdapter.Type)"

# Check current advanced setting
$CurrentSetting = Get-AdvancedSetting -Entity $VM -Name "ethernet0.linkspeed" -ErrorAction SilentlyContinue
if ($CurrentSetting) {
    Write-Host "Current link speed: $($CurrentSetting.Value) Mbps"
} else {
    Write-Host "Link speed not configured"
}
```

### After Configuration
```powershell
# Verify the setting was applied
$VM = Get-VM -Name "TestVM"
$Setting = Get-AdvancedSetting -Entity $VM -Name "ethernet0.linkspeed"
Write-Host "Configured link speed: $($Setting.Value) Mbps"

# Check guest OS perception (requires guest tools and appropriate permissions)
$GuestInfo = Get-VMGuest -VM $VM
Write-Host "Guest OS: $($GuestInfo.OSFullName)"
```

## Best Practices

### Planning
1. **Document Current State**: Record existing network configurations before changes
2. **Test Environment**: Always test in non-production first
3. **Baseline Performance**: Measure network performance before and after changes
4. **Application Testing**: Verify applications work correctly with new settings

### Implementation
1. **Staged Rollout**: Configure VMs in small batches
2. **Monitoring**: Monitor VM performance during and after configuration
3. **Rollback Plan**: Have a plan to revert changes if issues occur
4. **Documentation**: Document all changes for compliance and troubleshooting

### Monitoring
```powershell
# Monitor VM network performance
$VM = Get-VM -Name "TestVM"
$Stats = Get-Stat -Entity $VM -Stat "net.usage.average" -Start (Get-Date).AddHours(-1)
$Stats | Select-Object Timestamp, Value, Unit
```

## Troubleshooting Performance Issues

### Common Issues

#### Guest OS Not Recognizing Speed
**Symptoms**: Guest OS still shows old speed or generic values
**Solutions**:
- Restart the VM after configuration
- Update VMware Tools to latest version
- Check guest OS network driver version

#### Application Behavior Changes
**Symptoms**: Applications perform differently after configuration
**Solutions**:
- Review application network configuration
- Check application logs for network-related messages
- Consider reverting to previous speed setting

#### Network Performance Degradation
**Symptoms**: Actual network throughput decreases
**Solutions**:
- Verify physical network infrastructure can support configured speed
- Check for network oversubscription
- Review ESXi host network configuration

### Diagnostic Commands

#### PowerCLI Diagnostics
```powershell
# Check VM network configuration
$VM = Get-VM -Name "TestVM"
$VM | Get-NetworkAdapter | Select-Object Name, Type, NetworkName, MacAddress

# Review all advanced settings
Get-AdvancedSetting -Entity $VM | Where-Object {$_.Name -like "*ethernet*"} | Sort-Object Name

# Check VM hardware version
$VM | Select-Object Name, Version, PowerState
```

#### ESXi Host Diagnostics
```bash
# Check physical network adapters
esxcli network nic list

# Check vSwitch configuration
esxcli network vswitch standard list

# Check network statistics
esxcli network nic stats get -n vmnic0
```

## Performance Optimization Tips

### VM Configuration
- Ensure VM hardware version supports VMXNET3 features
- Configure appropriate number of vCPUs for network processing
- Consider NUMA topology for high-performance workloads

### ESXi Host Configuration
- Use dedicated physical NICs for high-performance VMs
- Configure appropriate vSwitch and portgroup settings
- Consider SR-IOV for maximum performance (where supported)

### Guest OS Configuration
- Install latest VMware Tools
- Update network drivers to latest versions
- Configure guest OS network stack for high performance

## Monitoring and Alerting

### Key Metrics to Monitor
- Network throughput (Mbps)
- Packet loss percentage
- Network latency (ms)
- CPU utilization during network operations

### Alerting Thresholds
```powershell
# Example: Alert if network utilization exceeds 80% of configured speed
$VM = Get-VM -Name "TestVM"
$ConfiguredSpeed = (Get-AdvancedSetting -Entity $VM -Name "ethernet0.linkspeed").Value
$AlertThreshold = [int]($ConfiguredSpeed * 0.8)

Write-Host "Alert threshold set to: $AlertThreshold Mbps"
```

## Capacity Planning

### Considerations
- Physical network infrastructure capacity
- ESXi host network capacity
- Network oversubscription ratios
- Future growth requirements

### Calculation Example
```powershell
# Calculate total configured network capacity
$VMs = Get-VM | Where-Object {$_.PowerState -eq "PoweredOn"}
$TotalConfiguredCapacity = 0

foreach ($VM in $VMs) {
    $LinkSpeed = Get-AdvancedSetting -Entity $VM -Name "ethernet0.linkspeed" -ErrorAction SilentlyContinue
    if ($LinkSpeed) {
        $TotalConfiguredCapacity += [int]$LinkSpeed.Value
    }
}

Write-Host "Total configured network capacity: $TotalConfiguredCapacity Mbps"
```