# Frontend Plan — Marketplace Aset 3D Blender

Versi 1.0 · 10 November 2026 · Berdasarkan PRD v1.0

---

## 1. Tech Stack

| Layer | Pilihan |
|---|---|
| Framework | **Flutter** (satu codebase Android + iOS) |
| State Management | Riverpod / Bloc |
| 3D Preview | `model_viewer_plus` (wrapper Google `<model-viewer>` via WebView) untuk render `.glb` |
| HTTP Client | Dio |
| Auth | Firebase Auth (email + Google Sign-In) |
| Push Notification | Firebase Cloud Messaging |
| Image Loading | `cached_network_image` + lazy loading |
| Navigation | `go_router` (declarative, deep link support) |

---

## 2. Arsitektur Screen & Navigasi

### 2.1 Pembeli — Bottom Navigation (5 tab)

```
BottomNavigationBar
├── 🏠 Beranda
├── 🔍 Jelajah (Katalog)
├── ♡  Wishlist
├── 📦 Aset Saya
└── 👤 Profil
```

### 2.2 Full Screen Map (Semua Layar)

```
App
│
├── SplashScreen
├── OnboardingScreen (pertama kali saja, 3 halaman swipe)
│
├── AuthFlow (tanpa bottom nav)
│   ├── LoginScreen
│   ├── RegisterScreen
│   └── ForgotPasswordScreen
│
├── BuyerShell (dengan bottom nav)
│   ├── Tab: Beranda
│   │   └── HomeScreen
│   │       ├── Banner Promo (carousel)
│   │       ├── Kategori (horizontal scroll chips/icons)
│   │       ├── Aset Unggulan (horizontal card list)
│   │       └── Aset Terbaru (vertical grid 2 kolom)
│   │
│   ├── Tab: Jelajah
│   │   └── ExploreScreen
│   │       ├── Search bar (top, persistent)
│   │       ├── Filter chips: Semua | Gratis | Premium
│   │       ├── Sort dropdown: Terbaru | Terpopuler | Harga ↑ | Harga ↓
│   │       ├── Kategori filter (bottom sheet / expandable)
│   │       └── Grid hasil (2 kolom, infinite scroll)
│   │
│   ├── Tab: Wishlist
│   │   └── WishlistScreen
│   │       ├── Header: "Wishlist Saya" + jumlah item
│   │       ├── List aset (card: thumbnail, judul, harga/gratis, tombol hapus)
│   │       ├── Tap card → AssetDetailScreen
│   │       ├── Badge "DIMILIKI" jika aset sudah dibeli/didownload
│   │       └── Empty state jika wishlist kosong
│   │
│   ├── Tab: Aset Saya
│   │   └── MyAssetsScreen
│   │       ├── Tab internal: Semua | Gratis | Dibeli
│   │       └── List aset (card + tombol download ulang)
│   │
│   ├── Tab: Profil
│   │   └── ProfileScreen
│   │       ├── Info akun (avatar, nama, email)
│   │       ├── Riwayat Transaksi → TransactionHistoryScreen
│   │       ├── Notifikasi → NotificationsScreen
│   │       ├── Bantuan
│   │       └── Logout
│   │
│   └── Layar Push (di atas bottom nav)
│       ├── AssetDetailScreen
│       │   ├── Galeri gambar (swipeable, fullscreen tap)
│       │   ├── 3D Preview viewer (.glb, rotate + zoom)
│       │   ├── Info: judul, harga/gratis, deskripsi
│       │   ├── Spesifikasi: format, polygon, ukuran, versi Blender, lisensi
│       │   ├── Tombol aksi:
│       │   │   ├── [GRATIS] → "Download" (cek login dulu)
│       │   │   └── [PREMIUM] → "Beli Rp XX.XXX" (cek login dulu)
│       │   ├── Tombol Wishlist (♡/♥) di app bar — toggle simpan/hapus
│       │   └── Aset serupa (horizontal scroll)
│       │
│       ├── CheckoutScreen
│       │   ├── Ringkasan order (thumbnail + nama + harga)
│       │   ├── Pilih metode bayar: QRIS | E-wallet | Virtual Account
│       │   └── Tombol "Bayar Sekarang"
│       │
│       ├── PaymentWebViewScreen (redirect ke payment gateway)
│       │
│       ├── PaymentStatusScreen
│       │   ├── Sukses → tombol Download + "Lihat Aset Saya"
│       │   ├── Pending → instruksi tunggu
│       │   └── Gagal → tombol "Coba Lagi"
│       │
│       ├── TransactionHistoryScreen
│       │   └── List order (tanggal, aset, total, status badge)
│       │
│       ├── TransactionDetailScreen
│       │   └── Detail per order item
│       │
│       ├── CategoryScreen (aset per kategori tertentu)
│       │
│       └── NotificationsScreen
│
├── AdminShell (bottom nav terpisah, atau sidebar drawer)
│   ├── Tab: Dashboard
│   │   └── AdminDashboardScreen
│   │       ├── Card ringkasan: Total Pendapatan, Total Download, Aset Aktif
│   │       ├── Grafik penjualan (7h / 30h)
│   │       ├── Aset terlaris (top 5)
│   │       └── Transaksi terbaru (5 terakhir)
│   │
│   ├── Tab: Katalog
│   │   └── AdminCatalogScreen
│   │       ├── Search + filter (draft/published/hidden)
│   │       ├── List aset (card: thumbnail, judul, tipe, status)
│   │       ├── FAB → UploadAssetScreen
│   │       └── Tap item → EditAssetScreen
│   │
│   ├── Tab: Transaksi
│   │   └── AdminOrdersScreen
│   │       ├── Filter: Semua | Pending | Paid | Failed | Refunded
│   │       └── List order (pembeli, total, status, tanggal)
│   │           └── Tap → AdminOrderDetailScreen
│   │
│   └── Tab: Lainnya
│       └── AdminMoreScreen
│           ├── Kelola Pengguna → AdminUsersScreen
│           ├── Kelola Kategori → AdminCategoriesScreen
│           ├── Kelola Banner → AdminBannersScreen
│           └── Logout
│
│   Layar Push Admin:
│       ├── UploadAssetScreen
│       │   ├── Form: judul, deskripsi, kategori (dropdown), tags (chips input)
│       │   ├── Upload: file aset (.blend/.zip), thumbnail, galeri (multi-image)
│       │   ├── Upload: preview .glb
│       │   ├── Tipe: toggle Gratis/Premium → field harga (jika premium)
│       │   ├── Status: Draft / Publish
│       │   └── Tombol Simpan (+ progress upload)
│       │
│       ├── EditAssetScreen (sama seperti upload, prefilled)
│       ├── AdminOrderDetailScreen
│       ├── AdminUsersScreen (list + tombol blokir)
│       ├── AdminCategoriesScreen (CRUD kategori + icon)
│       └── AdminBannersScreen (CRUD banner + image upload)
```

