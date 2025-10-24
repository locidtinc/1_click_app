import 'package:json_annotation/json_annotation.dart';

part 'unit_model.g.dart';

@JsonSerializable()
class UnitModel {
  final int? id;
  final String? title;
  final int? level;

  @JsonKey(name: 'conversion_value')
  final dynamic conversionValue;

  @JsonKey(name: 'storage_unit')
  final bool? storageUnit;

  @JsonKey(name: 'sell_unit')
  final bool? sellUnit;

  @JsonKey(name: 'variant_id')
  final int? variantId;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'update_at')
  final DateTime? updateAt;

  UnitModel({
    this.id,
    this.title,
    this.level,
    this.conversionValue,
    this.storageUnit,
    this.sellUnit,
    this.variantId,
    this.createdAt,
    this.updateAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) => _$UnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitModelToJson(this);
}
