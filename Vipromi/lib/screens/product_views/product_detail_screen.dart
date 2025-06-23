import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vipromi/models/product_item_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/contactus');
        },
        label: Text("Contact Us"),
        icon: Icon(Icons.email_outlined),
        backgroundColor: Colors.orange[100],
      ),
      appBar: AppBar(
        title: Text(
          product.name,
          style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: Colors.orange[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Center(child: Image.network(product.imageUrl, height: 200)),
              const SizedBox(height: 20),
              Text(
                product.name,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Available Weights: ${product.weight.join(', ')} KG"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text("Ratings: "),
                  ...List.generate(
                    5,
                    (index) => Icon(Icons.star, color: Colors.orangeAccent),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Features',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Column(
                children: [
                  ...product.features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("-$f"),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
