Berikut ini adalah draft dokumen **`README.md`** untuk fungsi PowerShell interaktif `Remove-AndroidProject` yang sudah kamu buat. Bisa langsung kamu simpan di folder `ProfileScripts/` atau repositori Git kamu:

---

## 📁 Remove-AndroidProject.ps1

Fungsi PowerShell interaktif untuk **menghapus project Android** dari folder `D:\android\projects` dengan navigasi keyboard (↑ ↓ Enter Esc) langsung dari terminal.

---

### 🎯 Fitur

* Menampilkan daftar folder project
* Navigasi dengan **↑ / ↓**
* Pilih folder dengan **Enter**
* Konfirmasi penghapusan (**Y/N**)
* Keluar tanpa menghapus dengan **Esc**
* Bisa diintegrasikan otomatis lewat `$PROFILE`
* Mendukung alias pendek `rm-android`

---

### 🧩 Cara Install

1. Buat folder (jika belum ada):

   ```
   $HOME\Documents\WindowsPowerShell\ProfileScripts\
   ```

2. Simpan file ini sebagai:

   ```
   RemoveAndroidProject.ps1
   ```

3. Pastikan `$PROFILE` kamu memuat semua file `.ps1` dari `ProfileScripts`, contoh loader:

   ```powershell
   $profileRoot = Split-Path $PROFILE
   $modulePath = Join-Path $profileRoot "ProfileScripts"

   if (Test-Path $modulePath) {
       Get-ChildItem -Path $modulePath -Filter *.ps1 | ForEach-Object {
           try {
               . $_.FullName
           }
           catch {
               Write-Warning "⚠️ Gagal memuat $($_.Name): $_"
           }
       }
   }
   ```

4. Reload profil:

   ```powershell
   . $PROFILE
   ```

---

### 🚀 Cara Pakai

```powershell
Remove-AndroidProject
```

Atau:

```powershell
rm-android
```

### 🎮 Navigasi:

| Tombol | Fungsi             |
| ------ | ------------------ |
| ↑ / ↓  | Navigasi folder    |
| Enter  | Pilih & konfirmasi |
| Esc    | Batal keluar       |
| Y / N  | Konfirmasi hapus   |

---

### 🔒 Opsi Aman (hapus ke Recycle Bin)

Ganti baris `Remove-Item` dengan:

```powershell
Add-Type -AssemblyName Microsoft.VisualBasic
[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($targetPath, 'SendToRecycleBin')
```

---

### 🛠 Alias

```powershell
Set-Alias rm-android Remove-AndroidProject
```

---

### 📌 Catatan

* Dirancang untuk PowerShell Windows (`WindowsPowerShell`)
* Bisa diintegrasikan ke PowerShell 7 atau VSCode Terminal dengan:

  ```powershell
  # Di Microsoft.VSCode_profile.ps1
  $winProfile = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
  if (Test-Path $winProfile) { . $winProfile }
  ```

---

### 📷 Contoh Tampilan

```
📁 Project Directory: D:\android\projects

Gunakan ↑ ↓ untuk memilih project, Enter untuk hapus, Esc untuk batal.

➤ MyApp01
  MyApp02
  TesFirebase
```
