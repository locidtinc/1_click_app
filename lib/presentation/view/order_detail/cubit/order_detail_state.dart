import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
part 'order_detail_state.freezed.dart';

@freezed
class OrderDetailState with _$OrderDetailState {
  const factory OrderDetailState({
    @Default(null) TypeOrder? typeOrder,
    @Default(true) bool isLoading,
    @Default(null) int? idReasonDeny,
    @Default(null) dynamic data,
    @Default(null) OrderDetailEntity? orderDetail,
    @Default(false) bool isDrafOrder,
    @Default('') String titleReason,
  }) = _OrderDetailState;
}
