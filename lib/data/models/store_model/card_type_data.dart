import 'package:json_annotation/json_annotation.dart';

part 'card_type_data.g.dart';

@JsonSerializable()
class CardTypeData {
  CardTypeData({
    required this.id,
    required this.title,
    required this.code,
  });

  int id;
  String title;
  String code;

  factory CardTypeData.fromJson(Map<String, dynamic> json) =>
      _$CardTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$CardTypeDataToJson(this);
}
