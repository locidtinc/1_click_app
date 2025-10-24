import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_information_payload.freezed.dart';

part 'store_information_payload.g.dart';

@freezed
class StoreInformationPayload with _$StoreInformationPayload {
  const StoreInformationPayload._();

  const factory StoreInformationPayload({
    AccountPayload? account,
    @JsonKey(name: 'address') AddressPayload? address,
    @JsonKey(name: 'address_shop') AddressPayload? addressShop,
    BankPayload? bank,
    ShopPayload? shop,
  }) = _StoreInformationPayload;

  factory StoreInformationPayload.fromJson(Map<String, dynamic> json) => _$StoreInformationPayloadFromJson(json);
}

@freezed
class AccountPayload with _$AccountPayload {
  const factory AccountPayload({
    @Default('') String? email,
    @JsonKey(name: 'full_name') @Default('') String? fullName,
    @Default('') String? phone,
    @JsonKey(name: 'referral_code_point') @Default(null) String? referralCodePoint,
    @JsonKey(name: 'referral_code') @Default(null) String? referralCode,
  }) = _AccountPayload;

  factory AccountPayload.fromJson(Map<String, dynamic> json) => _$AccountPayloadFromJson(json);
}

@freezed
class AddressPayload with _$AddressPayload {
  const factory AddressPayload({
    @Default('') String title,
    @Default(11.22) double lat,
    @Default(11.22) double long,
    @Default(1) int province,
    @Default(1) int district,
    @Default(1) int ward,
    @Default(1) int area,

    // @Default('') String provinceName,
    // @Default('') String districtName,
    // @Default('') String wardName,
  }) = _AddressPayload;

  factory AddressPayload.fromJson(Map<String, dynamic> json) => _$AddressPayloadFromJson(json);
}

@freezed
class BankPayload with _$BankPayload {
  const factory BankPayload({
    @JsonKey(name: 'card_number') @Default('') String cardNumber,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @JsonKey(name: 'card_type') @Default('') String cardType,
    @Default(1) int bank,
  }) = _BankPayload;

  factory BankPayload.fromJson(Map<String, dynamic> json) => _$BankPayloadFromJson(json);
}

@freezed
class ShopPayload with _$ShopPayload {
  const factory ShopPayload({
    @Default('') String? title,
    @JsonKey(name: 'bussiness_type') @Default(0) int? businessType,
    @Default('') String? description,
    @Default(SettingShopPayload()) SettingShopPayload? settings,
    @Default('') String? website,
    @JsonKey(name: 'tax_code') @Default('') String? taxCode,
    @JsonKey(name: 'business_code') @Default('') String? businessCode,
    @JsonKey(name: 'warehouse_area') @Default('') String? wareHouseArena,
  }) = _ShopPayload;

  factory ShopPayload.fromJson(Map<String, dynamic> json) => _$ShopPayloadFromJson(json);
}

@freezed
class SettingShopPayload with _$SettingShopPayload {
  const factory SettingShopPayload({
    @JsonKey(name: 'open_time') @Default('') String? openTime,
    @JsonKey(name: 'close_time') @Default('') String? closeTime,
    @Default('') String? contact,
  }) = _SettingShopPayload;

  factory SettingShopPayload.fromJson(Map<String, dynamic> json) => _$SettingShopPayloadFromJson(json);
}
