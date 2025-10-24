import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/order_status.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';

import '../../shared/constants/enum/status_payment_order.dart';

part 'order_preview.freezed.dart';
part 'order_preview.g.dart';

@freezed
class OrderPreviewEntity with _$OrderPreviewEntity {
  const OrderPreviewEntity._();

  const factory OrderPreviewEntity({
    @Default(0) int id,
    @Default('') String code,
    @Default(OrderStatusEntity()) OrderStatusEntity status,
    @Default(null) bool? isOnline,
    @Default('') String createdAt,
    @Default(0) int total,
    @Default(0) int discount,
    @Default(null) TypeOrder? typeOrder,
    @Default(null) CustomerEntity? customerData,
    @Default(StatusPayment.unpaid) StatusPayment statusPayment,
  }) = _OrderPreviewEntity;

  factory OrderPreviewEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderPreviewEntityFromJson(json);
}
