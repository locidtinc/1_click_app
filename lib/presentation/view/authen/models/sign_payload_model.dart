import 'package:one_click/presentation/view/authen/models/confirm_account_payload.dart';

class SignPayloadModel {
  String name;
  String phone;
  String password;
  String? referralCode;
  String? subdomain;

  String shopName;
  AddressDataPayload? address;
  String? taxCode;
  String? businessCode;
  String? warehouseArea;

  SignPayloadModel({
    required this.name,
    required this.phone,
    required this.password,
    required this.shopName,
    required this.address,
    this.subdomain,
    this.referralCode,
    this.taxCode,
    this.businessCode,
    this.warehouseArea,
  });

  Map<String, dynamic> toJson() {
    return {
      'account': {
        'full_name': name,
        'phone': phone,
        'password': password,
        'referral_code': referralCode,
      },
      'shop': {
        'title': shopName,
        // 'subdomain': '$shopName-subdomain',
        'subdomain': subdomain ?? '$shopName-subdomain',
        'tax_code': taxCode,
        'business_code': businessCode,
        'warehouse_area': warehouseArea,
      },
      'address': address?.toJson(),
    };
  }
}
