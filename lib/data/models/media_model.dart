import 'package:json_annotation/json_annotation.dart';

part 'media_model.g.dart';

@JsonSerializable()
class MediaModel {
  final int? id;
  final String? image;
  final String? alt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  MediaModel({
    this.id,
    this.image,
    this.alt,
    this.createdAt,
  });

  MediaModel copyWith({
    int? id,
    String? image,
    String? alt,
    DateTime? createdAt,
  }) =>
      MediaModel(
        id: id ?? this.id,
        image: image ?? this.image,
        alt: alt ?? this.alt,
        createdAt: createdAt ?? this.createdAt,
      );

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);
}