---

## 3. Navigasi Logic

### 3.1 Route Guard / Redirect Rules

| Kondisi | Aksi |
|---|---|
| Pertama kali buka app | Splash → Onboarding → Beranda |
| Sudah pernah buka | Splash → Beranda |
| Tap Download/Beli tapi belum login | Redirect Login → kembali ke detail aset |
| Tap Wishlist (♡) tapi belum login | Redirect Login → kembali ke detail aset, aset otomatis masuk wishlist |
| Login sebagai admin | Masuk AdminShell |
| Login sebagai pembeli | Masuk BuyerShell |
| Deep link ke `/asset/:id` | Langsung AssetDetailScreen |
| Token expired | Redirect Login, simpan intended route |

### 3.2 Navigation Flow Diagram (Pembeli)

```
Beranda ──tap card──→ AssetDetail ──"Beli"──→ [cek login]
                                                  │
                                         belum ←──┤──→ sudah
                                           │              │
                                       LoginScreen    CheckoutScreen
                                           │              │
                                       kembali ke     PaymentWebView
                                       AssetDetail        │
                                                    PaymentStatus
                                                     │         │
                                                  Sukses     Gagal
                                                     │         │
                                                Download   Coba Lagi
```

### 3.3 Route Table (`go_router`)

| Path | Screen | Auth? |
|---|---|---|
| `/` | SplashScreen | Tidak |
| `/onboarding` | OnboardingScreen | Tidak |
| `/login` | LoginScreen | Tidak |
| `/register` | RegisterScreen | Tidak |
| `/forgot-password` | ForgotPasswordScreen | Tidak |
| `/home` | HomeScreen (tab Beranda) | Tidak |
| `/explore` | ExploreScreen (tab Jelajah) | Tidak |
| `/category/:id` | CategoryScreen | Tidak |
| `/asset/:id` | AssetDetailScreen | Tidak |
| `/checkout/:orderId` | CheckoutScreen | Ya (pembeli) |
| `/payment/:orderId` | PaymentWebViewScreen | Ya (pembeli) |
| `/payment-status/:orderId` | PaymentStatusScreen | Ya (pembeli) |
| `/my-assets` | MyAssetsScreen (tab Aset Saya) | Ya (pembeli) |
| `/wishlist` | WishlistScreen (tab Wishlist) | Ya (pembeli) |
| `/profile` | ProfileScreen (tab Profil) | Ya (pembeli) |
| `/transactions` | TransactionHistoryScreen | Ya (pembeli) |
| `/transactions/:id` | TransactionDetailScreen | Ya (pembeli) |
| `/notifications` | NotificationsScreen | Ya (pembeli) |
| `/admin` | AdminDashboardScreen | Ya (admin) |
| `/admin/catalog` | AdminCatalogScreen | Ya (admin) |
| `/admin/catalog/upload` | UploadAssetScreen | Ya (admin) |
| `/admin/catalog/edit/:id` | EditAssetScreen | Ya (admin) |
| `/admin/orders` | AdminOrdersScreen | Ya (admin) |
| `/admin/orders/:id` | AdminOrderDetailScreen | Ya (admin) |
| `/admin/users` | AdminUsersScreen | Ya (admin) |
| `/admin/categories` | AdminCategoriesScreen | Ya (admin) |
| `/admin/banners` | AdminBannersScreen | Ya (admin) |

