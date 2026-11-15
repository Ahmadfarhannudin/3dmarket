class WishlistModel {
  final String assetId;
  final String title;
  final String price;
  final String imageUrl;
  final bool isFree;

  const WishlistModel({
    required this.assetId,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.isFree = false,
  });
}
