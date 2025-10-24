import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_status.freezed.dart';
part 'order_status.g.dart';

@freezed
class OrderStatusEntity with _$OrderStatusEntity {
  const OrderStatusEntity._();

  const factory OrderStatusEntity({
    @Default('') String title,
    @Default('') String code,
    @Default(0) int id,
  }) = _OrderStatusEntity;

  factory OrderStatusEntity.fromJson(Map<String, dynamic> json) => _$OrderStatusEntityFromJson(json);
}