---

## 4. UI/UX Design Guidelines

### 4.1 Design System

| Elemen | Spesifikasi |
|---|---|
| **Warna Primer** | Biru gelap `#1A237E` — trust, tech vibe |
| **Warna Aksen** | Orange `#FF6D00` — CTA, harga, tombol beli |
| **Warna Gratis** | Hijau `#2E7D32` — badge gratis |
| **Warna Error** | Merah `#D32F2F` — error state, gagal |
| **Warna Sukses** | Hijau `#388E3C` — pembayaran berhasil |
| **Background Light** | `#FAFAFA` |
| **Background Dark** | `#121212` |
| **Surface Card** | `#FFFFFF` (light) / `#1E1E1E` (dark) |
| **Font** | Inter atau Google Sans (clean, modern) |
| **Heading** | Bold, 20–24sp |
| **Body** | Regular, 14–16sp |
| **Caption** | Regular, 12sp, warna abu-abu |
| **Corner Radius** | Card 12px, Button 8px, Chip 20px |
| **Elevation** | Card shadow ringan (2dp), bottom nav elevated (8dp) |
| **Icon Style** | Rounded Material Icons |
| **Spacing Grid** | Kelipatan 4px (4, 8, 12, 16, 20, 24, 32) |

### 4.2 Komponen Utama

#### Asset Card (Grid Item)

```
┌─────────────────────┐
│  ┌─────────────────┐ │
│  │   THUMBNAIL     │ │
│  │   (16:9 ratio)  │ │
│  │  [♡]     [FREE] │ │  ← ♡ wishlist kiri atas, badge harga kanan bawah
│  └─────────────────┘ │
│  Judul Aset           │
│  Kategori · 2.4 MB    │
└─────────────────────┘
```

- Thumbnail: `CachedNetworkImage`, rounded top corners 12px
- Wishlist icon: positioned overlay kiri atas thumbnail, toggle ♡/♥
- Badge: positioned overlay kanan bawah thumbnail
- Judul: max 2 baris, ellipsis overflow
- Subtitle: kategori + ukuran file, warna abu-abu

