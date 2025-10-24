import 'package:one_click/data/models/response/base_response.dart';

abstract class ForgotPasswordRepository {
  Future<BaseResponseModel> forgotPassword(String phone);

  Future<BaseResponseModel<bool>> verifyPassword(String otp, String sessionKey);

  Future<BaseResponseModel<bool>> resetPassword(
    String otp,
    String sessionKey,
    String newPassword,
    String confirmPassword,
  );

  Future<BaseResponseModel<bool>> resetOtp(String sessionKey);

  Future<BaseResponseModel<bool>> changePassword(
    String? currentPassword,
    String? newPassword,
  );
}
