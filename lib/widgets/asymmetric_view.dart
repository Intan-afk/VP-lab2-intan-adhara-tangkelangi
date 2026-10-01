import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_columns.dart';

/// Grid asimetris yang bisa digulir horizontal
class AsymmetricView extends StatelessWidget {
  const AsymmetricView({super.key, required this.products});

  final List<Product> products;

  List<Widget> _buildColumns(BuildContext context) {
    if (products.isEmpty) {
      return const <Widget>[];
    }

    return List<Widget>.generate(_listItemCount(products.length), (int index) {
      double width = .59 * MediaQuery.of(context).size.width;
      Widget column;

      if (index % 2 == 0) {
        // Kolom genap: dua produk
        final int bottom = _evenCasesIndex(index);
        column = TwoProductCardColumn(
          bottom: products[bottom],
          top: products.length - 1 >= bottom + 1 ? products[bottom + 1] : null,
        );
        width += 32.0;
      } else {
        // Kolom ganjil: satu produk
        column = OneProductCardColumn(product: products[_oddCasesIndex(index)]);
      }

      return SizedBox(width: width, child: column);
    });
  }

  int _evenCasesIndex(int input) => input ~/ 2 * 3;

  int _oddCasesIndex(int input) {
    assert(input > 0);
    return (input / 2).ceil() * 3 - 1;
  }

  int _listItemCount(int totalItems) {
    return (totalItems % 3 == 0)
        ? totalItems ~/ 3 * 2
        : (totalItems / 3 * 2).ceil() + 1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(0.0, 34.0, 16.0, 44.0),
      physics: const AlwaysScrollableScrollPhysics(),
      children: _buildColumns(context),
    );
  }
}