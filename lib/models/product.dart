enum Category { all, accessories, clothing, home }

class Product {
  const Product({
    required this.category,
    required this.id,
    required this.isFeatured,
    required this.name,
    required this.price,
    this.imageName,
  });
  static const bool useShrineImagesPackage = false;
  static const String imageFolder = 'assets/product/';
  static const String imageExtension = '.jpg';

  final Category category;
  final int id;
  final bool isFeatured;
  final String name;
  final int price;
  final String? imageName;

  // Gambar berasal dari package "shrine_images" (lihat catatan di README)
  String get assetName => imageName ?? '$id-0.jpg';
  String? get assetPackage => useShrineImagesPackage ? 'shrine_images' : null;
}
