function Export-AllTransportRule {
    # Export the transport rule collection
    $file = Export-TransportRuleCollection

    # Define the target path for the XML file
    $targetFolderPath = "C:\program\rules\"
    $fileName = "Rules.xml"
    $filePath = Join-Path -Path $targetFolderPath -ChildPath $fileName

    # Check if the target folder exists, create it if it doesn't
    if (-not (Test-Path -Path $targetFolderPath)) {
        New-Item -ItemType Directory -Path $targetFolderPath
    }

    # Save the file data to the specified path
    Set-Content -Path $filePath -Value $file.FileData -Encoding Byte

    # Optionally, you can add a message indicating successful completion
    Write-Host "Transport Rules exported successfully to $filePath"
}

function Extract-Commands {
    # Fixed path to the XML file
    $XmlFilePath = "C:\program\rules\Rules.xml"

    # Output path for the PS1 file
    $Ps1OutputPath = "C:\program\command-exported.ps1"

    # Check if the XML file exists
    if (-not (Test-Path -Path $XmlFilePath)) {
        Write-Error "The file $XmlFilePath does not exist."
        return
    }

    # Load the XML file
    [xml]$xmlContent = Get-Content -Path $XmlFilePath

    # Extract commands from <commandBlock> tags
    $commandBlocks = $xmlContent.SelectNodes("//commandBlock")
    $commands = $commandBlocks | ForEach-Object { $_.InnerText.Trim() }

    # Check if the target folder exists, create it if it doesn't
    $targetFolderPath = Split-Path -Path $Ps1OutputPath
    if (-not (Test-Path -Path $targetFolderPath)) {
        New-Item -ItemType Directory -Path $targetFolderPath
    }

    # Save the commands to the PS1 file
    $commands | Out-File -FilePath $Ps1OutputPath

    # Output a completion message
    Write-Host "Commands extracted to $Ps1OutputPath"
}

function Set-AllTransportRule {
    # Path to the exported PS1 file
    $Ps1FilePath = "C:\program\command-exported.ps1"

    # Check if the PS1 file exists
    if (-not (Test-Path -Path $Ps1FilePath)) {
        Write-Error "The file $Ps1FilePath does not exist."
        return
    }

    # Read and execute each command in the PS1 file
    try {
        . $Ps1FilePath
        Write-Host "All commands executed successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "An error occurred while executing the commands: $_"
    }
}