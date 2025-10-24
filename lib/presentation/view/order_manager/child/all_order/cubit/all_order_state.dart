import 'package:base_mykiot/base_lhe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/shared/constants/enum/status_order.dart';

part 'all_order_state.freezed.dart';

@freezed
class AllOrderState with _$AllOrderState {
  const factory AllOrderState({
    @Default(<FilterButtonItem>[]) List<FilterButtonItem> listFilter,
    @Default(FilterButtonItem('Tất cả', StatusOrder.all))
    FilterButtonItem selectFilter,
    @Default([]) List list,
    @Default(10) int limit,
    @Default(null) bool? isOnline,
    @Default('') String searchKey,
  }) = _AllOrderState;
}
