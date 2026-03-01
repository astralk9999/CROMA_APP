import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String slug,
    String? description,
    required double price,
    @Default(0) int stock,
    @JsonKey(name: 'stock_by_sizes') Map<String, dynamic>? stockBySizes,
    @JsonKey(name: 'category_id') String? categoryId,
    String? category,
    @Default([]) List<String> images,
    @Default([]) List<String> sizes,
    @Default([]) List<String> colors,
    String? brand,
    @Default(false) bool featured,
    @JsonKey(name: 'sale_price') double? salePrice,
    @JsonKey(name: 'sale_ends_at') DateTime? saleEndsAt,
    @JsonKey(name: 'is_limited_drop') bool? isLimitedDrop,
    @JsonKey(name: 'drop_end_date') DateTime? dropEndDate,
    @JsonKey(name: 'discount_active') bool? discountActive,
    @JsonKey(name: 'discount_percent') int? discountPercent,
    @JsonKey(name: 'discount_end_date') DateTime? discountEndDate,
    @JsonKey(name: 'launch_date') DateTime? launchDate,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'is_viral_trend') bool? isViralTrend,
    @JsonKey(name: 'is_bestseller') bool? isBestseller,
    @JsonKey(name: 'is_hidden') bool? isHidden,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

extension ProductExtensions on Product {
  bool get hasDiscount =>
      (discountActive ?? false) || (salePrice != null && salePrice! < price);
  double get finalPrice {
    if (discountActive == true && discountPercent != null) {
      return price * (1 - (discountPercent! / 100));
    }
    return salePrice ?? price;
  }

  bool get isUpcoming {
    final date = launchDate ?? availableFrom;
    if (date == null) return false;
    return date.isAfter(DateTime.now());
  }

  int get effectiveStock {
    if (stockBySizes == null || stockBySizes!.isEmpty) return 0;
    return stockBySizes!.values.fold<int>(
      0,
      (sum, quantity) => sum + (quantity as int? ?? 0),
    );
  }
}