#### Asset Detail — Layout

```
┌──────────────────────────┐
│  ← Back          [♡]    │  ← app bar transparan, ♡ toggle wishlist (♥ jika sudah disimpan)
│                          │
│  ┌──────────────────────┐│
│  │    IMAGE GALLERY     ││  ← PageView dots indicator
│  │    (swipeable)       ││
│  └──────────────────────┘│
│                          │
│  ┌──────────────────────┐│
│  │   3D PREVIEW (.glb)  ││  ← model-viewer, gesture rotate/zoom
│  │   🔄 Tap to rotate   ││
│  └──────────────────────┘│
│                          │
│  Medieval Castle         │
│  ★ Gratis / Rp 89.000   │
│                          │
│  📄 Deskripsi            │
│  Lorem ipsum dolor sit.. │
│                          │
│  📋 Spesifikasi          │
│  ┌──────────────────────┐│
│  │ Format    .blend,.fbx││
│  │ Polygon   12,450     ││
│  │ Ukuran    34.2 MB    ││
│  │ Blender   3.6+       ││
│  │ Lisensi   Personal   ││
│  └──────────────────────┘│
│                          │
│  ── Aset Serupa ──       │
│  [card] [card] [card]    │
│                          │
├──────────────────────────┤
│ [████ DOWNLOAD GRATIS ████] │  ← sticky bottom bar
│ atau                        │
│ [████ BELI Rp 89.000 ████]  │
└──────────────────────────┘
```

#### Checkout Screen — Layout

```
┌──────────────────────────┐
│  ← Checkout              │
│                          │
│  Ringkasan Pesanan       │
│  ┌──────────────────────┐│
│  │ [img] Medieval Castle││
│  │       Rp 89.000      ││
│  └──────────────────────┘│
│                          │
│  Total: Rp 89.000        │
│                          │
│  Metode Pembayaran       │
│  ○ QRIS                  │
│  ○ GoPay                 │
│  ○ OVO                   │
│  ○ Virtual Account (BCA) │
│  ○ Virtual Account (BNI) │
│                          │
├──────────────────────────┤
│ [████ BAYAR SEKARANG ████]│  ← sticky bottom
└──────────────────────────┘
```

#### Wishlist Screen — Layout

```
┌──────────────────────────┐
│  Wishlist Saya    (12)   │  ← jumlah item di wishlist
│                          │
│  ┌──────────────────────┐│
│  │ [thumb] Medieval Castle│
│  │         Rp 89.000    ││
│  │         Karakter     ││  ← kategori
│  │         [♥] [BELI]   ││  ← ♥ hapus, BELI langsung ke checkout
│  └──────────────────────┘│
│                          │
│  ┌──────────────────────┐│
│  │ [thumb] Low Poly Tree ││
│  │         GRATIS       ││
│  │         Environment  ││
│  │   [DIMILIKI] [♥]     ││  ← badge DIMILIKI jika sudah dibeli
│  └──────────────────────┘│
│                          │
│  ┌──────────────────────┐│
│  │ [thumb] Sci-fi Props  ││
│  │         Rp 49.000    ││
│  │         Props        ││
│  │         [♥] [BELI]   ││
│  └──────────────────────┘│
│                          │
│  ... (scroll)            │
└──────────────────────────┘

Empty state (jika kosong):
┌──────────────────────────┐
│                          │
│      [ilustrasi ♡]       │
│                          │
│   Wishlist masih kosong   │
│   Jelajahi aset dan tap  │
│   ♡ untuk menyimpan      │
│                          │
│   [JELAJAHI ASET]        │  ← CTA ke tab Jelajah
│                          │
└──────────────────────────┘
```

#### Admin Dashboard — Layout

