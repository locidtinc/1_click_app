import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/payload/signup_payload.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/signup_model.dart';
import 'package:one_click/domain/repository/signup_repository.dart';
import 'package:one_click/presentation/di/di.dart';

@LazySingleton(as: SignupRepository)
class SignupRepositoryImpl extends SignupRepository {
  @override
  Future<BaseResponseModel<SignupModel>> register(SignupPayload payload) async {
    try {
      final body = {
        'account': payload.account.toJson(),
        'shop': {
          'title': payload.shop.title,
          'subdomain': payload.shop.website
        },
        'address': {
          'title': payload.address.title,
          'lat': payload.address.lat,
          'long': payload.address.long,
          'province': payload.address.province,
          'district': payload.address.district,
          'ward': payload.address.ward,
        }
      };
      final res = await getIt<BaseDio>().dio().post(Api.signup, data: body);
      if (res.data['code'] == 400) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: SignupModel.fromJson(res.data['data']),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 500,
        message: 'Server error',
        data: null,
      );
    }
  }
}
