enum AdminOrderStatus { paid, pending }

/// Kode lisensi yang diterbitkan otomatis setelah pembayaran lunas.
class LicenseCode {
  const LicenseCode({
    required this.code,
    required this.type,
    required this.createdAt,
  });

  final String code;
  final String type; // misal 'Perpetual Commercial'
  final DateTime createdAt;

  bool get isValid => true;
}

/// Pesanan lisensi yang ditampilkan di panel admin.
class AdminOrder {
  AdminOrder({
    required this.id,
    required this.time,
    required this.title,
    required this.payment,
    required this.amount,
    required this.status,
    required this.note,
    this.assetFormat = '.glb',
    this.creator = 'Studio 3DMarket',
    this.sizeLabel = '—',
    this.description = '',
  });

  final String id;
  final String time;
  final String title;
  final String payment;
  final String amount;
  AdminOrderStatus status;
  String note;
  final String assetFormat;
  final String creator;
  final String sizeLabel;
  final String description;
}

/// Data awal pesanan admin.
final demoAdminOrders = <AdminOrder>[
  AdminOrder(
    id: '#ORD-20261110-8921',
    time: '14:32 WIB',
    title: 'Cyberpunk Arm (Standard)',
    payment: 'QRIS Instant',
    amount: 'Rp 91.000',
    status: AdminOrderStatus.paid,
    note: 'Auto-Sync',
    assetFormat: '.blend, .glb',
    creator: 'Obsidian X Lab',
    sizeLabel: '48.6 MB',
    description:
        'Dirancang dengan presisi mekanis tingkat tinggi, aset cybernetic prostetik ini menggabungkan struktur anatomi lengan manusia dengan sambungan hidrolik industri sci-fi.',
  ),
  AdminOrder(
    id: '#ORD-20261110-8919',
    time: '12:15 WIB',
    title: 'Tactical Exo Helmet',
    payment: 'GoPay',
    amount: 'Rp 75.000',
    status: AdminOrderStatus.paid,
    note: 'Auto-Sync',
    assetFormat: '.blend, .fbx',
    creator: 'Obsidian X Lab',
    sizeLabel: '32.1 MB',
    description: 'Model helm taktis low-poly dengan rigging lengkap dan tekstur PBR 2K.',
  ),
  AdminOrder(
    id: '#ORD-20261109-8890',
    time: 'Kemarin',
    title: 'Mech Vanguard-X (Studio)',
    payment: 'BCA Virtual Account',
    amount: 'Rp 149.000',
    status: AdminOrderStatus.pending,
    note: '23j tersisa',
    assetFormat: '.blend',
    creator: 'Vanguard Studios',
    sizeLabel: '124.5 MB',
    description: 'Mecha studio-grade siap produksi untuk game AAA atau film VFX.',
  ),
];
