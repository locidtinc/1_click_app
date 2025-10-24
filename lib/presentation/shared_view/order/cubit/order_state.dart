import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState({
    @Default(1) int quantity,
    @Default(0) int total,
    @Default(0) int totalPriceVariant,
  }) = _OrderState;
}
