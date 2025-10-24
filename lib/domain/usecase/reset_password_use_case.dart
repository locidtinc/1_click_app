import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/forgot_password_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class ResetPasswordUseCase
    extends BaseUseCaseInput<ResetPasswordInput, BaseResponseModel<bool>> {
  ResetPasswordUseCase(this._repository);

  final ForgotPasswordRepository _repository;

  @override
  Future<BaseResponseModel<bool>> execute(ResetPasswordInput input) async {
    final res = await _repository.resetPassword(
      input.otp,
      input.sessionKey,
      input.newPassword,
      input.confirmPassword,
    );
    return res;
  }
}

class ResetPasswordInput {
  ResetPasswordInput(
    this.sessionKey,
    this.otp,
    this.newPassword,
    this.confirmPassword,
  );

  String sessionKey;
  String otp;
  String newPassword;
  String confirmPassword;
}
