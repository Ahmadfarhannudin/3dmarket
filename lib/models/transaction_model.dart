class TransactionModel {
  final String id;
  final String title;
  final String date;
  final String total;
  final String status;
  final String invoice;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.total,
    required this.status,
    required this.invoice,
  });
}
