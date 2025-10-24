import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipments_infor_entity.freezed.dart';

@freezed
class ShipmentsInforEntity with _$ShipmentsInforEntity {
  const ShipmentsInforEntity._();

  const factory ShipmentsInforEntity({
    @Default(0) num? totalShipmentNearDate,
    @Default(0) num? quantityNearDate,
    @Default(0) num? quantityExpDate,
    @Default(0) num? quantityInventory,
  

  }) = _ShipmentsInforEntity;
}
