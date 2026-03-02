// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReturnRequestImpl _$$ReturnRequestImplFromJson(Map<String, dynamic> json) =>
    _$ReturnRequestImpl(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      userId: json['user_id'] as String,
      reason: json['reason'] as String,
      details: json['details'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ReturnRequestImplToJson(_$ReturnRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'user_id': instance.userId,
      'reason': instance.reason,
      'details': instance.details,
      'images': instance.images,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ReturnRequestItemImpl _$$ReturnRequestItemImplFromJson(
  Map<String, dynamic> json,
) => _$ReturnRequestItemImpl(
  id: json['id'] as String,
  returnRequestId: json['return_request_id'] as String,
  orderItemId: json['order_item_id'] as String,
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$$ReturnRequestItemImplToJson(
  _$ReturnRequestItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'return_request_id': instance.returnRequestId,
  'order_item_id': instance.orderItemId,
  'quantity': instance.quantity,
};