```
┌──────────────────────────┐
│  Dashboard Admin         │
│                          │
│  ┌──────┐ ┌──────┐      │
│  │Rp 2.1│ │ 847  │      │  ← summary cards (grid 2 kolom)
│  │ Juta  │ │ Down │      │
│  └──────┘ └──────┘      │
│  ┌──────┐ ┌──────┐      │
│  │  42  │ │  18  │      │
│  │ Aset │ │Order │      │
│  └──────┘ └──────┘      │
│                          │
│  📊 Penjualan 30 Hari    │
│  ┌──────────────────────┐│
│  │   ▃ ▅ ▇ ▃ ▆ ▄ ▅     ││  ← bar/line chart
│  └──────────────────────┘│
│                          │
│  🏆 Aset Terlaris        │
│  1. Medieval Castle  120x│
│  2. Sci-fi Props      89x│
│  3. Low Poly Trees    76x│
│                          │
│  🕐 Transaksi Terbaru    │
│  [order card list]       │
└──────────────────────────┘
```

### 4.3 UX Principles (Dari PRD)

| Prinsip | Implementasi |
|---|---|
| **Browsing tanpa login** | Semua layar katalog dan detail bisa diakses tanpa auth. Login hanya diminta saat download/beli. |
| **Preview meyakinkan** | Galeri gambar multi-angle + 3D viewer interaktif. User harus bisa "merasakan" aset sebelum bayar. |
| **Checkout cepat** | Maksimal 2 tap dari detail ke pembayaran: Beli → Pilih metode → Bayar. |
| **Unduh ulang mudah** | "Aset Saya" selalu accessible dari bottom nav. Tombol download ulang langsung visible per item. |
| **Performa** | Thumbnail optimized (WebP, ~100KB). Lazy load grid. Skeleton shimmer saat loading. Target <3 detik di 4G. |
| **Harga jelas** | Badge gratis/premium di card. Harga dalam Rupiah, format `Rp XX.XXX`. Tidak ada hidden cost. |
| **Wishlist intuitif** | Tombol ♡ visible di card dan detail. Toggle instan tanpa loading screen. Wishlist accessible dari bottom nav. |
| **Feedback instan** | Setiap aksi user dapat respons visual: loading state, success/error snackbar, animasi transisi. |

### 4.4 Microinteractions & Polish

| Interaksi | Detail |
|---|---|
| **Skeleton shimmer** | Saat data loading, tampilkan placeholder shimmer (bukan spinner kosong) |
| **Pull to refresh** | Di Beranda, Katalog, Aset Saya |
| **Hero animation** | Thumbnail asset card → asset detail (shared element transition) |
| **Snackbar** | Konfirmasi download dimulai / selesai / error |
| **Lottie animation** | Payment success screen (confetti / checkmark animation) |
| **Haptic feedback** | Saat tap tombol Beli dan Download |
| **Wishlist heart animation** | ♡ → ♥ scale bounce animation saat tap. Snackbar "Ditambahkan ke Wishlist" dengan undo. |
| **Progress bar** | Upload aset di admin (persentase + ukuran) |
| **Empty state** | Ilustrasi + CTA di Aset Saya kosong, transaksi kosong, hasil pencarian kosong |
| **Shimmer badge** | Badge "BARU" berkilau di aset yang baru ditambahkan (<7 hari) |
| **Bottom sheet** | Filter kategori, sort options — bukan halaman baru |

### 4.5 Responsive & Adaptif

| Aspek | Handling |
|---|---|
| **Orientasi** | Portrait-only untuk pembeli. Landscape allowed di admin (tabel lebar). |
| **Tablet** | Grid 3-4 kolom (bukan 2). Detail aset: galeri kiri, info kanan (side-by-side). |
| **Font scaling** | Respek system font size. Test di 1.0x–1.5x scale. |
| **Safe area** | Padding untuk notch, dynamic island, gesture bar. |

---

## 5. Folder Structure (Flutter)

