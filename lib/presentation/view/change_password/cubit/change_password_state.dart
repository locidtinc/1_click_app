import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    @Default(false) bool showPassword,
  }) = _ChangePasswordState;
}
