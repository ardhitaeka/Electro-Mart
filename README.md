# ElectroMart

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
