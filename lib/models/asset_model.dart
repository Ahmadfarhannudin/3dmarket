class AssetModel {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final String rating;
  final String downloads;
  final String format;
  final bool isFree;
  final String category;
  final String description;

  const AssetModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.rating = '4.9',
    this.downloads = '1.2k',
    this.format = '.blend',
    this.isFree = false,
    this.category = 'Umum',
    this.description = '',
  });
}
