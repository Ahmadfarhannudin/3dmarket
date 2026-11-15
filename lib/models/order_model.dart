import 'package:_3dmarket/models/order_item_model.dart';

class OrderModel {
  final String id;
  final String buyerName;
  final String buyerEmail;
  final String date;
  final String total;
  final String status;
  final String method;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.buyerName,
    required this.buyerEmail,
    required this.date,
    required this.total,
    required this.status,
    this.method = 'QRIS',
    this.items = const [],
  });
}
