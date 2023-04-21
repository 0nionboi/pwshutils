# This program will take a host and IP address and add it to the hosts file.  The hostname and IP are passed as parameters.
Write-Host "This script MUST be run as Administrator."
# Print usage if no parameters are passed
if ($args.count -eq 0) {
    Write-Host "Usage: hostsFileEdit.ps1 hostname ipaddress"
    exit
}

# Get the hostname and IP address from the command line
$hostname = $args[0]
$ip = $args[1]

# Check if $ip is a valid IP address
if ($ip -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
    $ipParts = $ip -split "\."
    if ($ipParts[0] -gt 255 -or $ipParts[1] -gt 255 -or $ipParts[2] -gt 255 -or $ipParts[3] -gt 255) {
        Write-Host "Invalid IP address"
        exit
    }
} else {
    Write-Host "Invalid IP address"
    exit
}

# Add the hostname and IP to the hosts file
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "$ip $hostname"

# Print the new hosts file
Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"