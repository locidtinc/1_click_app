import 'package:json_annotation/json_annotation.dart';

part 'participation_even_model.g.dart';

@JsonSerializable()
class ParticipationEvenModel {
  final int? id;
  final String? title;
  final String? subdomain;
  final String? description;
  final String? website;
  final String? bussinessTypeTitle;
  final String? code;
  final SettingsModel? settings;

  ParticipationEvenModel({
    this.id,
    this.title,
    this.subdomain,
    this.description,
    this.website,
    this.bussinessTypeTitle,
    this.code,
    this.settings,
  });

  factory ParticipationEvenModel.fromJson(Map<String, dynamic> json) => _$ParticipationEvenModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipationEvenModelToJson(this);
}

@JsonSerializable()
class SettingsModel {
  final String? contact;
  final String? openTime;
  final String? closeTime;
  final String? description;
  final BusinessTypeModel? businessType;

  SettingsModel({
    this.contact,
    this.openTime,
    this.closeTime,
    this.description,
    this.businessType,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}

@JsonSerializable()
class BusinessTypeModel {
  final int? id;
  final String? code;
  final String? title;
  final int? system;

  BusinessTypeModel({
    this.id,
    this.code,
    this.title,
    this.system,
  });

  factory BusinessTypeModel.fromJson(Map<String, dynamic> json) => _$BusinessTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessTypeModelToJson(this);
}
