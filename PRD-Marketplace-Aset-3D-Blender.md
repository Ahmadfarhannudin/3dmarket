# PRD: Aplikasi Mobile Marketplace Aset 3D Blender

Versi 1.0 · 10 November 2026 · Status: Draft untuk review

## 1. Ringkasan Produk

Aplikasi mobile untuk menjual dan membagikan aset 3D buatan Blender (model, texture, material, scene, dll). Aplikasi memiliki dua sisi: **Dashboard Admin** (pemilik bisnis, satu-satunya yang meng-upload aset) dan **Tampilan Pembeli/Storefront** (pengguna yang menjelajah, mendownload aset gratis, dan membeli aset premium).

**Asumsi penting:** istilah 'tampilan penjual' pada brief diartikan sebagai *storefront* tempat aset ditampilkan kepada pelanggan (pembeli), karena yang meng-upload hanya admin. Jika nanti ingin membuka kesempatan bagi kreator lain untuk berjualan (multi-vendor), itu masuk fase pengembangan berikutnya (lihat bagian Roadmap).

## 2. Tujuan dan Metrik Keberhasilan

**Tujuan bisnis**

- Menjadi kanal penjualan langsung aset 3D milik sendiri tanpa potongan marketplace pihak ketiga.
- Menarik pengguna lewat aset gratis, lalu mengonversi sebagian menjadi pembeli aset premium.
- Membangun basis pengguna dan komunitas untuk jangka panjang.

**Metrik (target 3 bulan pertama, dapat disesuaikan)**

| Metrik | Target awal |
|---|---|
| Jumlah download aplikasi | 1.000 |
| Konversi pengguna gratis ke pembeli | 3–5% |
| Rasio checkout berhasil | di atas 80% |
| Retensi hari ke-30 | di atas 15% |
| Jumlah aset aktif di katalog | 50+ |

## 3. Target Pengguna

**Persona 1: Pembeli (3D artist/hobbyist/pelajar).** Pengguna Blender yang mencari model, material, atau scene siap pakai untuk menghemat waktu. Kebutuhan: pencarian cepat, preview yang meyakinkan sebelum membayar, proses bayar yang mudah, file mudah diunduh ulang.

**Persona 2: Admin (pemilik bisnis).** Satu orang yang mengelola seluruh katalog. Kebutuhan: upload mudah, atur harga dan status gratis/premium, lihat penjualan, kelola pesanan dan pengguna.

## 4. Ruang Lingkup

**Masuk MVP**

- Registrasi dan login pembeli, login admin.
- Katalog aset dengan kategori, pencarian, dan filter gratis/premium.
- Halaman detail aset dengan galeri gambar dan preview 3D interaktif.
- Download aset gratis (wajib login).
- Pembelian aset premium dan download setelah pembayaran terverifikasi.
- Library 'Aset Saya' (riwayat unduhan dan pembelian).
- Wishlist: simpan aset incaran ke daftar keinginan, lihat dan kelola dari halaman khusus.
- Dashboard admin: upload aset, kelola katalog, lihat transaksi, ringkasan penjualan.

**Di luar MVP (fase berikutnya)**

- Multi-vendor (kreator lain bisa upload dan berjualan).
- Langganan bulanan (akses semua aset premium).
- Review dan rating, kupon, bundle.
- Plugin Blender untuk memasang aset langsung dari aplikasi.

## 5. App Flow

### 5.1 Alur Pembeli

