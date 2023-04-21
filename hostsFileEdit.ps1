# Print the hosts file, excluding lines that are commented out.  List each host and add an index number to the beginning of each line.  
$hosts = Get-Content -Path "C:\Windows\System32\drivers\etc\hosts" | Where-Object {$_ -notmatch "^#"}

# Remove blank lines from $hosts
$hosts = $hosts | Where-Object {$_}

# Print the index
$hosts | ForEach-Object {Write-Host "$($hosts.IndexOf($_)) $_"}

# Ask the user to select a host to edit.  If the user inputs 'n', create a new host.  If the user inputs 'q', quit the program.
Write-Host "Enter the index of the host to delete, or 'n' to create a new host, or 'q' to quit."
$choice = Read-Host

# If the user inputs 'q', quit the program.
if ($choice -eq "q") {
    exit
}

# If the user inputs 'n', create a new host.
if ($choice -eq "n") {
    Write-Host "Enter the hostname:"
    $hostname = Read-Host
    Write-Host "Enter the IP address:"
    $ip = Read-Host
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
    Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "$ip $hostname"
    # Print the new hosts file
    Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"
    exit
}

# If the user inputs a number, delete the host at that index.
if ($choice -match "^\d+$") {
    # Find the line number of the host to delete
    $lineNumber = $hosts[$choice] -split " " | Select-Object -First 1
    # Delete the host
    (Get-Content -Path "C:\Windows\System32\drivers\etc\hosts") | Where-Object {$_ -notmatch "^$lineNumber"} | Set-Content -Path "C:\Windows\System32\drivers\etc\hosts"
    # Print the new hosts file
    Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"
    exit
}