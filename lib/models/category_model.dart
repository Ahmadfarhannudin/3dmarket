class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int assetCount;

  const CategoryModel({
    required this.id,
    required this.name,
    this.icon = 'view_in_ar',
    this.assetCount = 0,
  });
}
