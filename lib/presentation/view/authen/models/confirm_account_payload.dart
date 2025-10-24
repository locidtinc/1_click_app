import 'dart:convert';

class ConfirmAccountPayload {
  String? phone;
  String? password;
  String? fullName;
  String? shopName;
  AddressDataPayload? address;

  ConfirmAccountPayload({
    this.phone,
    this.password,
    this.fullName,
    this.shopName,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['password'] = password;
    data['full_name'] = fullName;
    data['title'] = shopName;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class AddressDataPayload {
  String? title;
  String? address;
  double? lat;
  double? long;
  int? province;
  String? provinceName;
  int? district;
  String? districtName;
  int? ward;
  String? wardName;
  int? area;
  String? areaName;

  AddressDataPayload({
    this.title,
    this.address,
    this.lat,
    this.long,
    this.province,
    this.provinceName,
    this.district,
    this.districtName,
    this.ward,
    this.wardName,
    this.area,
    this.areaName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['title'] = title;
    data['title'] = address;
    data['lat'] = lat;
    data['long'] = long;
    data['province'] = province;
    data['district'] = district;
    data['ward'] = ward;
    data['area'] = area;

    return data;
  }

  String get toText {
    return '$wardName, $districtName, $provinceName';
  }
}
