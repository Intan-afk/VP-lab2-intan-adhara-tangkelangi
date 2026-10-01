import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../models/product.dart';
import '../widgets/asymmetric_view.dart';
import '../widgets/backdrop.dart';
import '../widgets/category_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductsController _controller = ProductsController();
  Category _currentCategory = Category.all;

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      currentCategory: _currentCategory,
      frontLayer: AsymmetricView(
        products: _controller.loadProducts(_currentCategory),
      ),
      backLayer: CategoryMenuPage(
        currentCategory: _currentCategory,
        onCategoryTap: _onCategoryTap,
      ),
      frontTitle: const Text('SHRINE'),
      backTitle: const Text('MENU'),
    );
  }
}