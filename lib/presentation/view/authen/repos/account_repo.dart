import 'package:dio/dio.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/presentation/di/di.dart';

import '../../../../data/models/response/base_response.dart';
import '../models/sign_payload_model.dart';

class AccountRepo {
  Dio get _dio => getIt<BaseDio>().dio();
  Future<BaseResponseModel> sign(
    SignPayloadModel payload,
  ) async {
    try {
      final response = await _dio.post(
        Api.signup,
        data: payload.toJson(),
      );
      return BaseResponseModel(
        code: response.data['code'],
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> resetPass({
    required String phone,
    required String newPass,
    required String newPassConfirm,
  }) async {
    try {
      final response = await _dio.post(
        Api.resetPassword,
        data: {
          'phone': phone,
          'new_password': newPass,
          'confirm_password': newPassConfirm,
        },
      );
      return BaseResponseModel(
        code: response.data['code'],
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
