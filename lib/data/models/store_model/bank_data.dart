import 'package:json_annotation/json_annotation.dart';

part 'bank_data.g.dart';

@JsonSerializable()
class BankData {
  BankData({
    required this.id,
    required this.title,
    required this.code,
    this.shortName,
    this.image,
    this.bin,
    this.swiftCode,
  });

  int id;
  String title;
  String code;
  @JsonKey(name: 'short_name')
  String? shortName;
  @JsonKey(name: 'img_url')
  String? image;
  String? bin;
  String? swiftCode;

  factory BankData.fromJson(Map<String, dynamic> json) =>
      _$BankDataFromJson(json);

  Map<String, dynamic> toJson() => _$BankDataToJson(this);
}
