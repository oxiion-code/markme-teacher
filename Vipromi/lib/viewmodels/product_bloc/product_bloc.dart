import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:vipromi/models/product_item_model.dart';
import 'package:vipromi/repositories/product_repository.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent,ProductState>{
  final ProductRepository productRepository;
  ProductBloc(this.productRepository): super(ProductState()){
    on<LoadProductsFromCJson>((event,emit) async{
      final products= await productRepository.loadProducts(event.context);
      emit(ProductState(products: products));
    });
  }
}