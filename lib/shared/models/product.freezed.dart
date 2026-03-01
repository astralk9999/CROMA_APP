// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_by_sizes')
  Map<String, dynamic>? get stockBySizes => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<String> get sizes => throw _privateConstructorUsedError;
  List<String> get colors => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  bool get featured => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_price')
  double? get salePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_ends_at')
  DateTime? get saleEndsAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_limited_drop')
  bool? get isLimitedDrop => throw _privateConstructorUsedError;
  @JsonKey(name: 'drop_end_date')
  DateTime? get dropEndDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_active')
  bool? get discountActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_percent')
  int? get discountPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_end_date')
  DateTime? get discountEndDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'launch_date')
  DateTime? get launchDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_viral_trend')
  bool? get isViralTrend => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_bestseller')
  bool? get isBestseller => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_hidden')
  bool? get isHidden => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    double price,
    int stock,
    @JsonKey(name: 'stock_by_sizes') Map<String, dynamic>? stockBySizes,
    @JsonKey(name: 'category_id') String? categoryId,
    String? category,
    List<String> images,
    List<String> sizes,
    List<String> colors,
    String? brand,
    bool featured,
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
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? price = null,
    Object? stock = null,
    Object? stockBySizes = freezed,
    Object? categoryId = freezed,
    Object? category = freezed,
    Object? images = null,
    Object? sizes = null,
    Object? colors = null,
    Object? brand = freezed,
    Object? featured = null,
    Object? salePrice = freezed,
    Object? saleEndsAt = freezed,
    Object? isLimitedDrop = freezed,
    Object? dropEndDate = freezed,
    Object? discountActive = freezed,
    Object? discountPercent = freezed,
    Object? discountEndDate = freezed,
    Object? launchDate = freezed,
    Object? availableFrom = freezed,
    Object? isViralTrend = freezed,
    Object? isBestseller = freezed,
    Object? isHidden = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as int,
            stockBySizes: freezed == stockBySizes
                ? _value.stockBySizes
                : stockBySizes // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            sizes: null == sizes
                ? _value.sizes
                : sizes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            colors: null == colors
                ? _value.colors
                : colors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            featured: null == featured
                ? _value.featured
                : featured // ignore: cast_nullable_to_non_nullable
                      as bool,
            salePrice: freezed == salePrice
                ? _value.salePrice
                : salePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            saleEndsAt: freezed == saleEndsAt
                ? _value.saleEndsAt
                : saleEndsAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isLimitedDrop: freezed == isLimitedDrop
                ? _value.isLimitedDrop
                : isLimitedDrop // ignore: cast_nullable_to_non_nullable
                      as bool?,
            dropEndDate: freezed == dropEndDate
                ? _value.dropEndDate
                : dropEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            discountActive: freezed == discountActive
                ? _value.discountActive
                : discountActive // ignore: cast_nullable_to_non_nullable
                      as bool?,
            discountPercent: freezed == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                      as int?,
            discountEndDate: freezed == discountEndDate
                ? _value.discountEndDate
                : discountEndDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            launchDate: freezed == launchDate
                ? _value.launchDate
                : launchDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            availableFrom: freezed == availableFrom
                ? _value.availableFrom
                : availableFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isViralTrend: freezed == isViralTrend
                ? _value.isViralTrend
                : isViralTrend // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isBestseller: freezed == isBestseller
                ? _value.isBestseller
                : isBestseller // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isHidden: freezed == isHidden
                ? _value.isHidden
                : isHidden // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String slug,
    String? description,
    double price,
    int stock,
    @JsonKey(name: 'stock_by_sizes') Map<String, dynamic>? stockBySizes,
    @JsonKey(name: 'category_id') String? categoryId,
    String? category,
    List<String> images,
    List<String> sizes,
    List<String> colors,
    String? brand,
    bool featured,
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
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? price = null,
    Object? stock = null,
    Object? stockBySizes = freezed,
    Object? categoryId = freezed,
    Object? category = freezed,
    Object? images = null,
    Object? sizes = null,
    Object? colors = null,
    Object? brand = freezed,
    Object? featured = null,
    Object? salePrice = freezed,
    Object? saleEndsAt = freezed,
    Object? isLimitedDrop = freezed,
    Object? dropEndDate = freezed,
    Object? discountActive = freezed,
    Object? discountPercent = freezed,
    Object? discountEndDate = freezed,
    Object? launchDate = freezed,
    Object? availableFrom = freezed,
    Object? isViralTrend = freezed,
    Object? isBestseller = freezed,
    Object? isHidden = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as int,
        stockBySizes: freezed == stockBySizes
            ? _value._stockBySizes
            : stockBySizes // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sizes: null == sizes
            ? _value._sizes
            : sizes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        colors: null == colors
            ? _value._colors
            : colors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        featured: null == featured
            ? _value.featured
            : featured // ignore: cast_nullable_to_non_nullable
                  as bool,
        salePrice: freezed == salePrice
            ? _value.salePrice
            : salePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        saleEndsAt: freezed == saleEndsAt
            ? _value.saleEndsAt
            : saleEndsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isLimitedDrop: freezed == isLimitedDrop
            ? _value.isLimitedDrop
            : isLimitedDrop // ignore: cast_nullable_to_non_nullable
                  as bool?,
        dropEndDate: freezed == dropEndDate
            ? _value.dropEndDate
            : dropEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        discountActive: freezed == discountActive
            ? _value.discountActive
            : discountActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
        discountPercent: freezed == discountPercent
            ? _value.discountPercent
            : discountPercent // ignore: cast_nullable_to_non_nullable
                  as int?,
        discountEndDate: freezed == discountEndDate
            ? _value.discountEndDate
            : discountEndDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        launchDate: freezed == launchDate
            ? _value.launchDate
            : launchDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        availableFrom: freezed == availableFrom
            ? _value.availableFrom
            : availableFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isViralTrend: freezed == isViralTrend
            ? _value.isViralTrend
            : isViralTrend // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isBestseller: freezed == isBestseller
            ? _value.isBestseller
            : isBestseller // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isHidden: freezed == isHidden
            ? _value.isHidden
            : isHidden // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.stock = 0,
    @JsonKey(name: 'stock_by_sizes') final Map<String, dynamic>? stockBySizes,
    @JsonKey(name: 'category_id') this.categoryId,
    this.category,
    final List<String> images = const [],
    final List<String> sizes = const [],
    final List<String> colors = const [],
    this.brand,
    this.featured = false,
    @JsonKey(name: 'sale_price') this.salePrice,
    @JsonKey(name: 'sale_ends_at') this.saleEndsAt,
    @JsonKey(name: 'is_limited_drop') this.isLimitedDrop,
    @JsonKey(name: 'drop_end_date') this.dropEndDate,
    @JsonKey(name: 'discount_active') this.discountActive,
    @JsonKey(name: 'discount_percent') this.discountPercent,
    @JsonKey(name: 'discount_end_date') this.discountEndDate,
    @JsonKey(name: 'launch_date') this.launchDate,
    @JsonKey(name: 'available_from') this.availableFrom,
    @JsonKey(name: 'is_viral_trend') this.isViralTrend,
    @JsonKey(name: 'is_bestseller') this.isBestseller,
    @JsonKey(name: 'is_hidden') this.isHidden,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _stockBySizes = stockBySizes,
       _images = images,
       _sizes = sizes,
       _colors = colors;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final double price;
  @override
  @JsonKey()
  final int stock;
  final Map<String, dynamic>? _stockBySizes;
  @override
  @JsonKey(name: 'stock_by_sizes')
  Map<String, dynamic>? get stockBySizes {
    final value = _stockBySizes;
    if (value == null) return null;
    if (_stockBySizes is EqualUnmodifiableMapView) return _stockBySizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  final String? category;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String> _sizes;
  @override
  @JsonKey()
  List<String> get sizes {
    if (_sizes is EqualUnmodifiableListView) return _sizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sizes);
  }

  final List<String> _colors;
  @override
  @JsonKey()
  List<String> get colors {
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colors);
  }

  @override
  final String? brand;
  @override
  @JsonKey()
  final bool featured;
  @override
  @JsonKey(name: 'sale_price')
  final double? salePrice;
  @override
  @JsonKey(name: 'sale_ends_at')
  final DateTime? saleEndsAt;
  @override
  @JsonKey(name: 'is_limited_drop')
  final bool? isLimitedDrop;
  @override
  @JsonKey(name: 'drop_end_date')
  final DateTime? dropEndDate;
  @override
  @JsonKey(name: 'discount_active')
  final bool? discountActive;
  @override
  @JsonKey(name: 'discount_percent')
  final int? discountPercent;
  @override
  @JsonKey(name: 'discount_end_date')
  final DateTime? discountEndDate;
  @override
  @JsonKey(name: 'launch_date')
  final DateTime? launchDate;
  @override
  @JsonKey(name: 'available_from')
  final DateTime? availableFrom;
  @override
  @JsonKey(name: 'is_viral_trend')
  final bool? isViralTrend;
  @override
  @JsonKey(name: 'is_bestseller')
  final bool? isBestseller;
  @override
  @JsonKey(name: 'is_hidden')
  final bool? isHidden;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, slug: $slug, description: $description, price: $price, stock: $stock, stockBySizes: $stockBySizes, categoryId: $categoryId, category: $category, images: $images, sizes: $sizes, colors: $colors, brand: $brand, featured: $featured, salePrice: $salePrice, saleEndsAt: $saleEndsAt, isLimitedDrop: $isLimitedDrop, dropEndDate: $dropEndDate, discountActive: $discountActive, discountPercent: $discountPercent, discountEndDate: $discountEndDate, launchDate: $launchDate, availableFrom: $availableFrom, isViralTrend: $isViralTrend, isBestseller: $isBestseller, isHidden: $isHidden, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            const DeepCollectionEquality().equals(
              other._stockBySizes,
              _stockBySizes,
            ) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._sizes, _sizes) &&
            const DeepCollectionEquality().equals(other._colors, _colors) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.saleEndsAt, saleEndsAt) ||
                other.saleEndsAt == saleEndsAt) &&
            (identical(other.isLimitedDrop, isLimitedDrop) ||
                other.isLimitedDrop == isLimitedDrop) &&
            (identical(other.dropEndDate, dropEndDate) ||
                other.dropEndDate == dropEndDate) &&
            (identical(other.discountActive, discountActive) ||
                other.discountActive == discountActive) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountEndDate, discountEndDate) ||
                other.discountEndDate == discountEndDate) &&
            (identical(other.launchDate, launchDate) ||
                other.launchDate == launchDate) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.isViralTrend, isViralTrend) ||
                other.isViralTrend == isViralTrend) &&
            (identical(other.isBestseller, isBestseller) ||
                other.isBestseller == isBestseller) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    slug,
    description,
    price,
    stock,
    const DeepCollectionEquality().hash(_stockBySizes),
    categoryId,
    category,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_sizes),
    const DeepCollectionEquality().hash(_colors),
    brand,
    featured,
    salePrice,
    saleEndsAt,
    isLimitedDrop,
    dropEndDate,
    discountActive,
    discountPercent,
    discountEndDate,
    launchDate,
    availableFrom,
    isViralTrend,
    isBestseller,
    isHidden,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String id,
    required final String name,
    required final String slug,
    final String? description,
    required final double price,
    final int stock,
    @JsonKey(name: 'stock_by_sizes') final Map<String, dynamic>? stockBySizes,
    @JsonKey(name: 'category_id') final String? categoryId,
    final String? category,
    final List<String> images,
    final List<String> sizes,
    final List<String> colors,
    final String? brand,
    final bool featured,
    @JsonKey(name: 'sale_price') final double? salePrice,
    @JsonKey(name: 'sale_ends_at') final DateTime? saleEndsAt,
    @JsonKey(name: 'is_limited_drop') final bool? isLimitedDrop,
    @JsonKey(name: 'drop_end_date') final DateTime? dropEndDate,
    @JsonKey(name: 'discount_active') final bool? discountActive,
    @JsonKey(name: 'discount_percent') final int? discountPercent,
    @JsonKey(name: 'discount_end_date') final DateTime? discountEndDate,
    @JsonKey(name: 'launch_date') final DateTime? launchDate,
    @JsonKey(name: 'available_from') final DateTime? availableFrom,
    @JsonKey(name: 'is_viral_trend') final bool? isViralTrend,
    @JsonKey(name: 'is_bestseller') final bool? isBestseller,
    @JsonKey(name: 'is_hidden') final bool? isHidden,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  double get price;
  @override
  int get stock;
  @override
  @JsonKey(name: 'stock_by_sizes')
  Map<String, dynamic>? get stockBySizes;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  String? get category;
  @override
  List<String> get images;
  @override
  List<String> get sizes;
  @override
  List<String> get colors;
  @override
  String? get brand;
  @override
  bool get featured;
  @override
  @JsonKey(name: 'sale_price')
  double? get salePrice;
  @override
  @JsonKey(name: 'sale_ends_at')
  DateTime? get saleEndsAt;
  @override
  @JsonKey(name: 'is_limited_drop')
  bool? get isLimitedDrop;
  @override
  @JsonKey(name: 'drop_end_date')
  DateTime? get dropEndDate;
  @override
  @JsonKey(name: 'discount_active')
  bool? get discountActive;
  @override
  @JsonKey(name: 'discount_percent')
  int? get discountPercent;
  @override
  @JsonKey(name: 'discount_end_date')
  DateTime? get discountEndDate;
  @override
  @JsonKey(name: 'launch_date')
  DateTime? get launchDate;
  @override
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom;
  @override
  @JsonKey(name: 'is_viral_trend')
  bool? get isViralTrend;
  @override
  @JsonKey(name: 'is_bestseller')
  bool? get isBestseller;
  @override
  @JsonKey(name: 'is_hidden')
  bool? get isHidden;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
