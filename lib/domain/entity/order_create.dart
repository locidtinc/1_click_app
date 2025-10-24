import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_create.freezed.dart';
part 'order_create.g.dart';

@freezed
class OrderCreateEntity with _$OrderCreateEntity {
  const OrderCreateEntity._();

  const factory OrderCreateEntity({
    @JsonKey(name: 'order') @Default(OrderInfoCreate()) OrderInfoCreate order,
    @JsonKey(name: 'orderitem')
    @Default(<Orderitem>[])
    List<Orderitem> orderitem,
  }) = _OrderCreateEntity;

  factory OrderCreateEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderCreateEntityFromJson(json);
}

@freezed
class OrderInfoCreate with _$OrderInfoCreate {
  const OrderInfoCreate._();

  const factory OrderInfoCreate({
    @Default('Đơn hàng') String title,
    @Default('0') String discount,
    @Default(null) int? customer,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @Default('') String note,
  }) = _OrderInfoCreate;

  factory OrderInfoCreate.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoCreateFromJson(json);
}

@freezed
class Orderitem with _$Orderitem {
  const Orderitem._();

  const factory Orderitem({
    @Default(0) int quantity,
    @Default(0) int price,
    @Default(0) int discount,
    @Required() int? variant,
    int? promotion,
  }) = _Orderitem;

  factory Orderitem.fromJson(Map<String, dynamic> json) =>
      _$OrderitemFromJson(json);
}
