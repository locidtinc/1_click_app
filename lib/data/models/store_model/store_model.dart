import 'package:json_annotation/json_annotation.dart';
import 'package:one_click/data/models/parent_account_data_model.dart';
import 'package:one_click/data/models/store_model/address/address_model.dart';
import 'package:one_click/data/models/system_model.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'card_data.dart';
import 'shop_data.dart';
import 'user_created.dart';
import 'warehouse_data.dart';

part 'store_model.g.dart';

@JsonSerializable()
class StoreModel {
  StoreModel({
    required this.id,
    required this.phone,
    this.email,
    this.keyAccount,
    this.fullName,
    this.settings,
    this.birthday,
    this.avatar,
    this.createdAt,
    this.accountType,
    this.isActive,
    this.parentAccount,
    this.userCreated,
    this.addressData,
    this.genderData,
    this.systemData,
    this.cardData,
    this.accountTypeData,
    this.contractData,
    this.shopData,
    this.userCreatedData,
  });

  int id;
  String phone;
  String? email;
  @JsonKey(name: 'key_account')
  String? keyAccount;
  @JsonKey(name: 'full_name')
  String? fullName;
  Settings? settings;
  String? birthday;
  String? avatar;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'account_type')
  String? accountType;
  @JsonKey(name: 'is_active')
  bool? isActive;
  @JsonKey(name: 'parent_account')
  int? parentAccount;
  @JsonKey(name: 'parent_account_data')
  ParentAccountModel? parentAccountData;
  @JsonKey(name: 'user_created')
  dynamic userCreated;
  @JsonKey(name: 'address_data')
  AddressModel? addressData;
  @JsonKey(name: 'gender_data')
  dynamic genderData;
  @JsonKey(name: 'system_data')
  SystemDataModel? systemData;
  @JsonKey(name: 'card_data')
  List<CardData>? cardData;
  @JsonKey(name: 'account_type_data')
  String? accountTypeData;
  @JsonKey(name: 'contract_data')
  String? contractData;
  @JsonKey(name: 'shop_data')
  ShopData? shopData;
  @JsonKey(name: 'warehouse_data')
  WarehouseModel? warehouseData;
  @JsonKey(name: 'user_created_data')
  UserCreatedModel? userCreatedData;
  @JsonKey(name: 'referral_code')
  String? referralCode;
  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);
}
