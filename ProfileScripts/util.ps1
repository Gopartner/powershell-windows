# File: util.ps1

function Show-Env {
    Write-Host "`n🧠 Environment Info" -ForegroundColor Yellow
    Write-Host "User     : $env:USERNAME"
    Write-Host "Computer : $env:COMPUTERNAME"
    Write-Host "OS       : $([System.Environment]::OSVersion.VersionString)"
    Write-Host "Arch     : $env:PROCESSOR_ARCHITECTURE"
    Write-Host "Shell    : $($PSVersionTable.PSVersion)"
}

function Show-Time {
    $now = Get-Date -Format "HH:mm:ss - dd/MM/yyyy"
    Write-Host "`n🕒 Sekarang: $now" -ForegroundColor Cyan
}

function Show-Line {
    param (
        [int]$Length = 50,
        [string]$Char = '─'
    )
    Write-Host ($Char * $Length) -ForegroundColor DarkGray
}
