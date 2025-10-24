import 'dart:convert';

import 'package:base_mykiot/base_lhe.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/entity/warehouse_entity.dart';
import 'package:one_click/domain/usecase/warehouse_use_case.dart';
import 'package:one_click/presentation/view/ware_house/cubit/warehouse_state.dart';
import 'package:one_click/presentation/view/ware_house/warehourse_list_page_v2.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/ext/index.dart';

@injectable
class WarehouseCubitV2 extends Cubit<WarehouseState> {
  WarehouseCubitV2(
    this._useCase,
  ) : super(const WarehouseState());

  final WarehouseUseCase _useCase;
  // final GetListWareHouseUseCase _listWareHouseUseCase;
  // final InfiniteListController<TicketEntity> entityILC =
  //     InfiniteListController<TicketEntity>.init();
  final InfiniteListController<WarehouseEntity> warehouseILC =
      InfiniteListController<WarehouseEntity>.init();
  final ScrollController scrollController = ScrollController();

  // List<WarehouseEntity> _warehouses = [];
  // final all = const WarehouseModel(title: 'Tất cả');
  int page = 0;
  // final DelayCallBack delay = DelayCallBack(delay: 500.milliseconds);
  // List<DropdownMenuItem<WarehouseEntity>> get warehousesSelected {
  //   return _warehouses
  //       .map(
  //         (e) => DropdownMenuItem<WarehouseEntity>(
  //           value: e,
  //           child: Text(e.name),
  //         ),
  //       )
  //       .toList();
  // }

  // void getListWareHouse() async {
  //   final input = ListWarehouseInput(
  //     expired: state.filter?.value,
  //     workspace: getCompanyId,
  //   );
  //   final res = await _listWareHouseUseCase.getListV2(input);
  //   emit(state.copyWith(listWareHouse: [all] + res));
  // }

  Future<void> getListInventory({bool isMore = false}) async {
    if (isMore) {
      page = page + 1;
    } else {
      page = 0;
      emit(state.copyWith(inventories: [], isLoading: true));
    }
    final idWarehouse =
        AppSharedPreference.instance.getValue(PrefKeys.warehouseId);
    final raw = AppSharedPreference.instance.getValue(PrefKeys.store);
    final idShop = StoreEntity.fromJson(jsonDecode(raw.toString()));
    final input = InventoryInputV2(
      search: state.search,
      id: int.parse(idWarehouse.toString()),
      limit: state.limit,
      page: page,
      expired: state.filter?.value,
      workspace: idShop.storeId,
    );
    final res = await _useCase.getListInventory(input);
    emit(
      state.copyWith(
        inventories: (state.inventories) + (res.data ?? []),
        isLoading: false,
      ),
    );
  }

  // void searchChange(String value) {
  //   delay.debounce(
  //     () {
  //       emit(state.copyWith(search: value));
  //       getListInventory();
  //     },
  //   );
  // }

  // void warehouseChange(WarehouseModel? value) {
  //   emit(state.copyWith(warehouseSelect: value));
  //   getListInventory();
  // }

  void changeTimeFilter(FilterButtonModel value) {
    emit(state.copyWith(filter: value));
    getListInventory();
    // getListWareHouse();
  }

  void initData(FilterButtonModel value) {
    emit(state.copyWith(filter: value));
  }
}
