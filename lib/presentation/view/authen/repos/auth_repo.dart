import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/shared/ext/index.dart';

import '../models/auth_model.dart';
import '../models/confirm_account_payload.dart';

class AuthRepo {
  Dio get _dio => getIt<BaseDio>().dio();

  Future<BaseResponseModel<AuthModel>> checkAccount(String phone) async {
    try {
      final response = await _dio.post(
        Api.checkAccount,
        data: {
          'phone': phone,
        },
      );
      //jsonEncode(response.data['data']).copy;
      return BaseResponseModel(
        data: response.data['data'] is Map
            ? AuthModel.fromJson(response.data['data'] ?? {})
            : null,
        code: response.statusCode,
        message: response.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> sendOtp(String phone) async {
    try {
      final response = await _dio.post(
        Api.sendOtp,
        data: {
          'phone': phone,
        },
      );
      return BaseResponseModel(
        code: response.data['code'],
      );
    } catch (e) {
      // return BaseResponseModel(
      //   code: 400,
      //   message: e.toString(),
      // );
      return BaseResponseModel(
        code: 400,
        message: 'Lỗi ZNS',
      );
    }
  }

  Future<BaseResponseModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        Api.verifyOtp,
        data: {
          'phone': phone,
          'otp': otp,
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

  Future<BaseResponseModel> confirmAccount(
    ConfirmAccountPayload payload,
  ) async {
    try {
      final response = await _dio.post(
        Api.confirmAccount,
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
}
