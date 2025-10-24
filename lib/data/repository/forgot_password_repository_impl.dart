import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/forgot_password_repository.dart';

@LazySingleton(as: ForgotPasswordRepository)
class ForgotPasswordRepositoryImpl extends ForgotPasswordRepository {
  final BaseDio baseDio;

  ForgotPasswordRepositoryImpl(this.baseDio);

  @override
  Future<BaseResponseModel> forgotPassword(String phone) async {
    try {
      final body = {'phone': phone, 'system_code': 'CHTH'};
      final res = await baseDio.dio().post(Api.forgotPassword, data: body);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data'],
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: 'Server error', data: '');
    }
  }

  @override
  Future<BaseResponseModel<bool>> verifyPassword(
    String otp,
    String sessionKey,
  ) async {
    try {
      final body = {'otp_forgot': otp, 'session_key': sessionKey};
      final res = await baseDio.dio().post(Api.verifyPassword, data: body);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: 'Server error');
    }
  }

  @override
  Future<BaseResponseModel<bool>> resetPassword(
    String otp,
    String sessionKey,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final body = {
        'otp_forgot': otp,
        'session_key': sessionKey,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
      final res = await baseDio.dio().post(Api.resetPassword, data: body);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: 'Server error');
    }
  }

  @override
  Future<BaseResponseModel<bool>> resetOtp(String sessionKey) async {
    try {
      final body = {'session_key': sessionKey};
      final res = await baseDio.dio().post(Api.resetOtp, data: body);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: 'Server error');
    }
  }

  @override
  Future<BaseResponseModel<bool>> changePassword(
    String? currentPassword,
    String? newPassword,
  ) async {
    try {
      final body = {
        'old_password': currentPassword,
        'new_password': newPassword
      };
      final res = await baseDio.dio().put(Api.changePassword, data: body);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: 'Server error');
    }
  }
}
