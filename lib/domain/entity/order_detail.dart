import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/customer.dart';

import '../../shared/constants/enum/status_payment_order.dart';
import 'order_status.dart';
import 'qr_code_payment.dart';

part 'order_detail.freezed.dart';
part 'order_detail.g.dart';

@freezed
class OrderDetailEntity with _$OrderDetailEntity {
  const OrderDetailEntity._();

  const factory OrderDetailEntity({
    @Required() int? id,
    @Default('') String title,
    @Default('') String note,
    @Default('') String noteCancel,
    @Required() String? code,
    @Default(0) int total,
    @Default(0) int discount,
    @Required() OrderStatusEntity? orderStatus,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @Required() String? createAt,
    @JsonKey(name: 'customer_data') @Default(null) CustomerEntity? customerData,
    @Required() ShopDataEnity? shopData,
    @Default(<OrderItemEntity>[]) List<OrderItemEntity> variants,
    @Default(false) bool isQRPayment,
    @Default(StatusPayment.unpaid) StatusPayment statusPayment,
    @Default(null) QrCodePayment? qrCodePayment,
  }) = _OrderDetailEntity;

  factory OrderDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailEntityFromJson(json);
}

@freezed
class ShopDataEnity with _$ShopDataEnity {
  const ShopDataEnity._();

  const factory ShopDataEnity({
    @Required() String? name,
    @Required() String? phone,
    @Required() String? address,
  }) = _ShopDataEnity;

  factory ShopDataEnity.fromJson(Map<String, dynamic> json) =>
      _$ShopDataEnityFromJson(json);
}

@freezed
class OrderItemEntity with _$OrderItemEntity {
  const OrderItemEntity._();

  const factory OrderItemEntity({
    @Default(null) int? id,
    @Required() String? name,
    @Required() int? amount,
    @Required() int? quantityInStock,
    @Required() int? quantity,
    @Required() int? priceSell,
    @Required() String? image,
    @Required() String? models,
    @Required() String? unitSell,
  }) = _OrderItemEntity;

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderItemEntityFromJson(json);
}
