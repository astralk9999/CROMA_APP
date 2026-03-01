import 'package:freezed_annotation/freezed_annotation.dart';
import 'shipping_address.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    required String status,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'shipping_address') required ShippingAddress shippingAddress,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    Map<String, dynamic>? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Transient field for populated relations
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
