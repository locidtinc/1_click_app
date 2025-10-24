import 'package:base_mykiot/base_lhe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/order_preview.dart';

import '../../../../shared/constants/enum/status_order_system.dart';

part 'order_import_state.freezed.dart';

@freezed
class OrderImportState with _$OrderImportState {
  const factory OrderImportState({
    @Default(<OrderPreviewEntity>[]) List<OrderPreviewEntity> listOrder,
    @Default('') String searchKey,
    @Default(10) int limit,
    @Default(<FilterButtonItem>[
      FilterButtonItem('Tất cả', StatusOrderSystem.all),
      FilterButtonItem('Dự thảo', StatusOrderSystem.draft),
      FilterButtonItem('Chờ xác nhận', StatusOrderSystem.pending),
      // FilterButtonItem('Chờ NPT xác nhận', StatusOrderSystem.pendingNPT),
      FilterButtonItem('Đã xác nhận', StatusOrderSystem.accept),
      FilterButtonItem('Hoàn thành', StatusOrderSystem.complete),
      FilterButtonItem('Từ chối', StatusOrderSystem.deny),
      FilterButtonItem('Từ chối nhận', StatusOrderSystem.denyImport),
      // FilterButtonItem('NPT từ chối', StatusOrderSystem.denyNPT),
    ])
    List<FilterButtonItem> listFilter,
    @Default(FilterButtonItem('Tất cả', StatusOrderSystem.all))
    FilterButtonItem selectFilter,
  }) = _OrderImportState;
}
