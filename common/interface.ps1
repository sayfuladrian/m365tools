function Text-Black {
    param([string]$text)
    Write-Host $text -ForegroundColor Black
}

function Text-Blue {
    param([string]$text)
    Write-Host $text -ForegroundColor Blue
}

function Text-Cyan {
    param([string]$text)
    Write-Host $text -ForegroundColor Cyan
}

function Text-DarkGray {
    param([string]$text)
    Write-Host $text -ForegroundColor DarkGray
}

function Text-Green {
    param([string]$text)
    Write-Host $text -ForegroundColor Green
}

function Text-Magenta {
    param([string]$text)
    Write-Host $text -ForegroundColor Magenta
}

function Text-Red {
    param([string]$text)
    Write-Host $text -ForegroundColor Red
}

function Text-White {
    param([string]$text)
    Write-Host $text -ForegroundColor White
}

function Text-Yellow {
    param([string]$text)
    Write-Host $text -ForegroundColor Yellow
}

function Get-Hostname {
    return [System.Net.Dns]::GetHostName()
}

function Write-Title {
    param ([string]$Title)

    clear

    $width = $Host.UI.RawUI.WindowSize.Width

    $titleText = "  $Title  "
    $titleLength = $titleText.Length

    Write-Border
    Write-Dash $width $titleLength
    Write-Host $titleText -NoNewline -ForegroundColor Green
    Write-Dash $width $titleLength

    if ($width % 2 -ne 0 -and $titleLength % 2 -ne 0) {
        Write-Host " "
    }

    $hostname = Get-Hostname
    $hostText = "Connected from:  $hostname  "
    $hostLength = $hostText.Length

    Write-Dash $width $hostLength
    Write-Host $hostText -NoNewline -ForegroundColor Green
    Write-Dash $width $hostLength

    if ($width % 2 -ne 0 -and $hostLength % 2 -ne 0) {
        Write-Host " "
    }

    Write-Border
}

function Write-Danger {
    param ([string]$Title)

    clear

    $width = $Host.UI.RawUI.WindowSize.Width

    $titleText = "  $Title  "
    $titleLength = $titleText.Length

    Write-Border Red
    Write-Dash $width $titleLength
    Write-Host $titleText -NoNewline -ForegroundColor Red
    Write-Dash $width $titleLength

    if ($width % 2 -ne 0 -and $titleLength % 2 -ne 0) {
        Write-Host " "
    }

    Write-Border Red
}

function Write-Dash {
    param([int]$width, [int]$textLength)

    $dashCount = [Math]::Floor(($width - $textLength) / 2)
    $dashes = " " * $dashCount
    Write-Host $dashes -NoNewline
}

function Write-Border {
    param (
        [string]$color = 'Green',
        [char]$borderChar = '='
    )

    $width = $Host.UI.RawUI.WindowSize.Width
    $border = $borderChar * $width
    Write-Host $border -ForegroundColor $color
}

function Write-Separator {
    param (
        [string]$color = 'Yellow',
        [char]$borderChar = '-'
    )

    Write-Host
    Write-Border -color $color -borderChar $borderChar
    Write-Host
}

function Wait-Key {
    param(
        [int]$TimeoutInSeconds = 10,
        [string]$Message = "Press 'Space' to pause or any other key to proceed immediately..."
    )

    Write-Host
    Write-Host
    Write-Host $Message -ForegroundColor Yellow
    $host.UI.RawUI.FlushInputBuffer()
    $startTime = Get-Date
    $totalTicks = 50
    $paused = $false

    for ($i = 0; $i -le $TimeoutInSeconds; $i++) {
        if ([console]::KeyAvailable) {
            $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            if ($key.Character -eq ' ' -and -not $paused) {
                Write-Host "`nPaused. Press any key to continue..." -ForegroundColor Yellow
                $paused = $true
                $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                $startTime = Get-Date  # Reset timer
                $i = 0  # Reset loop counter
                Write-Host "`nResuming..." -ForegroundColor Yellow
            } elseif ($paused) {
                break
            }
        }

        if (-not $paused) {
            $ticks = [Math]::Round(($i / $TimeoutInSeconds) * $totalTicks)
            $progressBar = "[" + "=" * $ticks + " " * ($totalTicks - $ticks) + "]"
            $secondsLeft = $TimeoutInSeconds - $i
            
            Write-Host "`r$progressBar              $secondsLeft`s to skip" -NoNewLine -ForegroundColor Yellow

            Start-Sleep -Seconds 1
        }
    }
    Write-Host "`n"
}