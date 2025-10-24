import 'package:base_mykiot/base_lhe.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/noti_model.dart';
import 'package:one_click/domain/entity/noti.dart';
import 'package:one_click/domain/usecase/noti_count_use_case.dart';
import 'package:one_click/domain/usecase/noti_get_use_case.dart';
import 'package:one_click/domain/usecase/noti_seen_all_use_case.dart';
import 'package:one_click/domain/usecase/noti_seen_use_case.dart';

import 'noti_state.dart';

@injectable
class NotiCubit extends Cubit<NotiState> {
  NotiCubit(
    this._notiGetUseCase,
    this._notiCountUseCase,
    this._notiSeenUseCase,
    this._notiSeenAllUseCase,
  ) : super(const NotiState());

  final NotiGetUseCase _notiGetUseCase;
  final NotiCountUseCase _notiCountUseCase;
  final NotiSeenUseCase _notiSeenUseCase;
  final NotiSeenAllUseCase _notiSeenAllUseCase;
  final InfiniteListController<NotiEntity> infiniteListControllerNew =
      InfiniteListController<NotiEntity>.init();
  final ScrollController scrollControllerNew = ScrollController();
  final InfiniteListController<NotiEntity> infiniteListControllerOld =
      InfiniteListController<NotiEntity>.init();
  final ScrollController scrollControllerOld = ScrollController();
  int _page = 1;

  Future<void> getCountAllNoti() async {
    final input = NotiCountInput();
    final res = await _notiCountUseCase.execute(input);
    emit(state.copyWith(totalAllNoti: res.countTotal));
  }

  Future<void> getListNew(
    int page, {
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
    }
    final input = NotiGetInput(lastItem: null, page: page);
    final res = await _notiGetUseCase.execute(input);
    if ((res.response.data ?? []).length == 10) {
      emit(state.copyWith(lastItem: res.lastItem));
    }
    emit(state.copyWith(listNoti: res.response.data?[0]));
  }

  Future<List<NotiEntity>> getListOld(int page) async {
    final input = NotiGetInput(lastItem: state.lastItem, page: page + 1);
    final res = await _notiGetUseCase.execute(input);
    // if (page != 0 && (res.response.data ?? []).length == 10) {
    emit(state.copyWith(lastItem: res.lastItem ?? state.lastItem));
    // }
    return res.response.data?.toList() ?? [];
  }

  Future<void> updateNoti(NotiModel noti) async {
    if ((noti.isReaded ?? false)) return;
    final input = NotiSeenInput(noti: noti);
    _notiSeenUseCase.execute(input);
    // infiniteListControllerNew.onRefresh();
    getListNew(0);
  }

  // Future<void> updateAllNoti() async {
  //   final input = NotiSeenAllInput();
  //   await _notiSeenAllUseCase.execute(input);
  //   infiniteListControllerNew.onRefresh();
  // }

  void filterOnChange(TypeNoti value) {
    emit(state.copyWith(filterSelect: value));
  }
}
