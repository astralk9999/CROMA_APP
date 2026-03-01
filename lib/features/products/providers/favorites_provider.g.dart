// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteProductsHash() => r'71457a3cc9a5390c98e5ff99ab5338ca9d1729e4';

/// See also [favoriteProducts].
@ProviderFor(favoriteProducts)
final favoriteProductsProvider = AutoDisposeProvider<List<Product>>.internal(
  favoriteProducts,
  name: r'favoriteProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteProductsRef = AutoDisposeProviderRef<List<Product>>;
String _$favoritesHash() => r'25ee4b7c4a5c3f16d666d1f1fef9b63547514dd8';

/// See also [Favorites].
@ProviderFor(Favorites)
final favoritesProvider =
    AutoDisposeAsyncNotifierProvider<Favorites, List<String>>.internal(
      Favorites.new,
      name: r'favoritesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoritesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Favorites = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
