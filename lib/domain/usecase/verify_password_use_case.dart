import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/forgot_password_repository.dart';

import 'base/base_use_case.dart';

@injectable
class VerifyPasswordUseCase
    extends BaseUseCaseInput<VerifyPasswordInput, BaseResponseModel<bool>> {
  VerifyPasswordUseCase(this._repository);

  final ForgotPasswordRepository _repository;

  @override
  Future<BaseResponseModel<bool>> execute(VerifyPasswordInput input) async {
    final res = await _repository.verifyPassword(input.otp, input.sessionKey);
    return res;
  }
}

class VerifyPasswordInput {
  VerifyPasswordInput(this.otp, this.sessionKey);

  String otp;
  String sessionKey;
}
