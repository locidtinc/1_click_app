// parent_account_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'system_model.dart';

part 'parent_account_data_model.g.dart';

@JsonSerializable()
class ParentAccountModel {
  final int? id;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final Map<String, dynamic>? settings;
  @JsonKey(name: 'system_data')
  final SystemDataModel? systemData;
  @JsonKey(name: 'key_account')
  final String? keyAccount;

  ParentAccountModel({
    this.id,
    this.fullName,
    this.settings,
    this.systemData,
    this.keyAccount,
  });

  factory ParentAccountModel.fromJson(Map<String, dynamic> json) => _$ParentAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParentAccountModelToJson(this);
}
