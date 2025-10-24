import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default('') String newPassword,
    @Default('') String confirmPassword,
    @Default(false) bool isShowPassword,
    @Default(false) bool enableButton,
  }) = _ResetPasswordState;
}
