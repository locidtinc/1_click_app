import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/brand_detail_model.dart';
import 'package:one_click/data/models/store_model/product_shipments_model.dart';
import 'package:one_click/domain/entity/product_shipments_entity.dart';

@injectable
class ProductShipmentsMapper
    extends BaseDataMapper<ProductShipmentsModel, ProductShipmentsEntity> {
  ProductShipmentsMapper();
  @override
  ProductShipmentsEntity mapToEntity(ProductShipmentsModel? data) {
    return ProductShipmentsEntity(
      id: data?.id ?? 0,
      endDate: data?.endDate,
      quantity: data?.quantity,
      status: data?.status,
      statusLabel: data?.statusLabel,
      storageQuantity: data?.storageQuantity ?? 0,
    );
  }
}
