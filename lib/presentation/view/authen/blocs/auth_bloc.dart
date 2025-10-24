import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import '../../../../domain/usecase/login_use_case.dart';
import '../../../config/bloc/init_state.dart';
import '../repos/auth_repo.dart';

class AuthBloc extends Cubit<CubitState> {
  AuthBloc() : super(CubitState());

  final _repo = AuthRepo();
  final _loginUseCase = getIt<LoginUseCase>();

  bool _isActive = false;
  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void check(BuildContext context, {required String phone}) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tải...',
    );
    final res = await _repo.checkAccount(phone);
    Navigator.pop(context);
    isActive = res.data?.isActive ?? false;
    final bool isErr = res.code != 200;
    if (res.data == null && !isErr) {
      context.pushRoute(SignUpV2Route(phone: phone));
    } else if (!_isActive && !isErr) {
      context.pushRoute(OtpRoute(phone: phone));
    } else if (isErr) {
      DialogUtils.showErrorDialog(
        context,
        content: res.message ?? 'Lỗi. Không xác định',
      );
    }
  }
}
