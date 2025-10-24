import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';

import '../../shared/constants/pref_keys.dart';
import '../repository/login_repository.dart';
import 'base/future/base_future_use_case.dart';
import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class LoginUseCase extends BaseFutureUseCase<LoginInput, LoginOutput> {
  LoginUseCase(this._loginRepository);

  final LoginRepository _loginRepository;

  @protected
  @override
  Future<LoginOutput> buildUseCase(LoginInput input) async {
    // if (!ValidationUtils.isValidEmail(input.email)) {
    //   return const LoginOutput(statusLogin: StatusLogin.INVALID_EMAIL);
    // }

    // if (!ValidationUtils.isValidPassword(input.password)) {
    //   return const LoginOutput(statusLogin: StatusLogin.INVALID_PASSWORD);
    // }

    final res = await _loginRepository.login(input.email, input.password);

    if (res['code'] == 200) {
      AppSharedPreference.instance
          .setValue(PrefKeys.token, res['data']['token']);
      AppSharedPreference.instance
          .setValue(PrefKeys.user, res['data']['user']['id']);
      AppSharedPreference.instance
          .setValue(PrefKeys.account, res['data']['user']['full_name']);
      return const LoginOutput(statusLogin: StatusLogin.success);
    }
    return const LoginOutput(statusLogin: StatusLogin.invalidEmail);
  }
}

class LoginInput extends BaseInput {
  final String email;
  final String password;

  const LoginInput({
    required this.email,
    required this.password,
  });
}

class LoginOutput extends BaseOutput {
  final StatusLogin statusLogin;

  const LoginOutput({
    required this.statusLogin,
  });
}

enum StatusLogin {
  success,
  invalidEmail,
  invalidPassword,
}
