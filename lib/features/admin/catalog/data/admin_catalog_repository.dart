/// Model aset katalog yang dipakai seluruh layar admin.
class AdminAsset {
  AdminAsset({
    required this.title,
    required this.sales,
    required this.rating,
    required this.price,
    required this.format,
    required this.meta,
    required this.free,
    required this.active,
    this.imageUrl,
    this.modelPath,
  });

  String title;
  String sales;
  String rating;
  String price;
  String format;
  String meta;
  bool free;
  bool active;
  final String? imageUrl;

  /// Path aset `.glb` di dalam bundle (mis. `assets/models/...`).
  final String? modelPath;
}
/// Model 3D nyata yang tersedia di `assets/models/characters/`.
const f14Model = 'assets/models/characters/grumman_f-14_tomcat_fighter_jet.glb';

const adminAssetImages = [  'https://lh3.googleusercontent.com/aida-public/AB6AXuBYC6_ziPUYuvCYRTD7qvQ1_6_2KUv973Y8lZ76Q4wvqeYg6cROHL7ovfYvBgDkMadl-lGzRjZw1-pF0fEztAGvtlqmWLLMnDZD_rWoZYQ_ScI9HM1fq9BKicrkl5E63Bb06RdxG0qgfxkBPCHR9Zsq0aGfqWkJd7sCwzm_m_WVrpksTOl4zEIHH829Krd6_FV4Lm9WnpU6lZb5R2PQbfE0KflYArvU1RlsjSdIiHA',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDd22_m6BKlaca7wWpaRryPCE0rqRBNAFHQlxVcdeSpkNMaA2viBsSUaU3Y7ioQPi410KDbxqB3I5rrsmqTpzaJnLu_IctkR7lSnAeO2Vl90bdAmJgqt69UyLVMr4_l_ZYjjnaQ8G4Rptulp-QTl7OUJ3Okvrbh5-365CdHXw1Yy5E3ggwEBnVwb6bGEleky_5yz3XeV-Vnhvo2B9DAbHYD1axn-U0BX1qS8A6YmII',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDyuOJgHGhC_Qnec62DPOCd437Es9tIno52Ur_c_3L8nJ1DHT57NjiPz8G_F5zJoySGD58ZpLnpAFAIxJpkLRxCFtxFreCo20BDik0qZPOcweaydYsclrdYf_S3vqxMW3iTJw3NtHv0GoYwGCloSqvjj71MjIQCCNs2BTZmSAbz_FHItPjpBmRl_NzCBHzE2Gf7bZ91Ip8FfKN9okhjd34hQIMFC-QHlNKYzPHH4Bo',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAfzQ2SHA60z2IwK1GmuiI1JjoH1lRqTnuJj52e1uUfUFTta2Vn8DMKWN9-sU4_kZvbE32skWtoLjMng7q44LJWA0ZMK092BO-FuwZMLYH9PZw9RMBkNJmLd97KpIg2hXdYB_d5x4jW9Dr5o4nBIJGiZSkTFZDzlis4Hnf4E5NiKGZM6EofLi5KbKUgf-ntaGEYPmrLtEtrdYYKvP5iSQjlzt_5IzsuIyP41LoK18A',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuDAm2g3QOPA2tJKWcqMPqpLNPQFj1hVi-ZfAEiYmt7P4QiiH4Ik8urUO9N9ja4jgAjRvQ1bSCKsTgqfy8wZVgIs-cqZ5HhNjFCR8KiRt2QazJhrYBT6hrjNT--F_8tH8wVmgHjEzn5tTWF2Wozdke1Xf0QaY_YvVFkQ4UynoNZFAV1cGvWaSNdCRRZQypBsa0lb8AiYy0JWBfAp6Vcm1pDWWsC3O3hI7DK23DXtdro',
];

/// Data awal katalog admin.
final demoAdminAssets = <AdminAsset>[
  AdminAsset(
    title: 'Grumman F-14 Tomcat Fighter Jet',
    sales: '76x terjual',
    rating: '4.9',
    price: 'Rp 12,50 Jt',
    format: '.glb',
    meta: 'Kendaraan · 32.4 MB · 148k Tris',
    modelPath: f14Model,
    free: false,
    active: true,
  ),
  AdminAsset(
    title: 'Cybernetic Chrono Arm Mk. IV',
    sales: '128x terjual',
    rating: '4.9',
    price: 'Rp 11,39 Jt',
    format: '.fbx',
    meta: 'Karakter & Siber · 48.6 MB · 48.2k Quads',
    imageUrl: adminAssetImages[1],
    free: false,
    active: true,
  ),
  AdminAsset(
    title: 'Tactical Exo Helmet Armor',
    sales: '84x terjual',
    rating: '4.8',
    price: 'Rp 6,30 Jt',
    format: '.blend',
    meta: 'Karakter & Siber · 22.1 MB · 31.4k Quads',
    imageUrl: adminAssetImages[2],
    free: false,
    active: true,
  ),
  AdminAsset(
    title: 'Chronograph Horology',
    sales: '62x terjual',
    rating: '5.0',
    price: 'Rp 7,13 Jt',
    format: 'Rigged',
    meta: 'Props · 18.2 MB · 26.0k Quads',
    imageUrl: adminAssetImages[3],
    free: false,
    active: true,
  ),
  AdminAsset(
    title: 'Sci-Fi Mech Vanguard-X',
    sales: '45x terjual',
    rating: '4.9',
    price: 'Rp 6,70 Jt',
    format: 'Animated',
    meta: 'Sci-Fi · 54.7 MB · 96.3k Quads',
    imageUrl: adminAssetImages[4],
    free: false,
    active: true,
  ),
  AdminAsset(
    title: 'Stylized Fantasy Arsenal',
    sales: '312x diunduh',
    rating: 'Lisensi Terbuka',
    price: 'Gratis',
    format: 'Low-Poly',
    meta: 'Weapon · 6.4 MB · 12.8k Tris',
    free: true,
    active: true,
  ),
  AdminAsset(
    title: 'Nordic Haven Lounge Chair',
    sales: '0x terjual',
    rating: 'Draft',
    price: 'Rp 4,20 Jt',
    format: 'Blend',
    meta: 'Arsitektur · 12.0 MB · 9.6k Quads',
    free: false,
    active: false,
  ),
];

/// Pilihan format berkas pada formulir unggah/ubah aset.
const adminAssetFormats = [
  '.blend',
  '.fbx',
  '.obj',
  '.glb',
  '.gltf',
  '.zip',
];

/// Pilihan kategori kurasi pada formulir unggah/ubah aset.
const adminAssetCategories = [
  'Karakter & Siber',
  'Hard Surface & Props',
  'Sci-Fi Mech & Robotika',
  'Visualisasi Arsitektur',
  'Kendaraan & Penerbangan',
  'Lingkungan',
];
