import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/domain/entity/product_brand_preview.dart';

import '../models/product_brand_model.dart';

@injectable
class ProductBrandModelMapper
    extends BaseDataMapper<ProductBrandModel, ProductBrandPreviewEntity> {
  @override
  ProductBrandPreviewEntity mapToEntity(ProductBrandModel? data) {
    return ProductBrandPreviewEntity(
      title: data?.title ?? '',
      code: data?.code ?? '',
      id: data?.id ?? 0,
    );
  }
}
