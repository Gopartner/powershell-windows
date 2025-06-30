# ============================================
# File: $PROFILE (Microsoft.PowerShell_profile.ps1)
# Entry utama untuk load semua fungsi modular
# ============================================

$profileRoot = Split-Path $PROFILE
$modulePath = Join-Path $profileRoot "ProfileScripts"

# --------------------------------------------
# Import semua file .ps1 dari folder ProfileScripts
# --------------------------------------------
if (Test-Path $modulePath) {
    Get-ChildItem -Path $modulePath -Filter *.ps1 | ForEach-Object {
        try {
            . $_.FullName
        }
        catch {
            Write-Warning "⚠️  Gagal memuat $($_.Name): $_"
        }
    }
}
else {
    Write-Warning "⚠️  Folder $modulePath tidak ditemukan."
}

# --------------------------------------------
# Fungsi untuk reload ulang profile
# Menggunakan Approved Verb: Import
# --------------------------------------------
function Import-Profile {
    . $PROFILE
    Write-Host "`n🔄 Profil berhasil dimuat ulang." -ForegroundColor Green
}

# --------------------------------------------
# Alias: show → Show-Info (agar bisa pakai show driver)
# --------------------------------------------
if (Get-Command -Name Show-Info -ErrorAction SilentlyContinue) {
    Set-Alias show Show-Info
}

# --------------------------------------------
# Auto panggil fungsi saat startup
# --------------------------------------------
# if (Get-Command -Name bersihkan -ErrorAction SilentlyContinue) {
#     bersihkan
# }

if (Get-Command -Name Show-Welcome -ErrorAction SilentlyContinue) {
    Show-Welcome
}

if (Get-Command -Name Show-Shortcuts -ErrorAction SilentlyContinue) {
    Show-Shortcuts
}
