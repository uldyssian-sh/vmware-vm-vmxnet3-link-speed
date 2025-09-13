FROM mcr.microsoft.com/powershell:latest

# Install VMware PowerCLI
RUN pwsh -Command "Install-Module -Name VMware.PowerCLI -Force -Scope AllUsers"

# Copy module and scripts
COPY VMwareVMXNET3/ /opt/VMwareVMXNET3/
COPY examples/ /opt/examples/
COPY *.ps1 /opt/

# Set working directory
WORKDIR /opt

# Import module on startup
RUN echo "Import-Module /opt/VMwareVMXNET3" >> /opt/Microsoft.PowerShell_profile.ps1

# Default command
CMD ["pwsh"]