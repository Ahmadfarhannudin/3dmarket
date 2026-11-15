class OrderItemModel {
  final String assetId;
  final String title;
  final String price;
  final String license;

  const OrderItemModel({
    required this.assetId,
    required this.title,
    required this.price,
    this.license = 'Standard',
  });
}
