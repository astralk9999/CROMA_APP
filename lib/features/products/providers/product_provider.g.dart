// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$featuredProductsHash() => r'db13f6bbfa5155c2bb136492ed8dac894ff0c6e3';

/// See also [featuredProducts].
@ProviderFor(featuredProducts)
final featuredProductsProvider =
    AutoDisposeFutureProvider<List<Product>>.internal(
      featuredProducts,
      name: r'featuredProductsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$featuredProductsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedProductsRef = AutoDisposeFutureProviderRef<List<Product>>;
String _$productsByCategoryHash() =>
    r'a120e15fa6701cf879931a53f54c6d42d2284d31';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productsByCategory].
@ProviderFor(productsByCategory)
const productsByCategoryProvider = ProductsByCategoryFamily();

/// See also [productsByCategory].
class ProductsByCategoryFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [productsByCategory].
  const ProductsByCategoryFamily();

  /// See also [productsByCategory].
  ProductsByCategoryProvider call(String categorySlug) {
    return ProductsByCategoryProvider(categorySlug);
  }

  @override
  ProductsByCategoryProvider getProviderOverride(
    covariant ProductsByCategoryProvider provider,
  ) {
    return call(provider.categorySlug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productsByCategoryProvider';
}

/// See also [productsByCategory].
class ProductsByCategoryProvider
    extends AutoDisposeFutureProvider<List<Product>> {
  /// See also [productsByCategory].
  ProductsByCategoryProvider(String categorySlug)
    : this._internal(
        (ref) => productsByCategory(ref as ProductsByCategoryRef, categorySlug),
        from: productsByCategoryProvider,
        name: r'productsByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productsByCategoryHash,
        dependencies: ProductsByCategoryFamily._dependencies,
        allTransitiveDependencies:
            ProductsByCategoryFamily._allTransitiveDependencies,
        categorySlug: categorySlug,
      );

  ProductsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categorySlug,
  }) : super.internal();

  final String categorySlug;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(ProductsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsByCategoryProvider._internal(
        (ref) => create(ref as ProductsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categorySlug: categorySlug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _ProductsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByCategoryProvider &&
        other.categorySlug == categorySlug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categorySlug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductsByCategoryRef on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `categorySlug` of this provider.
  String get categorySlug;
}

class _ProductsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with ProductsByCategoryRef {
  _ProductsByCategoryProviderElement(super.provider);

  @override
  String get categorySlug =>
      (origin as ProductsByCategoryProvider).categorySlug;
}

String _$productBySlugHash() => r'161c9617c09063b01b75d9f92764d044b6724275';

/// See also [productBySlug].
@ProviderFor(productBySlug)
const productBySlugProvider = ProductBySlugFamily();

/// See also [productBySlug].
class ProductBySlugFamily extends Family<AsyncValue<Product?>> {
  /// See also [productBySlug].
  const ProductBySlugFamily();

  /// See also [productBySlug].
  ProductBySlugProvider call(String slug) {
    return ProductBySlugProvider(slug);
  }

  @override
  ProductBySlugProvider getProviderOverride(
    covariant ProductBySlugProvider provider,
  ) {
    return call(provider.slug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productBySlugProvider';
}

/// See also [productBySlug].
class ProductBySlugProvider extends AutoDisposeFutureProvider<Product?> {
  /// See also [productBySlug].
  ProductBySlugProvider(String slug)
    : this._internal(
        (ref) => productBySlug(ref as ProductBySlugRef, slug),
        from: productBySlugProvider,
        name: r'productBySlugProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productBySlugHash,
        dependencies: ProductBySlugFamily._dependencies,
        allTransitiveDependencies:
            ProductBySlugFamily._allTransitiveDependencies,
        slug: slug,
      );

  ProductBySlugProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<Product?> Function(ProductBySlugRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductBySlugProvider._internal(
        (ref) => create(ref as ProductBySlugRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Product?> createElement() {
    return _ProductBySlugProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductBySlugProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductBySlugRef on AutoDisposeFutureProviderRef<Product?> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ProductBySlugProviderElement
    extends AutoDisposeFutureProviderElement<Product?>
    with ProductBySlugRef {
  _ProductBySlugProviderElement(super.provider);

  @override
  String get slug => (origin as ProductBySlugProvider).slug;
}

String _$allProductsHash() => r'c8a7696e7ff3d2fa139dd813fb6a70f93e205a8c';

/// See also [allProducts].
@ProviderFor(allProducts)
final allProductsProvider = AutoDisposeFutureProvider<List<Product>>.internal(
  allProducts,
  name: r'allProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllProductsRef = AutoDisposeFutureProviderRef<List<Product>>;
String _$searchProductsHash() => r'98cc933d06a05ce0c9d682b0bb8070ac2023173d';

/// See also [searchProducts].
@ProviderFor(searchProducts)
const searchProductsProvider = SearchProductsFamily();

/// See also [searchProducts].
class SearchProductsFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [searchProducts].
  const SearchProductsFamily();

  /// See also [searchProducts].
  SearchProductsProvider call(String query) {
    return SearchProductsProvider(query);
  }

  @override
  SearchProductsProvider getProviderOverride(
    covariant SearchProductsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchProductsProvider';
}

/// See also [searchProducts].
class SearchProductsProvider extends AutoDisposeFutureProvider<List<Product>> {
  /// See also [searchProducts].
  SearchProductsProvider(String query)
    : this._internal(
        (ref) => searchProducts(ref as SearchProductsRef, query),
        from: searchProductsProvider,
        name: r'searchProductsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchProductsHash,
        dependencies: SearchProductsFamily._dependencies,
        allTransitiveDependencies:
            SearchProductsFamily._allTransitiveDependencies,
        query: query,
      );

  SearchProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(SearchProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchProductsProvider._internal(
        (ref) => create(ref as SearchProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _SearchProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProductsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchProductsRef on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with SearchProductsRef {
  _SearchProductsProviderElement(super.provider);

  @override
  String get query => (origin as SearchProductsProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
