// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountRepositoryHash() => r'311bf66bfc7992c1b57ce2b1cd046f96cdcd503d';

/// See also [accountRepository].
@ProviderFor(accountRepository)
final accountRepositoryProvider =
    AutoDisposeProvider<AccountRepository>.internal(
      accountRepository,
      name: r'accountRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountRepositoryRef = AutoDisposeProviderRef<AccountRepository>;
String _$userOrdersHash() => r'f6d4c2f1617ba9d029259469b0d70577a87a5738';

/// See also [userOrders].
@ProviderFor(userOrders)
final userOrdersProvider = AutoDisposeFutureProvider<List<Order>>.internal(
  userOrders,
  name: r'userOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserOrdersRef = AutoDisposeFutureProviderRef<List<Order>>;
String _$orderDetailsHash() => r'a81b20d73d84039b2e462b8a545491989a2f8add';

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

/// See also [orderDetails].
@ProviderFor(orderDetails)
const orderDetailsProvider = OrderDetailsFamily();

/// See also [orderDetails].
class OrderDetailsFamily extends Family<AsyncValue<Order?>> {
  /// See also [orderDetails].
  const OrderDetailsFamily();

  /// See also [orderDetails].
  OrderDetailsProvider call(String orderId) {
    return OrderDetailsProvider(orderId);
  }

  @override
  OrderDetailsProvider getProviderOverride(
    covariant OrderDetailsProvider provider,
  ) {
    return call(provider.orderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderDetailsProvider';
}

/// See also [orderDetails].
class OrderDetailsProvider extends AutoDisposeFutureProvider<Order?> {
  /// See also [orderDetails].
  OrderDetailsProvider(String orderId)
    : this._internal(
        (ref) => orderDetails(ref as OrderDetailsRef, orderId),
        from: orderDetailsProvider,
        name: r'orderDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$orderDetailsHash,
        dependencies: OrderDetailsFamily._dependencies,
        allTransitiveDependencies:
            OrderDetailsFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  OrderDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    FutureOr<Order?> Function(OrderDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailsProvider._internal(
        (ref) => create(ref as OrderDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Order?> createElement() {
    return _OrderDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailsProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderDetailsRef on AutoDisposeFutureProviderRef<Order?> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Order?>
    with OrderDetailsRef {
  _OrderDetailsProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailsProvider).orderId;
}

String _$userReturnsHash() => r'5f23639cfc9e14f021ec5ef5b68df98e9700c8c5';

/// See also [userReturns].
@ProviderFor(userReturns)
final userReturnsProvider =
    AutoDisposeFutureProvider<List<ReturnRequest>>.internal(
      userReturns,
      name: r'userReturnsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userReturnsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserReturnsRef = AutoDisposeFutureProviderRef<List<ReturnRequest>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
