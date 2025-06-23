part of 'feed_bloc.dart';
abstract class FeedEvent{}
class LoadConsumerProducts extends FeedEvent{
  final List<ConsumerProduct> consumerProducts;
  LoadConsumerProducts(this.consumerProducts);
}

class ProductSelected extends FeedEvent{
  final ConsumerProduct product;
  ProductSelected(this.product);
}

class LoadProductsFromJson extends FeedEvent {
  final BuildContext context;
  LoadProductsFromJson(this.context);
}


class UpdateProductQuantity extends FeedEvent{
  final ConsumerProduct product;
  final double quantityInKg;
  UpdateProductQuantity({required this.product,required this.quantityInKg});
}

class RemoveProduct extends FeedEvent{
  final ConsumerProduct product;
  RemoveProduct(this.product);
}