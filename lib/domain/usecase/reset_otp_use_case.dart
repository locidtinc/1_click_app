import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/forgot_password_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class ResetOtpUseCase
    extends BaseUseCaseInput<String, BaseResponseModel<bool>> {
  ResetOtpUseCase(this._repository);

  final ForgotPasswordRepository _repository;

  @override
  Future<BaseResponseModel<bool>> execute(String input) async {
    final res = await _repository.resetOtp(input);
    return res;
  }
}
