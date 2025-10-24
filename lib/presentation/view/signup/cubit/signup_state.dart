import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
class SignupState with _$SignupState {
  factory SignupState({
    @Default('') String phone,
    @Default('') String password,
    @Default('') String nameStore,
    @Default('') String website,
    @Default('') String address,
    @Default(false) bool showPassword,
    String? deputy,
  }) = _SignupState;
}
