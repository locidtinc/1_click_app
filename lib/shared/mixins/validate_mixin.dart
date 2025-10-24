import 'package:one_click/shared/constants/regex_constant.dart';

mixin ValidateMixin {
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';
    final regExp = RegExp(RegexConstant.regexPhoneNumber);
    if (!regExp.hasMatch(value) ||
        (value.startsWith('0') && value.length > 10) ||
        (value.startsWith('+84') && value.length < 12)) {
      return 'Số điện thoại không đúng';
    }
    if (value.startsWith('01') ||
        value.startsWith('02') ||
        value.startsWith('06') ||
        value.startsWith('+841') ||
        value.startsWith('+842') ||
        value.startsWith('+846')) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
    final regExp = RegExp(RegexConstant.regexPassword);
    if (!regExp.hasMatch(value)) {
      return 'Mật khẩu có ít nhất 8 ký tự gồm chữ và số';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập địa chỉ email';
    final regExp = RegExp(RegexConstant.regexEmail);
    if (!regExp.hasMatch(value)) {
      return 'Địa chỉ email không đúng';
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty)
      return 'Vui lòng nhập tên người đại diện';
  }
}
