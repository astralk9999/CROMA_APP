import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'shipping_address.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

class NotesConverter implements JsonConverter<Map<String, dynamic>?, dynamic> {
  const NotesConverter();

  @override
  Map<String, dynamic>? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) return json;
    if (json is String) {
      try {
        return jsonDecode(json) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  dynamic toJson(Map<String, dynamic>? object) {
    if (object == null) return null;
    return jsonEncode(object);
  }
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    required String status,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'shipping_address') required ShippingAddress shippingAddress,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    @NotesConverter() Map<String, dynamic>? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Transient field for populated relations
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
