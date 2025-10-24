import 'package:json_annotation/json_annotation.dart';

part 'system_model.g.dart';

@JsonSerializable()
class SystemDataModel {
  final int? id;
  final String? title;
  final String? code;

  SystemDataModel({
    this.id,
    this.title,
    this.code,
  });

  SystemDataModel copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      SystemDataModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );

  factory SystemDataModel.fromJson(Map<String, dynamic> json) =>
      _$SystemDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SystemDataModelToJson(this);
}
