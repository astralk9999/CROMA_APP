// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String?,
  status: json['status'] as String,
  totalAmount: (json['total_amount'] as num).toDouble(),
  shippingAddress: ShippingAddress.fromJson(
    json['shipping_address'] as Map<String, dynamic>,
  ),
  trackingNumber: json['tracking_number'] as String?,
  notes: json['notes'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'status': instance.status,
      'total_amount': instance.totalAmount,
      'shipping_address': instance.shippingAddress,
      'tracking_number': instance.trackingNumber,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
