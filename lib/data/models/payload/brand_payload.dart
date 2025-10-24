import 'package:json_annotation/json_annotation.dart';
part 'brand_payload.g.dart';

@JsonSerializable()
class BrandPayloadModel {
  final String? title;
  final List<int>? product;
  final List<int>? group;

  BrandPayloadModel({
    required this.title,
    required this.product,
    required this.group,
  });

  factory BrandPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$BrandPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandPayloadModelToJson(this);
}
