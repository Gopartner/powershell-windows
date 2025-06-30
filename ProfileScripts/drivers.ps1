function Show-Info {
    param (
        [ValidateSet('driver')]
        [string]$Category
    )

    if ($Category -ieq 'driver') {
        Write-Host "`nDaftar Driver Terinstal (via pnputil)" -ForegroundColor Cyan

        $rawOutput = pnputil /enum-drivers 2>&1
        $drivers = @()
        $entry = @{}

        foreach ($line in $rawOutput) {
            if ($line -match '^Published Name\s*:\s*(.+)$') {
                $entry = @{ PublishedName = $matches[1].Trim() }
            }
            elseif ($line -match '^Original Name\s*:\s*(.+)$') {
                $entry.OriginalName = $matches[1].Trim()
            }
            elseif ($line -match '^Provider Name\s*:\s*(.+)$') {
                $entry.ProviderName = $matches[1].Trim()
            }
            elseif ($line -match '^Class Name\s*:\s*(.+)$') {
                $entry.ClassName = $matches[1].Trim()
            }
            elseif ($line -match '^Driver Version\s*:\s*(.+)$') {
                $entry.Version = $matches[1].Trim()
            }
            elseif ($line -match '^Signer Name\s*:\s*(.+)$') {
                $entry.Signer = $matches[1].Trim()

                if ($entry.Count -gt 0) {
                    $drivers += [PSCustomObject]$entry
                    $entry = @{}
                }
            }
        }

        if ($drivers.Count -eq 0) {
            Write-Host "Tidak ditemukan driver yang terinstal." -ForegroundColor Red
            return
        }

        $drivers | Sort-Object ProviderName | Format-Table `
            ProviderName, OriginalName, ClassName, Version, Signer -AutoSize
        return
    }

    Write-Host "Perintah 'show $Category' tidak dikenali. Gunakan: Show-Info driver" -ForegroundColor Red
}
