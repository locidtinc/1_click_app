import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/store_model/shipments_infor_model.dart';
import 'package:one_click/domain/entity/shipments_infor_entity.dart';

@injectable
class ShipmentsInforMapper
    extends BaseDataMapper<ShipmentsInforModel, ShipmentsInforEntity> {
  ShipmentsInforMapper();
  @override
  ShipmentsInforEntity mapToEntity(ShipmentsInforModel? data) {
    return ShipmentsInforEntity(
      quantityExpDate: data?.quantityExpDate,
      quantityInventory: data?.quantityInventory,
      quantityNearDate: data?.quantityNearDate,
      totalShipmentNearDate: data?.totalShipmentNearDate,
    );
  }
}
