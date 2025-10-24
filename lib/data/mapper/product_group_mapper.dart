import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/mapper/product_model_mapper.dart';
import 'package:one_click/data/models/product_group_model.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';

@injectable
class ProductGroupMapper
    extends BaseDataMapper<ProductGroupModel, GroupDetailEntity> {
  ProductGroupMapper(this._productModelMapper);

  final ProductModelMapper _productModelMapper;

  @override
  GroupDetailEntity mapToEntity(ProductGroupModel? data) {
    return GroupDetailEntity(
      id: data?.id,
      title: data?.title ?? '',
      code: data?.code ?? '',
      isAdminCreated: data?.system == 1 ? true : false,
      category: data?.category != null
          ? data?.category!.map((e) => e.title ?? '').toList()
          : [],
      productCategory: data?.category != null && data!.category!.isNotEmpty
          ? data.category!.first.id ?? 1
          : 1,
      account: data?.account ?? 0,
      products: _productModelMapper.mapToListEntity(data?.productData),
    );
  }
}
