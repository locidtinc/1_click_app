import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_click/data/models/payload/signup_payload.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/config/bloc/cubit_state.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/authen/repos/auth_repo.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../config/bloc/init_state.dart';
import '../models/confirm_account_payload.dart';

class ConfirmAccountBloc extends Cubit<CubitState> {
  ConfirmAccountBloc() : super(CubitState());
  final _repo = AuthRepo();

  Timer? time;

  showVideo() {
    time = null;
    emit(
      state.copyWith(
        total: kDebugMode ? 10 : 45,
      ),
    );
    time = Timer.periodic(1.seconds, (timer) {
      print(timer.tick);
      if (state.total > 0) {
        final total = state.total - 1;
        emit(
          state.copyWith(
            total: total,
            isFirst: true,
            status: BlocStatus.success,
          ),
        );
      } else {
        time?.cancel();
      }
    });
  }

  skipVideo() {
    time?.cancel();
    time = null;
    emit(
      state.copyWith(
        total: 0,
        isFirst: true,
        status: BlocStatus.success,
      ),
    );
  }

  Future<void> confirm(
    BuildContext context,
    ConfirmAccountPayload payload,
  ) async {
    print(jsonEncode(payload.toJson()));
    DialogUtils.showLoadingDialog(context, content: 'Đang tải...');
    final res = await _repo.confirmAccount(payload);
    if (!context.mounted) return;
    context.pop();
    if (res.code == 200) {
      context.router.replaceAll([const LoginV2Route()]);
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: res.message ?? 'Lỗi. Xác nhận tài khoản không thành công',
      );
    }
  }
}
