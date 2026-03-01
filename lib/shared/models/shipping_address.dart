import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_address.freezed.dart';
part 'shipping_address.g.dart';

@freezed
class ShippingAddress with _$ShippingAddress {
  const factory ShippingAddress({
    String? id,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    @JsonKey(name: 'postal_code') required String postalCode,
    required String country,
  }) = _ShippingAddress;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);
}
