import 'package:freezed_annotation/freezed_annotation.dart';

part 'parent_account_entity.freezed.dart';
part 'parent_account_entity.g.dart';

@freezed
class ParentAccountEntity with _$ParentAccountEntity {
  const factory ParentAccountEntity({
    int? id,
    @JsonKey(name: 'full_name') String? fullName,
    Map<String, dynamic>? settings,
    @JsonKey(name: 'system_data') SystemData? systemData,
    @JsonKey(name: 'key_account') String? keyAccount,
  }) = _ParentAccountEntity;

  factory ParentAccountEntity.fromJson(Map<String, dynamic> json) => _$ParentAccountEntityFromJson(json);
}

@freezed
class SystemData with _$SystemData {
  const factory SystemData({
    int? id,
    String? title,
    String? code,
  }) = _SystemData;

  factory SystemData.fromJson(Map<String, dynamic> json) => _$SystemDataFromJson(json);
}
