/// Jenis akun yang tampil di direktori pengguna admin.
enum AdminUserKind { creator, buyer, applicant, admin, suspended }

/// Akun pengguna atau kreator pada panel admin.
class AdminUser {
  AdminUser({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.kind,
    this.role = '',
    this.assets = 0,
    this.revenue = '—',
    this.rating = 0,
    this.transactions = 0,
    this.joined = '',
    this.permission = '',
    this.lastActive = '',
    this.platform = '',
    this.sample = '',
    this.reason = '',
    this.blockedAt = '',
    this.studio = '',
  });

  final String name;
  final String email;
  final String avatarUrl;
  AdminUserKind kind;
  String role;
  int assets;
  String revenue;
  double rating;
  int transactions;
  String joined;
  String permission;
  String lastActive;
  String platform;
  String sample;
  String reason;
  String blockedAt;
  String studio;
}

/// Data awal direktori pengguna (selaras dengan layar Stitch).
final demoAdminUsers = <AdminUser>[
  AdminUser(
    name: 'Aria Bramantyo',
    email: 'aria@gamecrafter.io',
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDgTBvYdB0YPmAj2p81uheSxONWKJpofGWU2E81CZHTYVpUH2zWxquLmVy9EokauVzrRP-RG87QnQhlnoIi8gyMc4SoLBHHYq-48BczVa2GNsNNCXYmxCDDbHqjK2CbKyQy9BHmd6-q5pkREkRq7BxhClxHTr1qG_JSxv4XFbHLDb1tn0hj0XwckVIOT2A-pQnICjNkO0aGliW4p5jaVpfAOKfJWMF-Y2pFkvvaA7E',
    kind: AdminUserKind.creator,
    role: 'Blender Pro',
    assets: 18,
    revenue: 'Rp 24,8M',
    rating: 4.9,
    joined: 'Sejak Mar 2025',
    studio: 'Gamecrafter Studio',
  ),
  AdminUser(
    name: 'Deva Praditya',
    email: 'deva@studio.id',
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuB1dCw5XlboEMSWS8rmdQdFV5StU09gz56VxpF4WfS1kV1B3XptYpiiW9vlXziHH0__LEwALcNNgBOrOl-wWukHSLnbku3CCPrfV_gx10qxW23dqc24R8rtYumE9UPeV24PX2O9A0JbhEMMLhlMd8qJ4EpcBOZZUI45kUHcMELQrccdnKnrV5nBCcXopl839_nzH4RsIL2GsmGjkd8BOfxP0Q3wc2OjvLQDRNE4Lbw',
    kind: AdminUserKind.admin,
    role: 'Super Admin',
    permission: 'Hak Akses Penuh (Root)',
    lastActive: 'Aktif 5 mnt lalu',
    joined: 'Sejak Jan 2025',
  ),
  AdminUser(
    name: 'Rian Hidayat',
    email: 'rian.arch@gmail.com',
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAfO6iFcfvymXwRTIcAg_QV2GxeKq6W3tnYQOJnUMnhW49tVCK-TznG9pVTVQrU11DnldG2jFceC9rRrJmTWzZ9PkSVFhFg1cT5osnSaZCGYxI4TbF3f_gG29iC9jNpk1cnwRnnIDPQCmdI2YQsvRqdEORTX_DFxriTKOmPE0tRkSaL2hoj-9ktJpExUU70wn4DnVoZgbdFRuYsAQOKBh9OSPvrdaxIIFZc4gM7mPQ',
    kind: AdminUserKind.buyer,
    role: 'Pembeli Studio',
    transactions: 14,
    joined: 'Sejak Okt 2026',
    studio: 'Rian Archviz',
  ),
  AdminUser(
    name: 'Dimas Tri Atmojo',
    email: 'dimas3d@artstation.com',
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCxhWalv7ml687WXuLFvRvPJdTzxpq4BqDD7wfrLfENB2Lb2bewbe3f6TwuKwrnzW68YemHUUI4pDTypr8aoFNdm5BecQzWVqCnxi4Uu7COHF6uNkT4DXiIM825EqqzdQqTmqMRJAL_iXDX_y7rIftZ-tUX-Hp6iu_ihOqMsoN5jvRVVNoJwuJRVEbUczWKH_N3YO3VxDwN3CM0jvzvI74uma-GQDuLXStin62u3W8',
    kind: AdminUserKind.applicant,
    role: 'Calon Kreator',
    platform: 'ArtStation Terverifikasi',
    sample: '3 Sampel Mesh (.blend) • Subd High-Poly',
    joined: 'Mendaftar 2 hari lalu',
    studio: 'Dimas Atmojo Works',
  ),
  AdminUser(
    name: 'CyberRipper_99',
    email: 'bot99@tempmail.com',
    avatarUrl: '',
    kind: AdminUserKind.suspended,
    role: 'Suspended',
    reason: 'Pelanggaran hak cipta berat: redistribusi ilegal aset mesh 3D rip.',
    blockedAt: '12 Jan 2026',
    joined: 'Sejak Nov 2025',
  ),
];