```
lib/
├── main.dart
├── app/
│   ├── router.dart                 # go_router config + route guards
│   └── theme.dart                  # design system, colors, typography
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_sizes.dart
│   │   └── api_endpoints.dart
│   ├── utils/
│   │   ├── currency_formatter.dart # format Rupiah
│   │   ├── date_formatter.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── asset_card.dart
│       ├── price_tag.dart
│       ├── shimmer_loading.dart
│       ├── empty_state.dart
│       ├── error_state.dart
│       └── custom_app_bar.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── auth_state.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       └── forgot_password_screen.dart
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       └── onboarding_screen.dart
│   │
│   ├── home/
│   │   ├── data/
│   │   │   └── home_repository.dart
│   │   ├── domain/
│   │   │   └── banner_model.dart
│   │   └── presentation/
│   │       ├── home_screen.dart
│   │       └── widgets/
│   │           ├── promo_carousel.dart
│   │           ├── category_chips.dart
│   │           ├── featured_section.dart
│   │           └── latest_assets_grid.dart
│   │
│   ├── explore/
│   │   ├── data/
│   │   │   └── explore_repository.dart
│   │   ├── domain/
│   │   │   └── filter_state.dart
│   │   └── presentation/
│   │       ├── explore_screen.dart
│   │       └── widgets/
│   │           ├── search_bar.dart
│   │           ├── filter_chips.dart
│   │           └── sort_dropdown.dart
│   │
│   ├── asset_detail/
│   │   ├── data/
│   │   │   └── asset_detail_repository.dart
│   │   ├── domain/
│   │   │   └── asset_detail_state.dart
│   │   └── presentation/
│   │       ├── asset_detail_screen.dart
│   │       └── widgets/
│   │           ├── image_gallery.dart
│   │           ├── model_viewer_3d.dart
│   │           ├── spec_table.dart
│   │           ├── action_bottom_bar.dart
│   │           └── similar_assets.dart
│   │
│   ├── checkout/
│   │   ├── data/
│   │   │   └── checkout_repository.dart
│   │   ├── domain/
│   │   │   └── order_model.dart
│   │   └── presentation/
│   │       ├── checkout_screen.dart
│   │       ├── payment_webview_screen.dart
│   │       └── payment_status_screen.dart
│   │
│   ├── my_assets/
│   │   ├── data/
│   │   │   └── my_assets_repository.dart
│   │   └── presentation/
│   │       └── my_assets_screen.dart
│   │
│   ├── wishlist/
│   │   ├── data/
│   │   │   └── wishlist_repository.dart
│   │   ├── domain/
│   │   │   └── wishlist_state.dart
│   │   └── presentation/
│   │       ├── wishlist_screen.dart
│   │       └── widgets/
│   │           └── wishlist_card.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   └── profile_repository.dart
│   │   └── presentation/
│   │       ├── profile_screen.dart
│   │       ├── transaction_history_screen.dart
│   │       └── transaction_detail_screen.dart
│   │
│   ├── notifications/
│   │   └── presentation/
│   │       └── notifications_screen.dart
│   │
│   └── admin/
│       ├── dashboard/
│       │   ├── data/
│       │   │   └── admin_dashboard_repository.dart
│       │   └── presentation/
│       │       ├── admin_dashboard_screen.dart
│       │       └── widgets/
│       │           ├── summary_cards.dart
│       │           ├── sales_chart.dart
│       │           └── top_assets_list.dart
│       ├── catalog/
│       │   ├── data/
│       │   │   └── admin_catalog_repository.dart
│       │   └── presentation/
│       │       ├── admin_catalog_screen.dart
│       │       ├── upload_asset_screen.dart
│       │       └── edit_asset_screen.dart
│       ├── orders/
│       │   ├── data/
│       │   │   └── admin_orders_repository.dart
│       │   └── presentation/
│       │       ├── admin_orders_screen.dart
│       │       └── admin_order_detail_screen.dart
│       ├── users/
│       │   └── presentation/
│       │       └── admin_users_screen.dart
│       ├── categories/
│       │   └── presentation/
│       │       └── admin_categories_screen.dart
│       └── banners/
│           └── presentation/
│               └── admin_banners_screen.dart
│
├── models/
│   ├── user_model.dart
│   ├── asset_model.dart
│   ├── category_model.dart
│   ├── order_model.dart
│   ├── order_item_model.dart
│   ├── wishlist_model.dart
│   └── transaction_model.dart
│
└── services/
    ├── api_service.dart            # Dio instance, interceptors
    ├── auth_service.dart           # Firebase Auth wrapper
    ├── storage_service.dart        # SharedPreferences / secure storage
    ├── download_service.dart       # File download handler
    └── notification_service.dart   # FCM setup
```

