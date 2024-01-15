function Get-CurrentDomain {
    $forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
    return $forest.RootDomain
}

function Check-Servers {
    param(
        [string]$filePath = "E:\VisualStudio\github\m365tools\controller\onpremise\db-server.txt"
    )

    if (-not (Test-Path -Path $filePath)) {
        Write-Host "Server list file not found: $filePath"
        return
    }

    Import-Csv -Path $filePath | ForEach-Object {
        $serverName = $_.name + '.' + (Get-CurrentDomain)
        Write-Host "Server: $serverName, Type: $($_.type)"
    }
}

function Connect-DC {
    param(
        [string]$remoteComputer
    )

    try {
        Enter-PSSession -ComputerName $remoteComputer
    } catch {
        Write-Host "Failed to connect to $remoteComputer. Error: $($_.Exception.Message)"
        $userChoice = Read-Host "Do you want to connect to another server? (yes/no)"
        if ($userChoice -eq "yes") {
            return $true
        }
    }

    return $false
}

function Connect-EMS {
    param(
        [string]$exchangeServer
    )

    try {
        # Replace with your actual Exchange Management Shell connection command
        # For example, using implicit remoting
        $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$exchangeServer/PowerShell/ -Authentication Kerberos
        Import-PSSession $session

        Write-Host "Connected to Exchange Management Shell on $exchangeServer."
    } catch {
        Write-Host "Failed to connect to Exchange Management Shell on $exchangeServer. Error: $($_.Exception.Message)"
        $userChoice = Read-Host "Do you want to try another Exchange Server? (yes/no)"
        if ($userChoice -eq "yes") {
            return $true
        }
    }

    return $false
}

function Connect-Servers {
    param(
        [string]$filePath = "E:\VisualStudio\github\m365tools\controller\onpremise\db-server.txt"
    )

    Write-Title "Establish Connection To Servers"

    $servers = Import-Csv -Path $filePath

    Text-Cyan "1. Connect to the first DC and the first EXC"
    Text-Cyan "2. Connect to each server individually"
    Text-Cyan "3. Connect to Exchange Management Shell on Exchange Server"
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        '1' {
            # Connect to the first DC
            $dcServer = ($servers | Where-Object {$_.type -eq 'DC'} | Select-Object -First 1).name
            $shouldRetry = Connect-DC -remoteComputer $dcServer
            if ($shouldRetry) { return }

            # Connect to the first Exchange Server
            $excServer = ($servers | Where-Object {$_.type -eq 'EXC'} | Select-Object -First 1).name
            $shouldRetry = Connect-EMS -exchangeServer $excServer
            if ($shouldRetry) { return }
        }
        '2' {
            # Connect to each server individually
            foreach ($server in $servers) {
                if ($server.type -eq 'EXC') {
                    $shouldRetry = Connect-EMS -exchangeServer $server.name
                } else {
                    $shouldRetry = Connect-DC -remoteComputer $server.name
                }
                if ($shouldRetry) { break }
            }
        }
        '3' {
            # Display a list of Exchange Servers and connect to the selected one
            $exchangeServers = $servers | Where-Object {$_.type -eq 'EXC'}
            $index = 1
            foreach ($server in $exchangeServers) {
                Write-Host "$index. $($server.name)"
                $index++
            }

            $userChoice = Read-Host "Select the Exchange Server number to connect to"
            if ($userChoice -match '^\d+$' -and $userChoice -le $exchangeServers.Count -and $userChoice -gt 0) {
                $selectedServer = $exchangeServers[$userChoice - 1].name
                Connect-EMS -exchangeServer $selectedServer
            } else {
                Write-Host "Invalid selection."
            }
        }
        default {
            Write-Host "Invalid option selected."
        }
    }
}
