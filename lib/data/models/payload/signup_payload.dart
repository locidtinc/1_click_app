import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entity/store_information_payload.dart';

part 'signup_payload.g.dart';

@JsonSerializable()
class SignupPayload {
  SignupPayload(this.account, this.shop, this.address);

  AccountPayloadModel account;
  ShopPayloadModel shop;
  AddressPayload address;

  factory SignupPayload.fromJson(Map<String, dynamic> json) =>
      _$SignupPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$SignupPayloadToJson(this);
}

@JsonSerializable()
class AccountPayloadModel {
  AccountPayloadModel(this.phone, this.password, this.fullName);

  String phone;
  String password;
  @JsonKey(name: 'full_name') String? fullName;

  factory AccountPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$AccountPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountPayloadModelToJson(this);
}

@JsonSerializable()
class ShopPayloadModel {
  ShopPayloadModel(this.title, this.website);

  String title;
  String website;

  factory ShopPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$ShopPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopPayloadModelToJson(this);
}