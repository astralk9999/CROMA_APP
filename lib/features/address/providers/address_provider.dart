import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fashion_store/features/address/data/address_repository.dart';
import '../../../../shared/models/shipping_address.dart';

part 'address_provider.g.dart';

@riverpod
class AddressNotifier extends _$AddressNotifier {
  @override
  Future<List<ShippingAddress>> build() {
    return ref.watch(addressRepositoryProvider).getAddresses();
  }

  Future<void> saveAddress(ShippingAddress address) async {
    await ref.read(addressRepositoryProvider).saveAddress(address);
    ref.invalidateSelf();
  }

  Future<void> deleteAddress(String id) async {
    await ref.read(addressRepositoryProvider).deleteAddress(id);
    ref.invalidateSelf();
  }
}
