function Get-MigrationStatistics {
    param (
        [string]$UserEmail
    )

    $continue = $true

    while ($continue) {
        Clear-Host
        Write-Host "Show Migration Progress"
        
        $Statistics = Get-MigrationUserStatistics $UserEmail | Select-Object BatchId, MailboxEmailAddress, PercentageComplete, StatusDetail, TotalInprogressDuration, BytesTransferred

        $Statistics | Format-Table -AutoSize  # Format the data for display
        Write-Host "Refreshing in 15 seconds..."
        
        # Check for user input to exit the loop
        $userInput = Read-Host "Press Enter to refresh or type 'exit' to exit"
        if ($userInput -eq "exit") {
            $continue = $false
        } else {
            for ($i = 1; $i -le 15; $i++) {
                Write-Host -NoNewline ("[")
                Write-Host -NoNewline ("=" * $i)
                Write-Host -NoNewline ("]")
                Start-Sleep -Seconds 1
                Write-Host -NoNewline ("`b" * ($i + 1))
            }
        }
    }
}