1. **Buka aplikasi** → splash screen → onboarding singkat (hanya pertama kali).
2. **Beranda** → melihat aset unggulan, aset terbaru, kategori, dan banner promo. Pengguna boleh menjelajah tanpa login.
3. **Cari/filter** → pencarian kata kunci, filter kategori, filter Gratis/Premium, urutan (terbaru, terpopuler, harga).
4. **Detail aset** → galeri gambar, preview 3D yang bisa diputar, deskripsi, format file (.blend, .fbx, .obj), ukuran file, jumlah polygon, versi Blender yang kompatibel, lisensi, harga atau label Gratis. Terdapat tombol **Wishlist (♡)** untuk menyimpan aset ke daftar keinginan.
5. **Percabangan:**
   - **Aset Gratis** → tombol Download → jika belum login, diarahkan ke login/daftar → file terunduh → tersimpan di 'Aset Saya'.
   - **Aset Premium** → tombol Beli → jika belum login, diarahkan ke login/daftar → halaman checkout → pilih metode pembayaran → bayar → sistem memverifikasi pembayaran otomatis → status berhasil → tombol Download aktif → tersimpan di 'Aset Saya'.
   - **Wishlist** → tombol ♡ di halaman detail → jika belum login, diarahkan ke login/daftar → aset tersimpan ke wishlist → ikon berubah menjadi ♥ (filled). Tap lagi untuk menghapus dari wishlist.
6. **Wishlist** → daftar aset yang disimpan pengguna. Bisa langsung menuju detail aset, membeli, atau menghapus dari wishlist. Aset yang sudah dibeli otomatis ditandai.
7. **Aset Saya** → daftar aset yang sudah diunduh/dibeli, bisa diunduh ulang kapan saja.
8. **Profil** → data akun, riwayat transaksi, bantuan, logout.

### 5.2 Alur Admin

1. **Login admin** (akun khusus dengan role admin).
2. **Dashboard** → ringkasan: total penjualan, pendapatan, jumlah download, aset terlaris, transaksi terbaru.
3. **Upload aset baru** → isi judul, deskripsi, kategori, tag → upload file aset (.blend/.zip) → upload gambar thumbnail dan galeri → upload file preview 3D (.glb) → pilih tipe **Gratis** atau **Premium** (jika premium, isi harga) → pilih status Draft atau Publish → simpan.
4. **Kelola aset** → edit, ganti file/versi, ubah harga, ubah gratis↔premium, sembunyikan atau hapus.
5. **Kelola transaksi** → daftar pesanan, status pembayaran (menunggu, berhasil, gagal, refund), detail pembeli.
6. **Kelola pengguna** → daftar pengguna, blokir jika perlu.
7. **Kelola kategori dan banner** → atur kategori dan promo di beranda.

### 5.3 Alur Pembayaran (detail)

1. Pembeli menekan Beli → sistem membuat order dengan status *Pending*.
2. Sistem meminta payment gateway membuat transaksi → pembeli diarahkan ke halaman pembayaran (QRIS, e-wallet, transfer virtual account).
3. Pembeli membayar → payment gateway mengirim *webhook* ke server.
4. Server memverifikasi webhook → status order menjadi *Paid* → izin download dibuka.
5. Jika pembayaran kedaluwarsa atau gagal → status *Expired/Failed*, pembeli bisa mencoba lagi.

## 6. Core Features

### 6.1 Sisi Pembeli

| Fitur | Deskripsi | Prioritas |
|---|---|---|
| Autentikasi | Daftar/login dengan email atau Google, lupa password | P0 |
| Katalog dan beranda | Aset unggulan, terbaru, per kategori | P0 |
| Pencarian dan filter | Kata kunci, kategori, Gratis/Premium, harga, urutan | P0 |
| Detail aset | Galeri, spesifikasi, lisensi, label Gratis/Premium | P0 |
| Preview 3D interaktif | Putar, zoom, lihat model dalam format .glb sebelum membeli | P0 |
| Download gratis | Unduh langsung setelah login | P0 |
| Checkout premium | Pembayaran lewat payment gateway (QRIS, e-wallet, VA) | P0 |
| Aset Saya | Library semua aset yang dimiliki, unduh ulang | P0 |
| Wishlist | Simpan aset incaran ke daftar keinginan, lihat dan kelola dari halaman khusus, langsung beli/download dari wishlist | P0 |
| Riwayat transaksi | Daftar pembelian dan status | P1 |
| Notifikasi | Pembayaran berhasil, aset baru, promo | P1 |
| Rating dan review | Ulasan dari pembeli yang sudah memiliki aset | P2 |