---

## 6. Jumlah Screen Total

| Sisi | Screen | Jumlah |
|---|---|---|
| Common | Splash, Onboarding (3 pages), Login, Register, Forgot Password | 6 |
| Pembeli | Home, Explore, AssetDetail, Checkout, PaymentWebView, PaymentStatus, MyAssets, Wishlist, Profile, TransactionHistory, TransactionDetail, Category, Notifications | 13 |
| Admin | Dashboard, Catalog, UploadAsset, EditAsset, Orders, OrderDetail, Users, Categories, Banners, More | 10 |
| **Total** | | **29 screen** |

---

## 7. Prioritas Pengerjaan (Sesuai MVP — P0)

| Sprint | Minggu | Screen & Komponen | Deliverable |
|---|---|---|---|
| **Sprint 1** | 1–2 | Splash, Onboarding, Login, Register, ForgotPassword | Auth flow selesai, user bisa daftar dan masuk |
| **Sprint 2** | 3–4 | Home, Explore, AssetCard widget, Search + Filter, Category | Browsing katalog bisa jalan, pencarian dan filter berfungsi |
| **Sprint 3** | 5–6 | AssetDetail, Image Gallery, 3D Preview, Spec Table, Wishlist toggle + WishlistScreen | Core experience pembeli: lihat detail, preview 3D, simpan ke wishlist |
| **Sprint 4** | 7–8 | Checkout, PaymentWebView, PaymentStatus, MyAssets | Purchase flow end-to-end, download gratis dan premium |
| **Sprint 5** | 9–10 | Admin: Dashboard, Catalog, Upload, Edit | Admin bisa upload dan kelola aset |
| **Sprint 6** | 11–12 | Admin: Orders, Users, Categories, Banners. Buyer: Profile, TransactionHistory, Notifications | Semua fitur MVP lengkap, siap testing |

### Fitur per Fase PRD

| Fase | Fitur | Prioritas |
|---|---|---|
| **MVP (Sprint 1–6)** | Auth, Katalog, Search/Filter, Detail Aset, Preview 3D, Download Gratis, Checkout Premium, Aset Saya, Wishlist, Dashboard Admin, Upload, Kelola Katalog, Kelola Transaksi | P0 |
| **Fase 2** | Notifikasi push, Statistik penjualan lengkap, Riwayat transaksi detail, Kelola pengguna, Kelola kategori dan banner | P1 |
| **Fase 3** | Rating dan review, Kupon dan diskon | P2 |
| **Fase 4+** | Multi-vendor, Langganan bulanan, Bundle, Plugin Blender | Backlog |

---

## 8. Catatan Penting

### 8.1 Performa (Dari PRD Requirement Non-Fungsional)

- Halaman katalog harus termuat <3 detik di 4G
- Thumbnail pakai format WebP, ukuran ~100KB, lazy loading
- 3D preview pakai `.glb` teroptimasi (terpisah dari file `.blend` asli)
- Infinite scroll dengan pagination (bukan load semua sekaligus)
- Cache response API untuk mengurangi request berulang

### 8.2 Keamanan

- File premium tidak boleh punya URL publik → pakai signed URL sementara dari backend
- Token auth disimpan di `flutter_secure_storage`
- Role-based route guard: pembeli tidak bisa akses `/admin/*`
- Validasi input di sisi client DAN server

### 8.3 Platform Target

- Android 8+ (API 26)
- iOS 15+
- Test di device low-end untuk pastikan 3D preview tidak crash

### 8.4 Admin Mobile vs Web

Sesuai rekomendasi PRD: admin upload aset dari **dashboard web** (file besar, dari laptop). Admin mobile difokuskan untuk:
- Pantau penjualan dan statistik
- Kelola pesanan dan status
- Kelola pengguna
- Quick edit aset (harga, status, draft/publish)

Upload aset di mobile tetap tersedia tapi sebagai opsi sekunder.
