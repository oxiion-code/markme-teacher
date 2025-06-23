import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vipromi/models/product_item_model.dart';

class ProductRepository {
  Future<List<Product>> loadProducts(BuildContext context) async {
    final data = await DefaultAssetBundle.of(context).loadString('assets/data/products.json');
    final Map<String, dynamic> jsonData = jsonDecode(data); // Parse as Map
    final List<dynamic> productList = jsonData['products']; // Extract the list
    return productList.map((json) => Product.fromJson(json)).toList();
  }
}
