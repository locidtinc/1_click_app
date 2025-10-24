import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/inventory_model_v2.dart';
import 'package:one_click/presentation/view/ware_house/warehourse_list_page_v2.dart';
part 'warehouse_state.freezed.dart';

@freezed
class WarehouseState with _$WarehouseState {
  const factory WarehouseState({
    @Default(0) int tabSelected,
    @Default(0) int timeFilterIndex,
    @Default('') String search,
    @Default(10) int limit,
    @Default(0) int total,
    @Default([]) List<InventoryModelV2> inventories,
    // @Default([]) List<WarehouseModel> listWareHouse,
    FilterButtonModel? filter,
    // WarehouseModel? warehouseSelect,
    @Default(false) bool isLoading,
  }) = _WarehouseState;
}
