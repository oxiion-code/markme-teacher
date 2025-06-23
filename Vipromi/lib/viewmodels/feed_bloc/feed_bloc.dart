import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:vipromi/repositories/feed_repository.dart';

import '../../models/seleted_consumer_product.dart';
import 'package:vipromi/models/feed_product_model.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;
  FeedBloc(this.feedRepository) : super(FeedState()) {
    on<LoadConsumerProducts>((event, emit) {
      emit(state.copyWith(event.consumerProducts, state.selectedProducts));
    });

    on<ProductSelected>((event, emit) {
      final alreadySelected = state.selectedProducts
          .any((sp) => sp.product.rawMaterial == event.product.rawMaterial);
      if (!alreadySelected) {
        final updatedList = List<SelectedConsumerProduct>.from(state.selectedProducts)
          ..add(SelectedConsumerProduct(product: event.product, quantityInKg: 0));
        emit(state.copyWith(null, updatedList));
      }
    });


    on<LoadProductsFromJson>((event, emit) async {
      final products = await feedRepository.loadProductsFromAssets(event.context);
      emit(state.copyWith(products, state.selectedProducts));
    });

    on<UpdateProductQuantity>((event, emit) {
      final updatedList = state.selectedProducts.map((sp) {
        if (sp.product.rawMaterial == event.product.rawMaterial) {
          return sp.copyWith(event.quantityInKg);
        }
        return sp;
      }).toList();
      emit(state.copyWith(null, updatedList));
    });

    on<RemoveProduct>((event, emit) {
      final updatedList = List<SelectedConsumerProduct>.from(state.selectedProducts)
        ..removeWhere((sp) => sp.product.rawMaterial == event.product.rawMaterial);
      emit(state.copyWith(null, updatedList));
    });
  }
}
