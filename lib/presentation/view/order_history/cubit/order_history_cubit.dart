import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/domain/usecase/order_get_list_use_case.dart';

import 'order_history_state.dart';

@injectable
class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit(this._orderGetListUseCase)
      : super(const OrderHistoryState());

  final OrderGetListUseCase _orderGetListUseCase;

  final InfiniteListController<OrderPreviewEntity> infiniteListController =
      InfiniteListController<OrderPreviewEntity>.init();
  final ScrollController scrollController = ScrollController();
}

extension ApiEvent on OrderHistoryCubit {
  Future<List<OrderPreviewEntity>> getList({
    required int page,
    required int status,
    required int customer,
  }) async {
    final input = OrderGetListInput(
      page: page + 1,
      limit: state.limit,
      searchKey: '',
      status: status,
      customer: customer,
    );
    final res = await _orderGetListUseCase.execute(input);
    return res.response.data ?? <OrderPreviewEntity>[];
  }
}
