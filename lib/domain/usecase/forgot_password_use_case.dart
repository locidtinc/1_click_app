import 'package:injectable/injectable.dart';
import 'package:one_click/domain/repository/forgot_password_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class ForgotPasswordUseCase
    extends BaseFutureUseCase<ForgotPasswordInput, ForgotPasswordOutput> {
  ForgotPasswordUseCase(this._repository);

  final ForgotPasswordRepository _repository;

  @override
  Future<ForgotPasswordOutput> buildUseCase(ForgotPasswordInput input) async {
    final res = await _repository.forgotPassword(input.email);
    if (res.code == 200) {
      return ForgotPasswordOutput(
        res.code,
        res.message,
        res.data['session_key'],
        res.data['email'],
      );
    }
    return ForgotPasswordOutput(
      res.code,
      res.message,
      '',
      '',
    );
  }
}

class ForgotPasswordInput extends BaseInput {
  ForgotPasswordInput(this.email);

  String email;
}

class ForgotPasswordOutput extends BaseOutput {
  ForgotPasswordOutput(this.code, this.message, this.sessionKey, this.email);

  int? code;
  String? message;
  String sessionKey;
  String email;
}
