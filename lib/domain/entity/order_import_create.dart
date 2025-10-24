import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_create.dart';
part 'order_import_create.freezed.dart';
part 'order_import_create.g.dart';

@freezed
class OrderImportCreateEntity with _$OrderImportCreateEntity {
  const OrderImportCreateEntity._();

  const factory OrderImportCreateEntity({
    @JsonKey(name: 'order')
    @Default(OrderImportInfoCreate())
    OrderImportInfoCreate order,
    @JsonKey(name: 'orderitem')
    @Default(<Orderitem>[])
    List<Orderitem> orderitem,
  }) = _OrderImportCreateEntity;

  factory OrderImportCreateEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderImportCreateEntityFromJson(json);
}

@freezed
class OrderImportInfoCreate with _$OrderImportInfoCreate {
  const OrderImportInfoCreate._();

  const factory OrderImportInfoCreate({
    @Default('Đơn hàng') String title,
    @Default('0') String discount,
    @Default('0') String total,
    @Default('') String note,
    @JsonKey(name: 'account_sell') @Default(1) int accountSell,
    @JsonKey(name: 'is_online') @Default(true) bool isOnline,
  }) = _OrderImportInfoCreate;

  factory OrderImportInfoCreate.fromJson(Map<String, dynamic> json) =>
      _$OrderImportInfoCreateFromJson(json);
}
