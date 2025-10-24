import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/product_category_model.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';
import 'package:one_click/domain/entity/group_entity.dart';

@injectable
class ProductCategoryMapper
    extends BaseDataMapper<ProductCategoryModel, CategoryDetailEntity> {
  @override
  CategoryDetailEntity mapToEntity(ProductCategoryModel? data) {
    return CategoryDetailEntity(
      id: data?.id ?? 0,
      title: data?.title ?? '',
      account: data?.account ?? 0,
      isSystem: data?.systemData?.code == 'ADMIN' ? true : false,
      groups: data!.groupData != null
          ? data.groupData!
              .map(
                (e) => GroupEntity(
                  id: e.id ?? 0,
                  title: e.title ?? '',
                  code: e.code ?? '',
                  account: e.account ?? 0,
                  productQuantity: e.productQuantity ?? 0,
                ),
              )
              .toList()
          : [],
    );
  }
}
