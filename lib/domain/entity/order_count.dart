import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_count.freezed.dart';

@freezed
class OrderCountEntity with _$OrderCountEntity {
  const OrderCountEntity._();
  const factory OrderCountEntity({
    @Required() int? id,
    @Required() String? type,
    @Required() int? count,
  }) = _OrderCountEntity;
}
