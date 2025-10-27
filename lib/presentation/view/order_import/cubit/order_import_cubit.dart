import 'dart:async';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/shared/constants/enum/status_order_system.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/delay_callback.dart';

import '../../../../domain/usecase/order_import_use_case.dart';
import 'order_import_state.dart';

@injectable
class OrderImportCubit extends Cubit<OrderImportState> {
  OrderImportCubit(this._orderImportUseCase) : super(const OrderImportState());

  final OrderImportUseCase _orderImportUseCase;

  final InfiniteListController<OrderPreviewEntity> infiniteListController =
      InfiniteListController<OrderPreviewEntity>.init();
  final ScrollController scrollController = ScrollController();

  final delay = DelayCallBack(delay: 1.seconds);

  @override
  Future<void> close() {
    infiniteListController.dispose();
    scrollController.dispose();
    return super.close();
  }

  void searchKeyChange(String value) {
    emit(state.copyWith(searchKey: value));

    delay.debounce(() => infiniteListController.onRefresh());
  }

  void selectFilterButton(FilterButtonItem value) {
    emit(state.copyWith(selectFilter: value));
    infiniteListController.onRefresh();
  }
}

extension ApiEvent on OrderImportCubit {
  Future<List<OrderPreviewEntity>> getList(int page) async {
    final input = OrderImportInput(
      limit: state.limit,
      page: page + 1,
      searchKey: state.searchKey,
      status: int.tryParse((state.selectFilter.value as StatusOrderSystem).id),
    );
    final res = await _orderImportUseCase.execute(input);
    return res.response.data ?? [];
  }
}
