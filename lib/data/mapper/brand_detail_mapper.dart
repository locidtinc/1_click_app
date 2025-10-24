import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/mapper/product_model_mapper.dart';
import 'package:one_click/data/models/brand_detail_model.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';

@injectable
class BrandDetailMapper
    extends BaseDataMapper<BrandDetailModel, BrandDetailEntity> {
  BrandDetailMapper(this._productModelMapper);

  final ProductModelMapper _productModelMapper;

  @override
  BrandDetailEntity mapToEntity(BrandDetailModel? data) {
    return BrandDetailEntity(
      id: data?.id ?? 0,
      title: data?.title ?? '',
      isSystem: data?.systemData?.code == 'ADMIN' ? true : false,
      image: data?.image,
      account: data?.account ?? 0,
      isAdminCreated: data?.systemData?.code == 'ADMIN' ? true : false,
      products: _productModelMapper.mapToListEntity(data?.productData ?? []),
    );
  }
}
