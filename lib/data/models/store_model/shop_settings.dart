import 'package:json_annotation/json_annotation.dart';

part 'shop_settings.g.dart';

@JsonSerializable()
class ShopSettings {
  ShopSettings({
    this.closeTime,
    this.openTime,
    this.contact,
  });

  @JsonKey(name: 'close_time')
  String? closeTime;
  @JsonKey(name: 'open_time')
  String? openTime;
  String? contact;

  factory ShopSettings.fromJson(Map<String, dynamic> json) =>
      _$ShopSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ShopSettingsToJson(this);
}
