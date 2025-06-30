# File: app.ps1   (UTF-8)

function app {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    # ----- LIST -----
    if (-not $Args -or $Args[0] -in @('-l', 'list')) {
        Write-Host "`n===  Aplikasi Win32  ===" -ForegroundColor Yellow
        $regPaths = @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        )
        Get-ItemProperty $regPaths |
        Where-Object DisplayName |
        Select-Object DisplayName, DisplayVersion, Publisher |
        Sort-Object DisplayName |
        Format-Table -AutoSize

        Write-Host "`n===  Aplikasi Store  ===" -ForegroundColor Yellow
        Get-AppxPackage |
        Select-Object Name, Version, Publisher |
        Sort-Object Name |
        Format-Table -AutoSize
        return
    }

    Write-Host "Perintah tidak dikenali. Pakai:  app -l  atau  app list" -ForegroundColor Red
}
