class Product {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final int stock;
  final Map<String, int>? stockBySizes;
  final String? categoryId;
  final List<String> images;
  final List<String> sizes;
  final bool featured;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    required this.stock,
    this.stockBySizes,
    this.categoryId,
    required this.images,
    required this.sizes,
    required this.featured,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      stockBySizes: json['stock_by_sizes'] != null
          ? Map<String, int>.from(json['stock_by_sizes'])
          : null,
      categoryId: json['category_id'] as String?,
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : [],
      featured: json['featured'] as bool? ?? false,
    );
  }
}
