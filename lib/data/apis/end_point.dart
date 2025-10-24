import 'package:injectable/injectable.dart';
import 'package:one_click/env/env_config.dart';

@injectable
class Api {
  static String key = 'CHTH';
  static String test = 'my'; // my || on
  static String prod = 'on';

  static String urlGMS = 'https://maps.googleapis.com/maps/api';

  static String baseURL = EnvironmentConfig.BASE_URL;

  static String login = '$baseURL/account/api/login/';
  static String signup = '$baseURL/account/api/chth/register/';
  static String forgotPassword = '$baseURL/account/api/forgot_password/';
  static String verifyPassword = '$baseURL/account/api/verify_forgot/';
  static String resetPassword = '$baseURL/account/api/resetpassword/';
  static String resetOtp = '$baseURL/account/api/reset_otp/';
  static String changePassword = '$baseURL/account/api/changepassword/';
  static String storeInfo = '$baseURL/account/api/account/';
  static String businessType = '$baseURL/shop/api/bussinesstype/';
  static String bankList = '$baseURL/bank/api/bank/';
  static String checkCard = '$baseURL/bank/api/checkcard/';
  static String province = '$baseURL/location/v2/api/province/';
  static String district = '$baseURL/location/v2/api/district/';
  static String ward = '$baseURL/location/v2/api/ward/';
  static String area = '$baseURL/location/v2/api/area/';
  static String address = '$baseURL/account/api/address/';
  static String updateStatusAccount =
      '$baseURL/account/api/admin/updatestatusaccount/';

  static String refreshToken =
      '$baseURL/micro-account/account/api/refresh_token';

  static String customer = '$baseURL/customer/api/customer/';

  static String category = '$baseURL/product/api';
  static String brand = '$baseURL/product/api/productbrand/';
  static String group = '$baseURL/product/api/productgroup/';

  static String product = '$baseURL/product/api/product/';
  static String productBrand = '$baseURL/product/api/productbrand/';
  static String productScan = '$baseURL/product/api/scanproduct';
  static String productSuggest = '$baseURL/product/api/product-suggest/';

  // static String productCreate =
  //     '$baseURL/micro-product-$env/product/api/create_product';
  static String productDetail = '$baseURL/product/api/product/';
  static String productCategory = '$baseURL/product/api/productcategory/';
  static String productGroup = '$baseURL/product/api/productgroup/';

  // variant
  static String variant = '$baseURL/product/api/variant/';
  static String variantDepartment = '$baseURL/product/api/variant-department/';
  static String variantScan = '$baseURL/product/api/scanvariant/';
  static String variantPromotion = '$baseURL/product/api/variantwithpromotion/';

  // order
  static String order = '$baseURL/order/api/order/';
  static String orderSystem = '$baseURL/order/api/ordersystem/';
  static String orderCount = '$baseURL/order/api/countorder/';
  static String orderSystemUpdateStatus =
      '$baseURL/order/api/updatestatusordersystem/';
  static String orderUpdateStatus = '$baseURL/order/api/updatestatusorder/';
  static String orderQRCodePayment = '$baseURL/order/api/order/qrcodepayment/';
  static String orderSystemCancel = '$baseURL/order/api/cancelordersystem/';

  // card bank
  static String card = '$baseURL/bank/api/card/';

  // promotion
  static String promotionType = '$baseURL/promotion/api/typediscount/';

  //v2
  static String checkAccount = '$baseURL/account/api/check-account/';
  static String sendOtp = '$baseURL/account/api/send-otp/';
  static String verifyOtp = '$baseURL/account/api/verify-otp/';
  static String confirmAccount = '$baseURL/account/api/confirm-infor-account/';

  //noti
  static String notification = '$baseURL/notification/api/notification';
  //daily
  static String dailyOrders = '$baseURL/shop/api/dailyorderstatistics';
  //avarta
  static String avatar = '$baseURL/account/api/update-avatar-account';
  //warehouse
  static String warehouseList = '$baseURL/warehouse/api/warehouse-v2/';
  static String createImportReceipt = '$baseURL/warehouse/api/importreceipt/';
  static String reportWareHouse =
      '$baseURL/warehouse/api/report-warehouse-pharma/';
  static String prdShipments = '$baseURL/product/api/shipment-product-detail';
}
