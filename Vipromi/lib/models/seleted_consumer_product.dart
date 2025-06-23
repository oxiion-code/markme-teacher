import 'package:vipromi/models/feed_product_model.dart';

class SelectedConsumerProduct {
  final ConsumerProduct product;
  final double quantityInKg;

  SelectedConsumerProduct({required this.product, required this.quantityInKg});

  SelectedConsumerProduct copyWith(double? quantityInKg) {
    return SelectedConsumerProduct(
      product: product,
      quantityInKg: quantityInKg ?? this.quantityInKg,
    );
  }
}
