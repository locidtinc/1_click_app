import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/change_password_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/change_password/cubit/change_password_state.dart';
import 'package:one_click/shared/mixins/validate_mixin.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState>
    with ValidateMixin {
  ChangePasswordCubit(this._changePasswordUseCase)
      : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePasswordUseCase;

  final keyForm = GlobalKey<FormState>();

  void changeCurrentPassword(String? value) {
    emit(state.copyWith(currentPassword: value));
  }

  void changeConfirmPassword(String? value) {
    emit(state.copyWith(confirmPassword: value));
  }

  void changeNewPassword(String? value) {
    emit(state.copyWith(newPassword: value));
  }

  void toggleShowPassword() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void onTapChangePassword(BuildContext context) async {
    if (!keyForm.currentState!.validate()) return;
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang cập nhật mật khẩu mới, vui lòng đợi!',
    );
    final res = await _changePasswordUseCase
        .execute(ChangePasswordInput(state.currentPassword, state.newPassword));
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (res.code == 200 && context.mounted) {
      DialogCustoms.showSuccessDialog(
        context,
        content: const Text(
          'Thay đổi mật khẩu thành công, vui lòng đăng nhập lại!',
          style: p6,
        ),
        click: () {
          Navigator.of(context).pop();
          context.router
              .pushAndPopUntil(const LoginV2Route(), predicate: (_) => false);
        },
      );
    } else {
      DialogCustoms.showErrorDialog(
        context,
        content: Text(
          res.message ?? 'Mật khẩu hiện tại không đúng!',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập xác nhận mật khẩu mới!';
    }
    if (value != state.newPassword) {
      return 'Xác nhận mật khẩu không khớp';
    }
    return null;
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu hiện tại!';
    }
    return null;
  }
}
