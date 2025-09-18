# PowerShell Core with VMware PowerCLI
FROM mcr.microsoft.com/powershell:7.4-ubuntu-22.04

# Set working directory
WORKDIR /app

# Install VMware PowerCLI
RUN pwsh -Command "Install-Module -Name VMware.PowerCLI -Force -Scope AllUsers -AllowClobber"

# Configure PowerCLI
RUN pwsh -Command "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCEIP \$false -Confirm:\$false"

# Copy module and scripts
COPY VMwareVMXNET3/ ./VMwareVMXNET3/
COPY vmware-vm-vmxnet3-link-speed.ps1 ./
COPY examples/ ./examples/

# Set entrypoint
ENTRYPOINT ["pwsh"]
CMD ["-File", "./vmware-vm-vmxnet3-link-speed.ps1"]