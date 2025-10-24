import 'package:json_annotation/json_annotation.dart';

part 'shipments_infor_model.g.dart';

@JsonSerializable()
class ShipmentsInforModel {
  @JsonKey(name: 'total_shipment_near_date')
  num? totalShipmentNearDate;
  @JsonKey(name: 'quantity_near_date')
  num? quantityNearDate;
  @JsonKey(name: 'quantity_exp_date')
  num? quantityExpDate;
  @JsonKey(name: 'quantity_inventory')
  num? quantityInventory;

  ShipmentsInforModel({
    this.totalShipmentNearDate,
    this.quantityNearDate,
    this.quantityExpDate,
    this.quantityInventory,
  });
    factory ShipmentsInforModel.fromJson(Map<String, dynamic> json) => _$ShipmentsInforModelFromJson(json);
}
