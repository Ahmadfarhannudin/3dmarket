enum AdminOrderStatus { paid, pending }

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
  });

  final String id;
  final String time;
  final String title;
  final String payment;
  final String amount;
  AdminOrderStatus status;
  String note;
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
  ),
  AdminOrder(
    id: '#ORD-20261110-8919',
    time: '12:15 WIB',
    title: 'Tactical Exo Helmet',
    payment: 'GoPay',
    amount: 'Rp 75.000',
    status: AdminOrderStatus.paid,
    note: 'Auto-Sync',
  ),
  AdminOrder(
    id: '#ORD-20261109-8890',
    time: 'Kemarin',
    title: 'Mech Vanguard-X (Studio)',
    payment: 'BCA Virtual Account',
    amount: 'Rp 149.000',
    status: AdminOrderStatus.pending,
    note: '23j tersisa',
  ),
];