### 6.2 Sisi Admin

| Fitur | Deskripsi | Prioritas |
|---|---|---|
| Login admin dengan role | Akses terpisah dan aman | P0 |
| Upload aset | File aset, thumbnail, galeri, preview .glb, metadata | P0 |
| Atur tipe dan harga | Gratis atau Premium, harga dalam Rupiah | P0 |
| Kelola katalog | Edit, draft/publish, sembunyikan, hapus, ganti versi file | P0 |
| Kelola transaksi | Daftar order, status pembayaran, refund manual | P0 |
| Statistik penjualan | Pendapatan, aset terlaris, download per aset, grafik periode | P1 |
| Kelola pengguna | Lihat dan blokir pengguna | P1 |
| Kelola kategori dan banner | Atur tampilan beranda | P1 |
| Kupon dan diskon | Kode promo atau potongan harga | P2 |

## 7. Model Bisnis: Gratis vs Premium

| Aspek | Gratis | Premium |
|---|---|---|
| Akses | Wajib login, lalu unduh | Wajib login dan bayar |
| Fungsi bisnis | Menarik pengguna, membangun kepercayaan | Sumber pendapatan |
| Preview | Penuh | Preview 3D dan galeri penuh, file asli terkunci |
| Lisensi | Misal: personal use | Misal: personal dan komersial |
| Harga | Rp 0 | Ditentukan admin per aset |

**Saran strategi:** sediakan beberapa aset gratis berkualitas tinggi sebagai 'sample' dari kualitas aset premium. Pertimbangkan nanti menambah **paket langganan** dan **bundle**.

## 8. Requirement Fungsional Utama

- Pengguna wajib login untuk mengunduh aset (gratis maupun premium) agar download dapat dilacak.
- File aset premium **tidak boleh** dapat diakses lewat URL publik. Unduhan menggunakan *signed URL* sementara yang hanya dibuat setelah server memastikan pengguna berhak.
- Satu order dapat berisi satu atau lebih aset.
- Pembeli dapat mengunduh ulang aset yang sudah dibeli tanpa batas waktu (atau dengan batas wajar, misal 10 kali per aset per hari untuk mencegah penyalahgunaan).
- Admin dapat mengganti file aset dengan versi baru, dan pembeli lama mendapat akses ke versi terbaru.
- Harga ditampilkan dalam Rupiah (IDR); dukungan mata uang lain di fase berikutnya.
- Preview 3D memakai format .glb yang ringan, terpisah dari file asli .blend.

## 9. Requirement Non-Fungsional

- **Performa:** halaman katalog termuat di bawah 3 detik pada koneksi 4G; thumbnail dioptimasi dan memakai lazy loading.
- **Penyimpanan file besar:** file aset bisa ratusan MB; gunakan object storage dan unduhan yang bisa dilanjutkan (resume).
- **Keamanan:** HTTPS, password di-hash, role-based access (admin vs pembeli), validasi webhook pembayaran, proteksi file premium.
- **Ketersediaan:** target uptime 99%.
- **Kompatibilitas:** Android 8+ dan iOS 15+.
- **Skalabilitas:** arsitektur siap menambah multi-vendor dan langganan.

## 10. Model Data (Garis Besar)

- **User:** id, nama, email, password hash, role (admin/pembeli), status.
- **Asset:** id, judul, deskripsi, kategori, tag, tipe (free/premium), harga, status (draft/published), format, ukuran, jumlah polygon, versi Blender, lisensi, URL thumbnail, URL preview .glb, path file asli, jumlah download.
- **Category:** id, nama, ikon.
- **Order:** id, user, total, status (pending/paid/failed/expired/refunded), metode bayar, referensi payment gateway, waktu.
- **OrderItem:** order, asset, harga saat dibeli.
- **UserAsset (library):** user, asset, sumber (gratis/dibeli), waktu akses.
- **DownloadLog:** user, asset, waktu, perangkat.
- **Wishlist:** id, user, asset, waktu ditambahkan.

