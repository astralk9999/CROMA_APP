import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../shared/models/shipping_address.dart';

part 'address_repository.g.dart';

class AddressRepository {
  final _client = SupabaseService.client;

  Future<List<ShippingAddress>> getAddresses() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('shipping_addresses')
        .select()
        .eq('user_id', user.id)
        .order('is_default', ascending: false);

    return (data as List).map((e) => ShippingAddress.fromJson(e)).toList();
  }

  Future<void> saveAddress(ShippingAddress address) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('shipping_addresses').upsert({
      ...address.toJson(),
      'user_id': user.id,
    });
  }

  Future<void> deleteAddress(String id) async {
    await _client.from('shipping_addresses').delete().eq('id', id);
  }
}

@riverpod
AddressRepository addressRepository(Ref ref) {
  return AddressRepository();
}
