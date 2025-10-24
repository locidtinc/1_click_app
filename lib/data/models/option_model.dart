import 'package:json_annotation/json_annotation.dart';

part 'option_model.g.dart';

@JsonSerializable()
class OptionModel {
  final int? id;
  final String? title;
  final dynamic code;
  final String? values;
  final bool? status;

  OptionModel({
    this.id,
    this.title,
    this.code,
    this.values,
    this.status,
  });

  OptionModel copyWith({
    int? id,
    String? title,
    dynamic code,
    String? values,
    bool? status,
  }) =>
      OptionModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        values: values ?? this.values,
        status: status ?? this.status,
      );

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionModelToJson(this);
}
