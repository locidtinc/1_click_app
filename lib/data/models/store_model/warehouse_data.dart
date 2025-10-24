
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_data.g.dart';

@JsonSerializable()
class WarehouseData {

  int? id;

  WarehouseData({
    this.id,
  });

  factory WarehouseData.fromJson(Map<String, dynamic> json) =>
      _$WarehouseDataFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseDataToJson(this);
}