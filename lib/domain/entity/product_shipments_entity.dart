import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_shipments_entity.freezed.dart';

@freezed
class ProductShipmentsEntity with _$ProductShipmentsEntity {
  const ProductShipmentsEntity._();

  const factory ProductShipmentsEntity({
    @Default(0) int? id,
    @Default(0) num? storageQuantity,
    @Default(0) num? quantity,
    final DateTime? endDate,
    @Default(0) num? status,
    @Default('') String? statusLabel,
  }) = _ProductShipmentsEntity;
}
