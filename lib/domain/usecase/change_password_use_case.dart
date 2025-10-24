import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/forgot_password_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class ChangePasswordUseCase
    extends BaseUseCaseInput<ChangePasswordInput, BaseResponseModel<bool>> {
  ChangePasswordUseCase(this._repository);

  final ForgotPasswordRepository _repository;

  @override
  Future<BaseResponseModel<bool>> execute(ChangePasswordInput input) async {
    final res = await _repository.changePassword(
      input.currentPassword,
      input.newPassword,
    );
    return res;
  }
}

class ChangePasswordInput {
  ChangePasswordInput(this.currentPassword, this.newPassword);

  String? currentPassword;
  String? newPassword;
}
