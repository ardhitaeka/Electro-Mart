# ElectroMart

Tugas akhir mobile programming semester 4 - Kelompok 1

Aplikasi demo e-commerce elektronik berbasis Flutter dan Dart. Data produk,
favorit, keranjang, kategori, stok, dan pesanan disimpan di memori selama aplikasi
berjalan. Aplikasi tidak menggunakan backend atau Firebase.

## Menjalankan aplikasi

1. Pasang Flutter SDK dan Android Studio, lalu siapkan Android SDK/emulator atau
   sambungkan perangkat Android dengan USB debugging.
2. Dari folder proyek, jalankan `flutter pub get`.
3. Jalankan `flutter run` untuk membuka aplikasi pada perangkat Android yang
   terdeteksi. Untuk membuat APK debug, gunakan `flutter build apk --debug`.

Gambar katalog dimuat dari Unsplash dan memerlukan koneksi internet. Ikon
pengganti akan tampil bila gambar tidak dapat dimuat.

## Akun demo

| Peran | Email | Kata sandi |
|---|---|---|
| Admin | admin@electromart.com | admin123 |
| User | user@electromart.com | user123 |

Tombol akun demo pada layar masuk dapat digunakan untuk langsung mencoba kedua
peran. Perubahan data berlaku selama aplikasi berjalan dan dapat dilihat bersama
oleh Admin dan User.

## Autosync ke GitHub

`autosync.ps1` melakukan commit, `pull --rebase`, dan `push` otomatis ke GitHub
setiap 60 detik selama script berjalan.

```powershell
# PowerShell
.\autosync.ps1
```

atau klik dua kali `autosync.cmd` (Command Prompt). Hentikan dengan `Ctrl+C`.
Opsi lain:

```powershell
.\autosync.ps1 -IntervalSeconds 120   # interval lain
.\autosync.ps1 -Branch main           # branch lain
.\autosync.ps1 -Once                  # satu siklus saja
```

Aktivitas tercatat di `autosync.log` (diabaikan git). Bila `pull --rebase`
mengalami konflik, script membatalkan rebase, mencatat peringatan, dan mencoba
lagi pada siklus berikutnya.
