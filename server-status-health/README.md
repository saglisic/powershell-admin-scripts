# PowerShell Admin Scripts

Collection of practical PowerShell scripts for system administrators.

## Script: Get-ServerHealth.ps1

This script collects basic health metrics from Windows servers.

Checks:

- CPU utilization
- Memory usage
- Disk space
- Event log errors (last 24h)

Example usage:

.\Get-ServerHealth.ps1 -Servers server1,server2

Output:
server-health.csv
