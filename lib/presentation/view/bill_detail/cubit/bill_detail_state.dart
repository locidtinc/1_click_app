import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';

part 'bill_detail_state.freezed.dart';

@freezed
class BillDetailState with _$BillDetailState {
  const factory BillDetailState({
    @Default(TypeOrder.cHTH) TypeOrder typeOrder,
    @Default(null) OrderDetailEntity? orderDetailEntity,
  }) = _BillDetailState;
}
