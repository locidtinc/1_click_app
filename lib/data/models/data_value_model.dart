import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_value_model.g.dart';

@JsonSerializable()
class DataValueModel {
  DataValueModel({required this.id, required this.title});

  final int id;
  final String title;

  factory DataValueModel.fromJson(Map<String, dynamic> json) =>
      _$DataValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataValueModelToJson(this);
}
