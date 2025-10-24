import 'package:one_click/shared/ext/index.dart';

class AppConstant {
  AppConstant._();

  static String endpointWebsite = '.mykios.vn';
  static String http = 'https://';
  static String? genWebsite(String website) {
    if (website.isEmptyOrNull) {
      return null;
    }
    return '$http$website$endpointWebsite';
  }
}
