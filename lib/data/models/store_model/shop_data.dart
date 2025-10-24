import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/data/models/store_model/address/address_model.dart';
import 'package:one_click/data/models/store_model/shop_settings.dart';

part 'shop_data.g.dart';

@JsonSerializable()
class ShopData {
  ShopData({
    this.id,
    this.title,
    this.code,
    this.subdomain,
    this.description,
    this.settings,
    this.bussinessType,
    this.address,
    this.account,
    this.createdAt,
    this.updatedAt,
    this.businessTypeData,
    this.addressData,
    this.website,
    this.businessCode,
    this.taxCode,
    this.warehouseArea,
  });

  int? id;
  String? title;
  String? code;
  String? subdomain;
  String? description;
  ShopSettings? settings;
  @JsonKey(name: 'bussiness_type')
  int? bussinessType;
  int? address;
  int? account;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'business_type_data')
  TypeData? businessTypeData;
  @JsonKey(name: 'address_data')
  AddressModel? addressData;
  String? website;
  @JsonKey(name: 'tax_code')
  String? taxCode;
  @JsonKey(name: 'business_code')
  String? businessCode;
  @JsonKey(name: 'warehouse_area')
  String? warehouseArea;
  factory ShopData.fromJson(Map<String, dynamic> json) =>
      _$ShopDataFromJson(json);

  Map<String, dynamic> toJson() => _$ShopDataToJson(this);
}
