import 'package:json_annotation/json_annotation.dart';

part 'type_data.g.dart';

@JsonSerializable()
class TypeData {
  TypeData({
    this.id,
    this.title,
    this.code,
  });

  int? id;
  String? title;
  String? code;

  factory TypeData.fromJson(Map<String, dynamic> json) =>
      _$TypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$TypeDataToJson(this);
}
