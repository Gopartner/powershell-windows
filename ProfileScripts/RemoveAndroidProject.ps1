function Remove-AndroidProject {
    [CmdletBinding()]
    param (
        [string]$ProjectRoot = "D:\android\projects"
    )

    if (-not (Test-Path $ProjectRoot)) {
        Write-Host "❌ Folder root tidak ditemukan: $ProjectRoot" -ForegroundColor Red
        return
    }

    # ---------- Util ----------
    function Hard-Delete ([string]$path) {
        try {
            Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
            Write-Host "✅ Terhapus permanen: $path" -ForegroundColor Green
        } catch {
            Write-Host "❌ Gagal hard delete: $path" -ForegroundColor Red
        }
    }

    function Bin-Delete ([string]$path) {
        try {
            Add-Type -AssemblyName Microsoft.VisualBasic
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($path,'SendToRecycleBin')
            Write-Host "🗑️  Ke Recycle Bin: $path" -ForegroundColor Green
        } catch {
            Write-Host "❌ Gagal ke Recycle Bin: $path" -ForegroundColor Red
        }
    }

    # ---------- Menu 2 : Konfirmasi ----------
    function Confirm-Menu ($paths) {
        do {
            Write-Host "`nPilih mode penghapusan:"
            Write-Host "  [A] Hapus permanen"
            Write-Host "  [B] Recycle Bin"
            Write-Host "  [C] Kembali"
            $opt = Read-Host "Pilihan (A/B/C)"

            switch -Regex ($opt) {
                '^[Aa]$' { $paths | ForEach-Object { Hard-Delete $_ }; return $true }
                '^[Bb]$' { $paths | ForEach-Object { Bin-Delete  $_ }; return $true }
                '^[Cc]$' { return $false }
            }
        } while ($true)
    }

    # ---------- Menu 1 : List project ----------
    function Project-Menu {
        $projects = Get-ChildItem -Path $ProjectRoot -Directory | Select-Object -ExpandProperty Name
        if (-not $projects) {
            Write-Host "📂 Tidak ada folder project di: $ProjectRoot" -ForegroundColor Yellow
            return
        }

        $items = $projects + '[SEMUA PROJECT]'
        $index = 0

        while ($true) {
            Clear-Host
            Write-Host "📁 Project Directory: $ProjectRoot`n"
            Write-Host "↑ ↓ = navigasi   Enter = pilih   Esc = keluar`n"

            for ($i = 0; $i -lt $items.Count; $i++) {
                if ($i -eq $index) {
                    Write-Host "➤ $($items[$i])" -ForegroundColor Cyan
                } else {
                    Write-Host "  $($items[$i])"
                }
            }

            switch ([Console]::ReadKey($true).Key) {
                'UpArrow'   { $index = ($index - 1 + $items.Count) % $items.Count }
                'DownArrow' { $index = ($index + 1) % $items.Count }
                'Escape'    { Write-Host "`nKeluar."; return }
                'Enter'     {
                    if ($items[$index] -eq '[SEMUA PROJECT]') {
                        $all = Get-ChildItem -Path $ProjectRoot -Directory | Select-Object -ExpandProperty FullName
                        $go  = Confirm-Menu $all
                    } else {
                        $go  = Confirm-Menu @(Join-Path $ProjectRoot $items[$index])
                    }
                    if ($go) { Pause "Tekan tombol apa saja…" }
                }
            }
        }
    }

    Project-Menu
}

Set-Alias rm-android Remove-AndroidProject
