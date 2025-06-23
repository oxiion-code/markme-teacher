class Product {
  final String name;
  final String imageUrl;
  final List<int> weight;
  final List<String> features;

  Product({
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.features,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      imageUrl: json['image_url'],
      weight: List<int>.from(json['weight_available']),
      features: List<String>.from(json['features']),
    );
  }
}

