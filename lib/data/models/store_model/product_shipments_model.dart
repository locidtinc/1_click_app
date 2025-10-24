import 'package:json_annotation/json_annotation.dart';

part 'product_shipments_model.g.dart';

@JsonSerializable()
class ProductShipmentsModel {
  ProductShipmentsModel({
    this.id,
    this.storageQuantity,
    this.endDate,
    this.status,
    this.statusLabel,
    this.quantity,
  });

  final int? id;

  @JsonKey(name: 'storage_quantity')
  final num? storageQuantity;
  @JsonKey(name: 'current_quantity')
  final num? quantity;

  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  final num? status;

  @JsonKey(name: 'status_label')
  final String? statusLabel;

  factory ProductShipmentsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductShipmentsModelFromJson(json);
}
