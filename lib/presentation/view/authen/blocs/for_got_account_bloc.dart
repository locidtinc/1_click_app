import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../domain/usecase/forgot_password_use_case.dart';
import '../../../config/bloc/bloc_status.dart';
import '../../../config/bloc/init_state.dart';
import '../../../routers/router.gr.dart';
import '../repos/account_repo.dart';

class ForgotAccountBloc extends Cubit<CubitState> {
  ForgotAccountBloc() : super(CubitState());

  final _repo = AccountRepo();

  resetPass({
    required String phone,
    required String newPass,
    required String newPassConfirm,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.resetPass(
      phone: phone,
      newPass: newPass,
      newPassConfirm: newPassConfirm,
    );
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Cập nhật mật khẩu thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Lỗi. Cập nhật mật khẩu không thành công',
        ),
      );
    }
  }
}
