import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vipromi/screens/product_views/product_item.dart';
import 'package:vipromi/viewmodels/product_bloc/product_bloc.dart';


class ProductsListView extends StatelessWidget {
  const ProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: GoogleFonts.inriaSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.orange[300],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.products.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product=state.products[index];
              return ProductItem(product);
            },
          );
        },
      ),
    );
  }
}
