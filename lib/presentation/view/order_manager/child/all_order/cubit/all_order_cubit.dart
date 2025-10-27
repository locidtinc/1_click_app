import 'dart:async';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/domain/usecase/order_get_list_use_case.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/enum/status_order.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/delay_callback.dart';

import '../../../../../../data/mapper/order_detail_to_preview_mapper.dart';
import '../../../../../../domain/usecase/order_draf_use_case.dart';
import 'all_order_state.dart';

@injectable
class AllOrderCubit extends Cubit<AllOrderState> {
  AllOrderCubit(
    this._orderGetListUseCase,
    this._orderDrafUseCase,
    this._orderDetailToPreviewMapper,
  ) : super(const AllOrderState());

  final OrderGetListUseCase _orderGetListUseCase;
  final OrderDrafUseCase _orderDrafUseCase;
  final OrderDetailToPreviewMapper _orderDetailToPreviewMapper;

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

  void isOnlineChange(bool? value) {
    const filterButtonOnline = [
      FilterButtonItem('Tất cả', StatusOrder.all),
      FilterButtonItem('Chờ xác nhận', StatusOrder.pending),
      FilterButtonItem('Thành công', StatusOrder.complete),
      FilterButtonItem('Thất bại', StatusOrder.deny),
    ];
    const filterButtonNotOnline = [
      FilterButtonItem('Tất cả', StatusOrder.all),
      FilterButtonItem('Dự thảo', StatusOrder.draft),
      FilterButtonItem('Thành công', StatusOrder.complete),
    ];
    late List<FilterButtonItem> filterButton;
    switch (value) {
      case true:
        filterButton = filterButtonOnline;
        break;
      case false:
        filterButton = filterButtonNotOnline;
        break;
      default:
        filterButton = filterButtonNotOnline + filterButtonOnline;
    }
    emit(
      state.copyWith(
        isOnline: value,
        listFilter: filterButton.toSet().toList(),
      ),
    );
  }
}

extension HandleApi on AllOrderCubit {
  Future<List<OrderPreviewEntity>> getListOrder(int page) async {
    switch (state.selectFilter.value) {
      case StatusOrder.draft:
        final list =
            _orderDrafUseCase.buildUseCase(OrderDrafInput(TypeOrder.cHTH));
        return _orderDetailToPreviewMapper.mapToListEntity(list.listOrder);
      default:
        final input = OrderGetListInput(
          page: page,
          limit: state.limit,
          searchKey: state.searchKey,
          status: int.tryParse((state.selectFilter.value as StatusOrder).id),
          isOnline: state.isOnline,
        );
        final res = await _orderGetListUseCase.execute(input);
        return res.response.data ?? [];
    }
  }
}
