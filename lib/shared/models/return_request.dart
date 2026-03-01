import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_request.freezed.dart';
part 'return_request.g.dart';

@freezed
class ReturnRequest with _$ReturnRequest {
  const factory ReturnRequest({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'user_id') required String userId,
    required String reason,
    String? details,
    @Default([]) List<String> images,
    required String status, // 'pending', 'approved', 'rejected', 'completed'
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ReturnRequest;

  factory ReturnRequest.fromJson(Map<String, dynamic> json) =>
      _$ReturnRequestFromJson(json);
}

@freezed
class ReturnRequestItem with _$ReturnRequestItem {
  const factory ReturnRequestItem({
    required String id,
    @JsonKey(name: 'return_request_id') required String returnRequestId,
    @JsonKey(name: 'order_item_id') required String orderItemId,
    @Default(1) int quantity,
  }) = _ReturnRequestItem;

  factory ReturnRequestItem.fromJson(Map<String, dynamic> json) =>
      _$ReturnRequestItemFromJson(json);
}
