import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_password_state.freezed.dart';

@freezed
class VerifyPasswordState with _$VerifyPasswordState {
  const factory VerifyPasswordState({
    @Default('') String pinCode,
    @Default(false) bool enableButton,
    @Default(60) int time,
    String? errorText,
  }) = _VerifyPasswordState;
}
