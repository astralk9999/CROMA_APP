// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShippingAddressImpl _$$ShippingAddressImplFromJson(
  Map<String, dynamic> json,
) => _$ShippingAddressImpl(
  id: json['id'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  postalCode: json['postal_code'] as String,
  country: json['country'] as String,
);

Map<String, dynamic> _$$ShippingAddressImplToJson(
  _$ShippingAddressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'address': instance.address,
  'city': instance.city,
  'postal_code': instance.postalCode,
  'country': instance.country,
};
