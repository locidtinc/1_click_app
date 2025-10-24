import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/payload/signup_payload.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/signup_model.dart';
import 'package:one_click/domain/repository/signup_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

import 'base/io/base_input.dart';

@injectable
class SignupUseCase extends BaseFutureUseCase<SignupInput, SignupOutput> {
  SignupUseCase(this._repository);

  final SignupRepository _repository;

  @override
  Future<SignupOutput> buildUseCase(SignupInput input) async {
    final res = await _repository.register(input.signupPayload);
    return SignupOutput(res);
  }
}

class SignupInput extends BaseInput {
  SignupInput(this.signupPayload);

  SignupPayload signupPayload;
}

class SignupOutput extends BaseOutput {
  SignupOutput(this.data);

  BaseResponseModel<SignupModel> data;
}
