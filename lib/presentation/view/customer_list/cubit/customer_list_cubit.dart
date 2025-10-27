import 'dart:async';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/usecase/customer_get_list_use_case.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/delay_callback.dart';

import '../../../../domain/usecase/customer_delete_use_case.dart';
import 'customer_list_state.dart';

@injectable
class CustomerListCubit extends Cubit<CustomerListState> {
  CustomerListCubit(
    this._customerGetListUseCase,
    this._customerDeleteUseCase,
  ) : super(const CustomerListState());

  final CustomerGetListUseCase _customerGetListUseCase;
  final CustomerDeleteUseCase _customerDeleteUseCase;

  final InfiniteListController<CustomerEntity> infiniteListController =
      InfiniteListController<CustomerEntity>.init();
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
}

extension ApiHandle on CustomerListCubit {
  Future<List<CustomerEntity>> getCustomer(int page) async {
    final input = CustomerGetListInput(state.searchKey, state.limit, page + 1);
    final res = await _customerGetListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<void> deleteCustomer(BuildContext context, int id) async {
    final input = CustomerDeleteInput(id);
    final res = await _customerDeleteUseCase.execute(input);
    if (res.response.code == 200 && context.mounted) {
      infiniteListController.onRefresh();
      DialogUtils.showSuccessDialog(
        context,
        content: 'Xóa khách hàng thành công',
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
    } else {
      DialogUtils.showSuccessDialog(
        context,
        content: res.response.message ?? 'Xóa khách hàng thất bại',
      );
    }
  }
}
