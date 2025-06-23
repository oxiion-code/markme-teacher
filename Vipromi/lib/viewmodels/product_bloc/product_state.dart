part of 'product_bloc.dart';
class ProductState{
 final List<Product> products;
 ProductState({this.products=const []});

 ProductState copyWith({List<Product>? products}){
  return ProductState(products: products?? this.products);
 }
}