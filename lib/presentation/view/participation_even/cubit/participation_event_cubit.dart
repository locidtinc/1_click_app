import 'dart:async';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/participation_even_model.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/delay_callback.dart';

import '../../../../domain/repository/participation_repository/participation_repository.dart';
import 'participation_event_state.dart';

@injectable
class ParticipationEventCubit extends Cubit<CustomerListState> {
  ParticipationEventCubit() : super(const CustomerListState());

  final InfiniteListController<ParticipationEvenModel> infiniteListController =
      InfiniteListController<ParticipationEvenModel>.init();
  final ScrollController scrollController = ScrollController();
  final _repo = ParticipationRepository();
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

extension ApiHandle on ParticipationEventCubit {
  Future<List<ParticipationEvenModel>> getListParticipation(int page) async {
    final res = await _repo.getListParticipation();
    return res.data ?? [];
  }

  // Future<void> deleteCustomer(BuildContext context, int id) async {
  //   final input = CustomerDeleteInput(id);
  //   final res = await _customerDeleteUseCase.execute(input);
  //   if (res.response.code == 200 && context.mounted) {
  //     infiniteListController.onRefresh();
  //     DialogUtils.showSuccessDialog(
  //       context,
  //       content: 'Xóa khách hàng thành công',
  //     );
  //     Future.delayed(const Duration(seconds: 3), () {
  //       if (context.mounted) {
  //         Navigator.of(context).pop();
  //       }
  //     });
  //   } else {
  //     DialogUtils.showSuccessDialog(
  //       context,
  //       content: res.response.message ?? 'Xóa khách hàng thất bại',
  //     );
  //   }
  // }
}
