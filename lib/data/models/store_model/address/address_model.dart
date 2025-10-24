import 'package:json_annotation/json_annotation.dart';

import 'type_data.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  AddressModel({
    this.id,
    this.title,
    this.lat,
    this.long,
    this.area,
    this.province,
    this.district,
    this.ward,
    this.areaData,
    this.provinceData,
    this.districtData,
    this.wardData,
  });

  int? id;
  String? title;
  double? lat;
  double? long;
  int? area;
  int? province;
  int? district;
  int? ward;
  @JsonKey(name: 'area_data')
  TypeData? areaData;
  @JsonKey(name: 'province_data')
  TypeData? provinceData;
  @JsonKey(name: 'district_data')
  TypeData? districtData;
  @JsonKey(name: 'ward_data')
  TypeData? wardData;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
