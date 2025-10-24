import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/reset_password_use_case.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/forgot_password/child/reset_password/cubit/reset_password_state.dart';
import 'package:one_click/shared/mixins/validate_mixin.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> with ValidateMixin {
  ResetPasswordCubit(this._resetPasswordUseCase)
      : super(const ResetPasswordState());

  final ResetPasswordUseCase _resetPasswordUseCase;

  final formKey = GlobalKey<FormState>();

  void toggleShowPassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  void onChangeNewPassword(String? value) {
    if (value == null) {
      return;
    }
    emit(state.copyWith(newPassword: value, enableButton: true));
    _enableButton();
  }

  void onChangeConfirmPassword(String? value) {
    if (value == null) {
      return;
    }
    emit(state.copyWith(confirmPassword: value, enableButton: true));
    _enableButton();
  }

  String? validateConfirmPassword(String? value) {
    if (value != null && value != state.newPassword) {
      return 'Mật khẩu nhập lại không khớp';
    }
    return null;
  }

  void onTapFinish(BuildContext context, String sessionKey, String otp) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang xác thực, vui lòng đợi',
    );
    final res = await _resetPasswordUseCase.execute(
      ResetPasswordInput(
        sessionKey,
        otp,
        state.newPassword,
        state.confirmPassword,
      ),
    );
    Navigator.of(context).pop();
    if (res.code == 200 && context.mounted) {
      context.router.replace(const LoginV2Route());
      return;
    }
    DialogUtils.showErrorDialog(
      context,
      content: res.message ?? 'Thay đổi mật khẩu không thành công!',
    );
  }

  void _enableButton() {
    if (state.newPassword.isNotEmpty && state.confirmPassword.isNotEmpty) {
      emit(state.copyWith(enableButton: true));
    } else {
      emit(state.copyWith(enableButton: false));
    }
  }
}
