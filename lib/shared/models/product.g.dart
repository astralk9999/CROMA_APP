// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(
  Map<String, dynamic> json,
) => _$ProductImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num).toDouble(),
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  stockBySizes: json['stock_by_sizes'] as Map<String, dynamic>?,
  categoryId: json['category_id'] as String?,
  category: json['category'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sizes:
      (json['sizes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  colors:
      (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  brand: json['brand'] as String?,
  featured: json['featured'] as bool? ?? false,
  salePrice: (json['sale_price'] as num?)?.toDouble(),
  saleEndsAt: json['sale_ends_at'] == null
      ? null
      : DateTime.parse(json['sale_ends_at'] as String),
  isLimitedDrop: json['is_limited_drop'] as bool?,
  dropEndDate: json['drop_end_date'] == null
      ? null
      : DateTime.parse(json['drop_end_date'] as String),
  discountActive: json['discount_active'] as bool?,
  discountPercent: (json['discount_percent'] as num?)?.toInt(),
  discountEndDate: json['discount_end_date'] == null
      ? null
      : DateTime.parse(json['discount_end_date'] as String),
  launchDate: json['launch_date'] == null
      ? null
      : DateTime.parse(json['launch_date'] as String),
  availableFrom: json['available_from'] == null
      ? null
      : DateTime.parse(json['available_from'] as String),
  isViralTrend: json['is_viral_trend'] as bool?,
  isBestseller: json['is_bestseller'] as bool?,
  isHidden: json['is_hidden'] as bool?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'stock_by_sizes': instance.stockBySizes,
      'category_id': instance.categoryId,
      'category': instance.category,
      'images': instance.images,
      'sizes': instance.sizes,
      'colors': instance.colors,
      'brand': instance.brand,
      'featured': instance.featured,
      'sale_price': instance.salePrice,
      'sale_ends_at': instance.saleEndsAt?.toIso8601String(),
      'is_limited_drop': instance.isLimitedDrop,
      'drop_end_date': instance.dropEndDate?.toIso8601String(),
      'discount_active': instance.discountActive,
      'discount_percent': instance.discountPercent,
      'discount_end_date': instance.discountEndDate?.toIso8601String(),
      'launch_date': instance.launchDate?.toIso8601String(),
      'available_from': instance.availableFrom?.toIso8601String(),
      'is_viral_trend': instance.isViralTrend,
      'is_bestseller': instance.isBestseller,
      'is_hidden': instance.isHidden,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
