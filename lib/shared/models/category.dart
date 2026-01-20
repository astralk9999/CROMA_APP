class Category {
  final String id;
  final String name;
  final String slug;
  final String?
  imageUrl; // Added as it was used in web home_screen hardcoded list, but check schema

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['image_url'] as String?, // Optional
    );
  }
}
