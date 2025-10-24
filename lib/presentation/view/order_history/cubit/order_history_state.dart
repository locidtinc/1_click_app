import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_history_state.freezed.dart';

@freezed
class OrderHistoryState with _$OrderHistoryState {
  const factory OrderHistoryState({
    @Default(10) int limit,
  }) = _OrderHistoryState;
}
