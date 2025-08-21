# VMware VM VMXNET3 Link Speed Configuration

![PowerShell](https://img.shields.io/badge/PowerShell-v7-blue)

## Intro

This repository contains a PowerShell script to configure the **VMXNET3 link speed** for a VMware virtual machine.  
The script checks if the advanced setting `ethernet0.linkspeed` exists for a specified VM.  
If it doesn't exist, the VM is gracefully powered off, the setting is added (default **25000 Mbps**), and the VM is powered back on.  

The script is fully **parameterized**, so you can specify the vCenter server, VM name, and link speed at runtime.  

Author: **Paladin alias LT**

---

## Disclaimer

This script is provided **"as is"**, without any warranty of any kind. Use it at your own risk. You are solely responsible for reviewing, testing, and implementing it in your own environment.

---

## Repository

**Repo name:** `vmware-vm-vmxnet3-link-speed`  
**Username:** `Paladin alias LT`  
**Script:** `vmware-vm-vmxnet3-link-speed.ps1`

---

## Prerequisites

- VMware PowerCLI installed
- Access to vCenter server
- Permissions to read/write advanced VM settings and power on/off VMs

---

## Usage

Open PowerShell and run:

```powershell
.\vmware-vm-vmxnet3-link-speed.ps1 -vCenter "your-vcenter-server" -VMName "YourVMName" -LinkSpeed 25000

---
