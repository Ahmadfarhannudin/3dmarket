/// Metrik agregat untuk satu rentang periode dashboard.
class AdminPeriodMetrics {
  const AdminPeriodMetrics({
    required this.revenue,
    required this.revenueDelta,
    required this.downloads,
    required this.paid,
    required this.free,
    required this.orders,
    required this.conversion,
    required this.chartTotal,
    required this.bars,
    required this.barLabels,
  });

  final String revenue;
  final String revenueDelta;
  final String downloads;
  final String paid;
  final String free;
  final String orders;
  final String conversion;
  final String chartTotal;
  final List<double> bars;
  final List<String> barLabels;
}

/// Data metrik dashboard per periode.
const adminPeriodData = <String, AdminPeriodMetrics>{
  '7 Hari': AdminPeriodMetrics(
    revenue: 'Rp 3,42 Jt',
    revenueDelta: '+6.1%',
    downloads: '286',
    paid: '192',
    free: '94',
    orders: '38',
    conversion: '3.1%',
    chartTotal: 'Rp 3,42 M',
    bars: [0.62, 0.74, 0.88, 1.0],
    barLabels: ['0.7jt', '0.8jt', '1.0jt', '1.1jt'],
  ),
  '30 Hari (Aktif)': AdminPeriodMetrics(
    revenue: 'Rp 14,85 Jt',
    revenueDelta: '+18.4%',
    downloads: '1.240',
    paid: '842',
    free: '398',
    orders: '162',
    conversion: '4.2%',
    chartTotal: 'Rp 14,85 M',
    bars: [0.53, 0.84, 0.91, 1.0],
    barLabels: ['2.4jt', '3.8jt', '4.1jt', '4.5jt'],
  ),
  'Tahun Ini': AdminPeriodMetrics(
    revenue: 'Rp 186,4 Jt',
    revenueDelta: '+34.7%',
    downloads: '14.820',
    paid: '9.612',
    free: '5.208',
    orders: '1.842',
    conversion: '5.4%',
    chartTotal: 'Rp 186,4 M',
    bars: [0.41, 0.66, 0.82, 1.0],
    barLabels: ['38jt', '61jt', '76jt', '93jt'],
  ),
};
