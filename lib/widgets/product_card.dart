import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.imageAspectRatio = 33 / 49,
    required this.product,
  }) : assert(imageAspectRatio > 0);

  static const double kTextBoxHeight = 65.0;

  final double imageAspectRatio;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;

    final Widget imageWidget = Image.asset(
      product.assetName,
      package: product.assetPackage,
      fit: BoxFit.cover,
      // Placeholder jika package shrine_images belum dipasang
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade200,
        child: const Image(image: AssetImage('assets/product/placeholder.png'), fit: BoxFit.contain, height: 48),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(aspectRatio: imageAspectRatio, child: imageWidget),
        SizedBox(
          height: MediaQuery.textScalerOf(context).scale(kTextBoxHeight),
          width: 121.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                product.name,
                style: theme.labelLarge,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4.0),
              Text('\$${product.price}', style: theme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}