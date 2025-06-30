<#
.SYNOPSIS
    Pilih & hapus folder project Android di D:\android\projects secara interaktif.

.DESCRIPTION
    - Tampilkan semua sub‑folder project di D:\android\projects
    - Navigasi ↑ ↓, Enter = hapus project terpilih, Esc = batal
    - Tersedia prompt konfirmasi sebelum penghapusan
#>

function Remove-AndroidProject {
    param (
        [string]$ProjectRoot = 'D:\android\projects'
    )

    if (-not (Test-Path $ProjectRoot)) {
        Write-Host "Folder $ProjectRoot tidak ditemukan." -ForegroundColor Red
        return
    }

    $folders = Get-ChildItem -Path $ProjectRoot -Directory | Select-Object -ExpandProperty Name
    if (-not $folders) {
        Write-Host "Tidak ada sub‑folder project di $ProjectRoot." -ForegroundColor Yellow
        return
    }

    # --- Logic menu sederhana ---
    $index = 0
    Show-Menu

    function Show-Menu {
        Clear-Host
        Write-Host "Pilih project yang ingin dihapus (Esc = batal):`n"
        for ($i = 0; $i -lt $folders.Count; $i++) {
            if ($i -eq $index) {
                Write-Host "> $($folders[$i])" -ForegroundColor Cyan
            }
            else {
                Write-Host "  $($folders[$i])"
            }
        }

        switch ([System.Console]::ReadKey($true).Key) {
            'UpArrow' { $index = ($index - 1) % $folders.Count; Show-Menu }
            'DownArrow' { $index = ($index + 1) % $folders.Count; Show-Menu }
            'Enter' { Confirm-Delete }
            'Escape' { Clear-Host; Write-Host "Dibatalkan."; return }
            default { Show-Menu }
        }
    }

    function Confirm-Delete {
        $choice = Read-Host "Hapus folder '$($folders[$index])'? (Y/N)"
        if ($choice -match '^[Yy]$') {
            $targetPath = Join-Path $ProjectRoot $folders[$index]
            try {
                Remove-Item -Path $targetPath -Recurse -Force
                Write-Host "✅  Project terhapus:`n$targetPath" -ForegroundColor Green
            }
            catch {
                Write-Host "⚠️  Gagal menghapus: $_" -ForegroundColor Red
            }
        }
        else {
            Write-Host "Penghapusan dibatalkan."
        }
    }
}

# OPTIONAL: alias pendek
Set-Alias rm-android Remove-AndroidProject
