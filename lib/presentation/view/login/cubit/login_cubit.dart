// ignore: depend_on_referenced_packages
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../../domain/usecase/login_use_case.dart';
import '../../../routers/router.gr.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this._loginUseCase,
  ) : super(LoginState());

  final LoginUseCase _loginUseCase;

  void init() {
    final shared = AppSharedPreference.instance;
    final rememberPassword =
        shared.getValue(PrefKeys.rememberPassword) as bool?;
    if (rememberPassword == false) {
      return;
    }
    final username = shared.getValue(PrefKeys.username) as String?;
    final password = shared.getValue(PrefKeys.password) as String?;
    emit(
      state.copyWith(
        email: username ?? '',
        password: password ?? '',
        rememberPassword: rememberPassword ?? false,
      ),
    );
  }

  void changeCheckbox() {
    emit(state.copyWith(rememberPassword: !state.rememberPassword));
  }

  void toggleShowPassword() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void changePhone(String value) {
    emit(state.copyWith(email: value));
  }

  void changePassword(String value) {
    emit(state.copyWith(password: value));
  }

  void changeRememberPassword(bool value) {
    emit(state.copyWith(rememberPassword: value));
  }

  setData({
    required bool isRemember,
    required String email,
    required String password,
  }) {
    emit(
      state.copyWith(
        email: email,
        password: password,
        rememberPassword: isRemember,
      ),
    );
  }

  void login(BuildContext context) async {
    final shared = AppSharedPreference.instance;
    shared.setValue(PrefKeys.rememberPassword, state.rememberPassword);
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang xác thực, vui lòng đợi',
    );
    final res = await _loginUseCase.execute(
      LoginInput(
        email: state.email,
        password: state.password,
      ),
    );
    Navigator.of(context).pop();
    if (res.statusLogin != StatusLogin.success) {
      DialogUtils.showErrorDialog(
        context,
        content: 'Sai số điện thoại hoặc mật khẩu',
      );
    } else {
      if (!state.rememberPassword) {
        emit(state.copyWith(email: '', password: ''));
        shared.setValue(PrefKeys.username, '');
        shared.setValue(PrefKeys.password, '');
      } else {
        shared.setValue(PrefKeys.username, state.email);
        shared.setValue(PrefKeys.password, state.password);
      }
      context.router.replace(HomeRoute());
    }
  }
}
