import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/address/address_model.dart';

part 'customer_model.g.dart';

@JsonSerializable()
class CustomerModel {
  final int? id;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? code;
  final String? phone;
  final String? email;
  @JsonKey(name: 'address_data')
  final AddressModel? address;
  final DateTime? birthday;
  final String? image;
  final int? gender;
  final List<int>? shop;
  @JsonKey(name: 'gender_data')
  final GenderData? genderData;

  CustomerModel({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.address,
    this.birthday,
    this.image,
    this.gender,
    this.shop,
    this.genderData,
    this.code,
  });

  CustomerModel copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? email,
    AddressModel? address,
    DateTime? birthday,
    String? image,
    int? gender,
    List<int>? shop,
    GenderData? genderData,
    String? code,
  }) =>
      CustomerModel(
          id: id ?? this.id,
          fullName: fullName ?? this.fullName,
          phone: phone ?? this.phone,
          email: email ?? this.email,
          address: address ?? this.address,
          birthday: birthday ?? this.birthday,
          image: image ?? this.image,
          gender: gender ?? this.gender,
          shop: shop ?? this.shop,
          genderData: genderData ?? this.genderData,
          code: code ?? this.code);

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}

@JsonSerializable()
class GenderData {
  final int? id;
  final String? title;
  final String? code;

  GenderData({
    this.id,
    this.title,
    this.code,
  });

  GenderData copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      GenderData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );

  factory GenderData.fromJson(Map<String, dynamic> json) =>
      _$GenderDataFromJson(json);

  Map<String, dynamic> toJson() => _$GenderDataToJson(this);
}
