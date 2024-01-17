. .\common\interface.ps1

function Copy-M365Tools {
    param(
        [string]$sourceDir = "E:\VisualStudio\github\m365tools",
        [string]$destinationDir = "E:\VisualStudio\github\m365toolsTXT"
    )

    Clear-Host
    Write-Title "UPDATE THE TXT FILES FOR CHATGPT"
    $ps1Files = Get-ChildItem -Path $sourceDir -Recurse -Filter *.ps1
    foreach ($file in $ps1Files) {
        $relativePath = $file.FullName.Substring($sourceDir.Length)
        $newFilePath = [IO.Path]::ChangeExtension($destinationDir + $relativePath, ".txt")
        Check-Folders -destinationSubDir (Split-Path -Path $newFilePath -Parent)
        if (Compare-Files -sourceFile $file.FullName -destinationFile $newFilePath) {
            Copy-File -sourceFile $file.FullName -destinationFile $newFilePath
        }
    }

    Wait-Key -info "The files has been copied successfully." -TextColor "Green"
}

function Compare-Files {
    param(
        [string]$sourceFile,
        [string]$destinationFile
    )

    if (-not (Test-Path -Path $destinationFile) -or (Get-Hash -filePath $sourceFile) -ne (Get-Hash -filePath $destinationFile)) {
        return $true
    } else {
        Text-Green "Up-to-date: $sourceFile matches $destinationFile"
        return $false
    }
}

function Check-Folders {
    param(
        [string]$destinationSubDir
    )

    if (-not (Test-Path -Path $destinationSubDir)) {
        New-Item -ItemType Directory -Path $destinationSubDir -Force
        Write-Host "Created folder: $destinationSubDir"
    }
}

function Copy-File {
    param(
        [string]$sourceFile,
        [string]$destinationFile
    )

    Copy-Item -Path $sourceFile -Destination $destinationFile
    Text-Cyan "Copied and renamed `"$sourceFile`" to `"$destinationFile`"."
}

function Get-Hash {
    param(
        [string]$filePath
    )

    $hashAlgorithm = 'SHA256'
    try {
        $hash = Get-FileHash -Path $filePath -Algorithm $hashAlgorithm
        return $hash.Hash
    }
    catch {
        Write-Host "Unable to compute hash for file: $filePath"
        return $null
    }
}

function Compress-M365Tools {
    param(
        [string]$sourceDir = "E:\VisualStudio\github\m365toolsTXT",
        [string]$destinationZip = "E:\VisualStudio\github\m365toolsTXT\m365ToolsTXT.zip"
    )

    Clear-Host
    Write-Title "Compress M365Tools to ZIP"

    # Ensure the source directory exists
    if (Test-Path -Path $sourceDir) {
        # Remove the existing zip file if it exists
        if (Test-Path -Path $destinationZip) {
            Remove-Item -Path $destinationZip
            Text-Red "The current ZIP files has been deleted."
        }

        # Create a zip archive of all files in the source directory
        Compress-Archive -Path "$sourceDir\*" -DestinationPath $destinationZip

        Wait-Key -info "Created zip archive at: $destinationZip" -TextColor "Green"
    } else {
        Wait-Key -info "The source directory $sourceDir does not exist." -TextColor "Red"
    }
}

function Pull-M365Tools {
    param (
        [string]$sourcePath = "\\172.16.10.24\m365tools$\",
        [string]$destinationPath = "C:\m365tools\"
    )

    Clear-Host
    Write-Title "Download all files from SVR-JUMPHOST"

    # Ensure the source directory exists
    if (Test-Path -Path $sourcePath) {
        # Check and create the destination directory if needed
        Check-Folders -destinationSubDir $destinationPath

        # Get all the files in the source directory
        $files = Get-ChildItem -Path $sourcePath -Recurse -File | Where-Object { $_.FullName -notmatch '\\.git\\' }

        # Copy each file individually
        foreach ($file in $files) {
            $relativePath = $file.FullName.Substring($sourcePath.Length)
            $destinationFile = [System.IO.Path]::Combine($destinationPath, $relativePath)
            $destinationDir = [System.IO.Path]::GetDirectoryName($destinationFile)

            # Check and create the destination directory if needed
            Check-Folders -destinationSubDir $destinationDir

            # Copy the file using the Copy-File function
            Copy-File -sourceFile $file.FullName -destinationFile $destinationFile
        }

        Write-Host "All files downloaded successfully."
    } else {
        Write-Host "Source path does not exist."
    }
}

function Push-M365Tools {
    param (
        [string]$sourcePath = "E:\VisualStudio\github\m365tools\",
        [string]$destinationPath = "\\172.16.10.24\m365tools$\"
    )

    Clear-Host
    Write-Title "Update all files in the SVR-JUMPHOST"

    # Ensure the source directory exists
    if (Test-Path -Path $sourcePath) {
        # Check and create the destination directory if needed
        Check-Folders -destinationSubDir $destinationPath

        # Get all the files in the source directory
        $files = Get-ChildItem -Path $sourcePath -Recurse -File

        # Copy each file individually
        foreach ($file in $files) {
            $destinationFile = [System.IO.Path]::Combine($destinationPath, $file.FullName.Substring($sourcePath.Length))
            $destinationDir = [System.IO.Path]::GetDirectoryName($destinationFile)

            # Check and create the destination directory if needed
            Check-Folders -destinationSubDir $destinationDir

            # Copy the file using the Copy-File function
            Copy-File -sourceFile $file.FullName -destinationFile $destinationFile
        }

        Write-Host "All files copied successfully."
    } else {
        Write-Host "Source path does not exist."
    }
}