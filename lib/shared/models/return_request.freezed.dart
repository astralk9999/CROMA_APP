// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReturnRequest _$ReturnRequestFromJson(Map<String, dynamic> json) {
  return _ReturnRequest.fromJson(json);
}

/// @nodoc
mixin _$ReturnRequest {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'approved', 'rejected', 'completed'
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReturnRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReturnRequestCopyWith<ReturnRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnRequestCopyWith<$Res> {
  factory $ReturnRequestCopyWith(
    ReturnRequest value,
    $Res Function(ReturnRequest) then,
  ) = _$ReturnRequestCopyWithImpl<$Res, ReturnRequest>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'user_id') String userId,
    String reason,
    String? details,
    List<String> images,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$ReturnRequestCopyWithImpl<$Res, $Val extends ReturnRequest>
    implements $ReturnRequestCopyWith<$Res> {
  _$ReturnRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? userId = null,
    Object? reason = null,
    Object? details = freezed,
    Object? images = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            details: freezed == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReturnRequestImplCopyWith<$Res>
    implements $ReturnRequestCopyWith<$Res> {
  factory _$$ReturnRequestImplCopyWith(
    _$ReturnRequestImpl value,
    $Res Function(_$ReturnRequestImpl) then,
  ) = __$$ReturnRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'order_id') String orderId,
    @JsonKey(name: 'user_id') String userId,
    String reason,
    String? details,
    List<String> images,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$ReturnRequestImplCopyWithImpl<$Res>
    extends _$ReturnRequestCopyWithImpl<$Res, _$ReturnRequestImpl>
    implements _$$ReturnRequestImplCopyWith<$Res> {
  __$$ReturnRequestImplCopyWithImpl(
    _$ReturnRequestImpl _value,
    $Res Function(_$ReturnRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? userId = null,
    Object? reason = null,
    Object? details = freezed,
    Object? images = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ReturnRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        details: freezed == details
            ? _value.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReturnRequestImpl implements _ReturnRequest {
  const _$ReturnRequestImpl({
    required this.id,
    @JsonKey(name: 'order_id') required this.orderId,
    @JsonKey(name: 'user_id') required this.userId,
    required this.reason,
    this.details,
    final List<String> images = const [],
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _images = images;

  factory _$ReturnRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReturnRequestImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String reason;
  @override
  final String? details;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String status;
  // 'pending', 'approved', 'rejected', 'completed'
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ReturnRequest(id: $id, orderId: $orderId, userId: $userId, reason: $reason, details: $details, images: $images, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReturnRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.details, details) || other.details == details) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    userId,
    reason,
    details,
    const DeepCollectionEquality().hash(_images),
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReturnRequestImplCopyWith<_$ReturnRequestImpl> get copyWith =>
      __$$ReturnRequestImplCopyWithImpl<_$ReturnRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReturnRequestImplToJson(this);
  }
}

abstract class _ReturnRequest implements ReturnRequest {
  const factory _ReturnRequest({
    required final String id,
    @JsonKey(name: 'order_id') required final String orderId,
    @JsonKey(name: 'user_id') required final String userId,
    required final String reason,
    final String? details,
    final List<String> images,
    required final String status,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$ReturnRequestImpl;

  factory _ReturnRequest.fromJson(Map<String, dynamic> json) =
      _$ReturnRequestImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get reason;
  @override
  String? get details;
  @override
  List<String> get images;
  @override
  String get status; // 'pending', 'approved', 'rejected', 'completed'
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ReturnRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReturnRequestImplCopyWith<_$ReturnRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReturnRequestItem _$ReturnRequestItemFromJson(Map<String, dynamic> json) {
  return _ReturnRequestItem.fromJson(json);
}

/// @nodoc
mixin _$ReturnRequestItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'return_request_id')
  String get returnRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_item_id')
  String get orderItemId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this ReturnRequestItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReturnRequestItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReturnRequestItemCopyWith<ReturnRequestItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnRequestItemCopyWith<$Res> {
  factory $ReturnRequestItemCopyWith(
    ReturnRequestItem value,
    $Res Function(ReturnRequestItem) then,
  ) = _$ReturnRequestItemCopyWithImpl<$Res, ReturnRequestItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'return_request_id') String returnRequestId,
    @JsonKey(name: 'order_item_id') String orderItemId,
    int quantity,
  });
}

/// @nodoc
class _$ReturnRequestItemCopyWithImpl<$Res, $Val extends ReturnRequestItem>
    implements $ReturnRequestItemCopyWith<$Res> {
  _$ReturnRequestItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReturnRequestItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? returnRequestId = null,
    Object? orderItemId = null,
    Object? quantity = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            returnRequestId: null == returnRequestId
                ? _value.returnRequestId
                : returnRequestId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderItemId: null == orderItemId
                ? _value.orderItemId
                : orderItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReturnRequestItemImplCopyWith<$Res>
    implements $ReturnRequestItemCopyWith<$Res> {
  factory _$$ReturnRequestItemImplCopyWith(
    _$ReturnRequestItemImpl value,
    $Res Function(_$ReturnRequestItemImpl) then,
  ) = __$$ReturnRequestItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'return_request_id') String returnRequestId,
    @JsonKey(name: 'order_item_id') String orderItemId,
    int quantity,
  });
}

/// @nodoc
class __$$ReturnRequestItemImplCopyWithImpl<$Res>
    extends _$ReturnRequestItemCopyWithImpl<$Res, _$ReturnRequestItemImpl>
    implements _$$ReturnRequestItemImplCopyWith<$Res> {
  __$$ReturnRequestItemImplCopyWithImpl(
    _$ReturnRequestItemImpl _value,
    $Res Function(_$ReturnRequestItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReturnRequestItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? returnRequestId = null,
    Object? orderItemId = null,
    Object? quantity = null,
  }) {
    return _then(
      _$ReturnRequestItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        returnRequestId: null == returnRequestId
            ? _value.returnRequestId
            : returnRequestId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderItemId: null == orderItemId
            ? _value.orderItemId
            : orderItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReturnRequestItemImpl implements _ReturnRequestItem {
  const _$ReturnRequestItemImpl({
    required this.id,
    @JsonKey(name: 'return_request_id') required this.returnRequestId,
    @JsonKey(name: 'order_item_id') required this.orderItemId,
    this.quantity = 1,
  });

  factory _$ReturnRequestItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReturnRequestItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'return_request_id')
  final String returnRequestId;
  @override
  @JsonKey(name: 'order_item_id')
  final String orderItemId;
  @override
  @JsonKey()
  final int quantity;

  @override
  String toString() {
    return 'ReturnRequestItem(id: $id, returnRequestId: $returnRequestId, orderItemId: $orderItemId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReturnRequestItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.returnRequestId, returnRequestId) ||
                other.returnRequestId == returnRequestId) &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, returnRequestId, orderItemId, quantity);

  /// Create a copy of ReturnRequestItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReturnRequestItemImplCopyWith<_$ReturnRequestItemImpl> get copyWith =>
      __$$ReturnRequestItemImplCopyWithImpl<_$ReturnRequestItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReturnRequestItemImplToJson(this);
  }
}

abstract class _ReturnRequestItem implements ReturnRequestItem {
  const factory _ReturnRequestItem({
    required final String id,
    @JsonKey(name: 'return_request_id') required final String returnRequestId,
    @JsonKey(name: 'order_item_id') required final String orderItemId,
    final int quantity,
  }) = _$ReturnRequestItemImpl;

  factory _ReturnRequestItem.fromJson(Map<String, dynamic> json) =
      _$ReturnRequestItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'return_request_id')
  String get returnRequestId;
  @override
  @JsonKey(name: 'order_item_id')
  String get orderItemId;
  @override
  int get quantity;

  /// Create a copy of ReturnRequestItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReturnRequestItemImplCopyWith<_$ReturnRequestItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
