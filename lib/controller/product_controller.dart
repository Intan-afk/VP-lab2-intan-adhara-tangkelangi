import '../models/product.dart';

class ProductsController {
  static const List<Product> _allProducts = <Product>[
    // Accessories
    Product(category: Category.accessories, id: 0, isFeatured: true, name: 'Vagabond sack', price: 120),
    Product(category: Category.accessories, id: 1, isFeatured: true, name: 'Stella sunglasses', price: 58),
    Product(category: Category.accessories, id: 2, isFeatured: false, name: 'Whitney belt', price: 35),
    Product(category: Category.accessories, id: 5, isFeatured: false, name: 'Varsity socks', price: 12),
    Product(category: Category.accessories, id: 6, isFeatured: false, name: 'Weave keyring', price: 16),
    Product(category: Category.accessories, id: 7, isFeatured: true, name: 'Gatsby hat', price: 40),
    // Home
    Product(category: Category.home, id: 9, isFeatured: true, name: 'Gilt desk trio', price: 58),
    Product(category: Category.home, id: 10, isFeatured: false, name: 'Copper wire rack', price: 18),
    Product(category: Category.home, id: 11, isFeatured: false, name: 'Soothe ceramic set', price: 28),
    // Clothing
    Product(category: Category.clothing, id: 19, isFeatured: false, name: 'Clay sweater', price: 48),
    Product(category: Category.clothing, id: 20, isFeatured: false, name: 'Sea tunic', price: 45),
    Product(category: Category.clothing, id: 21, isFeatured: false, name: 'Plaster tunic', price: 38),
  ];

  /// Mengembalikan produk
  List<Product> loadProducts(Category category) {
    if (category == Category.all) {
      return _allProducts;
    }
    return _allProducts.where((p) => p.category == category).toList();
  }
}