import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vipromi/models/feed_product_model.dart';

class FeedRepository {
  Future<List<ConsumerProduct>> loadProductsFromAssets(
    BuildContext context,
  ) async {
    final jsonString= await DefaultAssetBundle.of(context).loadString('assets/data/feed_json_file.json');
    final List<dynamic> jsonList= jsonDecode(jsonString);
    return jsonList.map((json)=>ConsumerProduct.fromJson(json)).toList();
  }
}
