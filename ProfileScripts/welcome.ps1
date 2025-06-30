function Show-Welcome {
    $hour = (Get-Date).Hour
    $nama = $env:USERNAME

    if ($hour -lt 11) {
        $salam = "Selamat pagi"
    }
    elseif ($hour -lt 15) {
        $salam = "Selamat siang"
    }
    elseif ($hour -lt 18) {
        $salam = "Selamat sore"
    }
    else {
        $salam = "Selamat malam"
    }

    $jam = Get-Date -Format "HH:mm:ss"
    Write-Host "$salam, $nama! Sekarang jam $jam." -ForegroundColor Cyan
}
