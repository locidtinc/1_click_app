import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/forgot_password_use_case.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/forgot_password/cubit/forgot_password_state.dart';
import 'package:one_click/shared/mixins/validate_mixin.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState>
    with ValidateMixin {
  ForgotPasswordCubit(this._forgotPasswordUseCase)
      : super(const ForgotPasswordState());

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  final formKey = GlobalKey<FormState>();

  void onChangePhone(String value) {
    emit(state.copyWith(phone: value));
  }

  void onTapBack() {
    emit(state.copyWith(isLinkedEmail: true));
  }

  void onTapCallCentre() {}

  void onTapContinue(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      DialogUtils.showLoadingDialog(
        context,
        content: 'Đang xác thực, vui lòng đợi',
      );
      final res = await _forgotPasswordUseCase
          .execute(ForgotPasswordInput(state.phone));
      Navigator.of(context).pop();
      if (res.code == 200 && context.mounted) {
        context.router.replace(
          VerifyPasswordRoute(sessionKey: res.sessionKey, email: res.email),
        );
        return;
      }
      if (res.code == 404 && context.mounted) {
        emit(state.copyWith(isLinkedEmail: false));
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: res.message ?? 'Người dùng không tồn tại trong hệ thông!',
      );
    }
  }
}
