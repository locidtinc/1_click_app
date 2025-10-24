import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/domain/entity/brand.dart';

import '../models/brand_model.dart';

@injectable
class BrandEntityMapper extends BaseDataMapper<BrandModel, BrandEntity> {
  @override
  BrandEntity mapToEntity(BrandModel? data) {
    return BrandEntity(
      id: data?.id,
      image: data?.image,
      title: data?.title ?? '',
      isSystem: data?.systemData?.code == 'ADMIN' ? true : false,
      code: data?.code ?? '',
      products: data?.product ?? [],
      groups: data?.group ?? [],
      productGroupQuantity: data?.productGroupQuantity ?? 0,
    );
  }
}
