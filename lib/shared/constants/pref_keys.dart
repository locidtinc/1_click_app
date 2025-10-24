import '../../domain/entity/order_detail.dart';

class PrefKeys {
  static const String GMSToken = 'AIzaSyBxNc7ESSs1Re-UiJO2AmAPlI2eyDdHHHg';
  static const String token = 'TOKEN';
  static const String store = 'STORE';
  static const String username = 'USERNAME';
  static const String password = 'PASSWORD';
  static const String rememberPassword = 'REMEMBER_PASSWORD';
  static const String tokenRefresh = 'TOKEN_REFRESH';
  static const String cart = 'CART';
  static const String firebaseToken = 'FIREBASE_TOKEN';
  static const String countryCode = 'COUNTRY_CODE';
  static const String languageCode = 'LANGUAGE_CODE';
  static const String user = 'USER';
  static const String account = 'ACCOUNT';
  static const String key = 'AD';
  static const String priceList = 'PRICE_LIST';
  static const String dataCHTH = 'DATACHTH';

  static const String card = 'CARD';
  static const String warehouseId = 'WAREHOUSEID';

  /// This key use to get data from Local
  /// 
  /// Type data saved is jsonEncode(List[OrderDetailEntity].toJson())
  /// 
  /// Before use please to [jsonDecode] data
  static const String orderDrafExport = 'ORDER_DRAF_EXPORT';
  static const String orderDrafImport = 'ORDER_DRAF_IMPORT';
  static const int idOrderDrafStatus = 888;

  static const String imgProductDefault =
      'https://static.vecteezy.com/system/resources/previews/011/537/711/original/box-empty-state-single-isolated-icon-with-outline-style-free-vector.jpg';

  static const String avatarDefault =
      'https://cdn-icons-png.flaticon.com/512/3607/3607444.png';

  static const String cardDefault =
      'https://cdn-icons-png.flaticon.com/512/3607/3607444.png';
}
