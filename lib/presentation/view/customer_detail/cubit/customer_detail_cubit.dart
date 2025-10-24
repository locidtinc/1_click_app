import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/order_count.dart';

import '../../../../domain/usecase/order_count_use_case.dart';
import 'customer_detail_state.dart';

@injectable
class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  CustomerDetailCubit(this._orderCountUseCase)
      : super(const CustomerDetailState());

  final OrderCountUseCase _orderCountUseCase;

  void initDataCustomer(CustomerEntity data) {
    emit(state.copyWith(customerEntity: data));
    getOrderCount();
  }

  Color getColor(int id) {
    switch (id) {
      case 1:
        return blackColor;
      case 2:
        return yellow_1;
      case 3:
        return mainColor;
      case 4:
        return green_1;
      default:
        return blackColor;
    }
  }
}

extension ApiEvent on CustomerDetailCubit {
  Future<void> getOrderCount() async {
    final input = OrderCountInput(
      customer: state.customerEntity?.id,
    );

    final listOrderCount = List<OrderCountEntity>.from(state.listOrderCount);
    final res = await _orderCountUseCase.execute(input);

    for (final item in (res.response.data ?? [])) {
      final index = listOrderCount.indexWhere((e) => e.id == item.id);
      listOrderCount[index] = listOrderCount[index].copyWith(count: item.count);
    }

    emit(state.copyWith(listOrderCount: listOrderCount));
  }
}
