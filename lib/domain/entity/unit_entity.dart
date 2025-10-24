import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_entity.freezed.dart';
part 'unit_entity.g.dart';

@freezed
class UnitEntity with _$UnitEntity {
  const UnitEntity._();

  const factory UnitEntity({
    @Default(0) int? id,
    @Default(0) int? level,
    @Default('') String? title,
    @JsonKey(name: 'conversion_value') @Default(0) int? conversionValue,
    @JsonKey(name: 'storage_unit') @Default(false) bool? storageUnit,
    @JsonKey(name: 'sell_unit') @Default(false) bool? sellUnit,
  }) = _UnitEntity;

  factory UnitEntity.fromJson(Map<String, dynamic> json) => _$UnitEntityFromJson(json);
}
