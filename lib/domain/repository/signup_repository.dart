import 'package:one_click/data/models/payload/signup_payload.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/signup_model.dart';

abstract class SignupRepository {
  Future<BaseResponseModel<SignupModel>> register(SignupPayload payload);
}