## 11. Rekomendasi Teknologi

Beberapa opsi yang cocok untuk satu developer atau tim kecil:

| Lapisan | Rekomendasi |
|---|---|
| Aplikasi mobile | Flutter atau React Native (satu kode untuk Android dan iOS) |
| Preview 3D | Viewer berbasis glTF/.glb (misal model-viewer di WebView, atau library 3D native) |
| Backend | Node.js (NestJS/Express) atau Laravel |
| Database | PostgreSQL atau MySQL |
| Penyimpanan file | Object storage S3-compatible (AWS S3, Cloudflare R2, dsb.) |
| Pembayaran | Midtrans atau Xendit (QRIS, e-wallet, virtual account) |
| Dashboard admin | Aplikasi web admin (lebih praktis untuk upload file besar dari laptop) atau halaman admin di dalam aplikasi |
| Notifikasi | Firebase Cloud Messaging |

**Catatan:** admin sebaiknya mengunggah aset dari laptop lewat dashboard web, karena file Blender biasanya besar dan sudah ada di komputer. Dashboard admin di mobile bisa difokuskan untuk memantau penjualan dan mengelola pesanan.

## 12. Pertimbangan Pembayaran di Google Play dan App Store

Google dan Apple memiliki kebijakan khusus untuk penjualan konten digital di dalam aplikasi, termasuk kewajiban memakai sistem pembayaran mereka dengan potongan komisi pada kondisi tertentu. Kebijakan ini sering berubah dan berbeda per negara, jadi **verifikasi kebijakan terbaru sebelum mengunci arsitektur pembayaran**. Opsi yang bisa dipertimbangkan: memakai in-app purchase resmi, atau mengarahkan pembelian ke web checkout jika kebijakan mengizinkan.

## 13. Roadmap

| Fase | Isi | Perkiraan |
|---|---|---|
| Fase 0 | Riset, desain UI/UX, finalisasi kebijakan pembayaran dan lisensi | 2–3 minggu |
| Fase 1 (MVP) | Katalog, preview 3D, login, download gratis, checkout premium, Aset Saya, wishlist, dashboard admin dasar | 8–12 minggu |
| Fase 2 | Notifikasi, statistik lengkap, rating dan review, kupon | 4–6 minggu |
| Fase 3 | Langganan, bundle, multi-vendor, integrasi plugin Blender | menyesuaikan |

Estimasi waktu bergantung pada ukuran tim dan pengalaman developer.

## 14. Risiko dan Mitigasi

| Risiko | Mitigasi |
|---|---|
| Pembajakan file premium | Signed URL, batasi frekuensi unduhan, watermark/metadata pembeli di file jika perlu, lisensi yang jelas |
| Preview 3D berat di HP spek rendah | Gunakan .glb teroptimasi, turunkan kualitas tekstur untuk preview |
| Biaya penyimpanan dan bandwidth membengkak | Pakai storage dengan egress murah (misal R2), kompres file, pantau penggunaan |
| Penolakan aplikasi karena kebijakan pembayaran | Pelajari kebijakan sejak awal, siapkan skema alternatif |
| Sedikit aset di awal | Siapkan minimal 30–50 aset sebelum rilis |
| Pembayaran sudah dibayar tapi akses tidak terbuka | Webhook idempoten, halaman cek status manual, log transaksi |

## 15. Pertanyaan Terbuka

1. Apakah 'tampilan penjual' memang storefront untuk pembeli, atau Anda berencana mengundang kreator lain berjualan?
2. Apakah akses dashboard admin lebih nyaman lewat web (laptop) atau harus di dalam aplikasi mobile?
3. Lisensi seperti apa yang ingin diterapkan (personal, komersial, atau keduanya)?
4. Platform target pertama: Android saja dulu, atau langsung Android dan iOS?
5. Apakah sudah ada rencana langganan atau bundle sejak awal?
6. Siapa yang akan mengembangkan aplikasi (tim sendiri, freelancer, atau agensi)?
