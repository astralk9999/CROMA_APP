// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addressNotifierHash() => r'c20eb407ac36718944ca7a4da8723b7fb33bd8a7';

/// See also [AddressNotifier].
@ProviderFor(AddressNotifier)
final addressNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      AddressNotifier,
      List<ShippingAddress>
    >.internal(
      AddressNotifier.new,
      name: r'addressNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddressNotifier = AutoDisposeAsyncNotifier<List<ShippingAddress>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
