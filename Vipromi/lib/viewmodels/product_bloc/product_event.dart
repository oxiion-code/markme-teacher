part of 'product_bloc.dart';
abstract class ProductEvent{}
class LoadProductsFromCJson extends ProductEvent{
  final BuildContext context;
  LoadProductsFromCJson(this.context);
}