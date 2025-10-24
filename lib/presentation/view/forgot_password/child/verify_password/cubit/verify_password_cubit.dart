import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/reset_otp_use_case.dart';
import 'package:one_click/domain/usecase/verify_password_use_case.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/forgot_password/child/verify_password/cubit/verify_password_state.dart';

@injectable
class VerifyPasswordCubit extends Cubit<VerifyPasswordState> {
  VerifyPasswordCubit(this._verifyPasswordUseCase, this._resetOtpUseCase)
      : super(const VerifyPasswordState());

  final VerifyPasswordUseCase _verifyPasswordUseCase;
  final ResetOtpUseCase _resetOtpUseCase;

  final formKey = GlobalKey<FormState>();

  late Timer _timer;

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }

  void onChangePin(String value) {
    emit(state.copyWith(pinCode: value));
    if (value.length == 6) {
      emit(state.copyWith(enableButton: true));
    } else {
      emit(state.copyWith(enableButton: false));
    }
  }

  void startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final time = state.time - 1;
      if (time == 0) {
        _timer.cancel();
      }
      emit(state.copyWith(time: time));
    });
  }

  void reSendOtp(BuildContext context, String sessionKey) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang xác thực, vui lòng đợi',
    );
    final res = await _resetOtpUseCase.execute(sessionKey);
    Navigator.of(context).pop();
    if (res.code == 200 && context.mounted) {
      emit(state.copyWith(time: 90));
      startCountDown();
      return;
    }
  }

  void verifyPassword(BuildContext context, String sessionKey) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang xác thực, vui lòng đợi',
    );
    final res = await _verifyPasswordUseCase
        .execute(VerifyPasswordInput(state.pinCode, sessionKey));
    Navigator.of(context).pop();
    if (res.code == 200 && context.mounted) {
      context.router.replace(
        ResetPasswordRoute(
          sessionKey: sessionKey,
          otp: state.pinCode,
        ),
      );
      return;
    }
    emit(state.copyWith(errorText: res.message));
  }

  String hideEmail(String email) {
    final username = email.split('@');
    final emailCharacter = email.replaceRange(
      2,
      username[0].length,
      '*' * (username[0].length - 2),
    );
    return emailCharacter;
  }
}
