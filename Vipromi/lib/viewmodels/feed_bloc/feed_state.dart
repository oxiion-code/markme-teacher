part of 'feed_bloc.dart';

class FeedState {
  final List<ConsumerProduct> allProducts;
  final List<SelectedConsumerProduct> selectedProducts;

  FeedState({this.allProducts = const [], this.selectedProducts = const []});

  double get totalProtein =>
      _calculateTotal((p, q) => (p.proteinPercent / 100) * q);

  double get totalFat => _calculateTotal((p, q) => (p.fatPercent / 100) * q);

  double get totalAsh => _calculateTotal((p, q) => (p.ashPercent / 100) * q);

  double get totalFiber =>
      _calculateTotal((p, q) => (p.fiberPercent / 100) * q);

  double get totalMoisture =>
      _calculateTotal((p, q) => (p.moisturePercent / 100) * q);

  double _calculateTotal(double Function(ConsumerProduct, double) fn) {
    return selectedProducts.fold(
      0.0,
      (sum, sp) => sum + fn(sp.product, sp.quantityInKg),
    );
  }

  FeedState copyWith(
    List<ConsumerProduct>? allProducts,
    List<SelectedConsumerProduct>? selectedProducts,
  ) {
    return FeedState(
      allProducts: allProducts ?? this.allProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts
    );
  }
}
