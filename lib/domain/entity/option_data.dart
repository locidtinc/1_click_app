import 'package:freezed_annotation/freezed_annotation.dart';

part 'option_data.freezed.dart';
part 'option_data.g.dart';

@freezed
class OptionDataEntity with _$OptionDataEntity {
  const OptionDataEntity._();

  const factory OptionDataEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String values,
    @Default(true) bool status,
    String? code,
  }) = _OptionDataEntity;

  factory OptionDataEntity.fromJson(Map<String, dynamic> json) => _$OptionDataEntityFromJson(json);
}
