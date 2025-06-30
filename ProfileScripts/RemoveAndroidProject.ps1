function Remove-AndroidProject {
    [CmdletBinding()]
    param (
        [string]$ProjectRoot = "D:\android\projects"
    )

    if (-not (Test-Path $ProjectRoot)) {
        Write-Host "❌ Folder root tidak ditemukan: $ProjectRoot" -ForegroundColor Red
        return
    }

    $projects = Get-ChildItem -Path $ProjectRoot -Directory | Select-Object -ExpandProperty Name
    if (-not $projects.Count) {
        Write-Host "📂 Tidak ada folder project di: $ProjectRoot" -ForegroundColor Yellow
        return
    }

    $selectedIndex = 0

    function Show-ProjectMenu {
        do {
            Clear-Host
            Write-Host "📁 Project Directory: $ProjectRoot`n"
            Write-Host "Gunakan ↑ ↓ untuk memilih project, Enter untuk hapus, Esc untuk batal.`n"

            for ($i = 0; $i -lt $projects.Count; $i++) {
                if ($i -eq $selectedIndex) {
                    Write-Host "➤ $($projects[$i])" -ForegroundColor Cyan
                } else {
                    Write-Host "  $($projects[$i])"
                }
            }

            $key = [Console]::ReadKey($true).Key
            switch ($key) {
                'UpArrow'   { $selectedIndex = ($selectedIndex - 1 + $projects.Count) % $projects.Count }
                'DownArrow' { $selectedIndex = ($selectedIndex + 1) % $projects.Count }
                'Enter'     { Confirm-Deletion; return }
                'Escape'    { Write-Host "`n❎ Dibatalkan." -ForegroundColor Yellow; return }
            }
        } while ($true)
    }

    function Confirm-Deletion {
        $projectName = $projects[$selectedIndex]
        $targetPath  = Join-Path $ProjectRoot $projectName

        Write-Host "`n⚠️  Kamu memilih: $projectName"
        $ok = Read-Host "Apakah yakin hapus? (Y/N)"
        if ($ok -match '^[Yy]$') {
            try {
                Remove-Item -Path $targetPath -Recurse -Force -ErrorAction Stop
                Write-Host "`n✅ Terhapus: $targetPath" -ForegroundColor Green
            } catch {
                Write-Host "`n❌ Gagal: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "`n⏭️  Batal hapus." -ForegroundColor Yellow
        }
    }

    Show-ProjectMenu
}

Set-Alias rm-android Remove-AndroidProject
