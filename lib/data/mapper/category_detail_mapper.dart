import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/category_model.dart';
import 'package:one_click/domain/entity/category_detail.dart';

@injectable
class CategoryDetailEntityMapper
    extends BaseDataMapper<CategoryDetailModel, CategoryDetailEntity> {
  @override
  CategoryDetailEntity mapToEntity(CategoryDetailModel? data) {
    return CategoryDetailEntity(
      id: data?.id,
      title: data?.title ?? '',
      code: data?.code ?? '',
      system: data?.system,
      account: data?.account,
      group: data?.group ?? [],
      product: data?.product ?? [],
      groupData: (data?.groupData ?? [])
          .map(
            (e) => GroupCategoryEntity(
              id: e.id,
              title: e.title ?? '',
              code: e.code ?? '',
              productQuantity: e.productQuantity ?? 0,
            ),
          )
          .toList(),
      isSystemAd: data?.systemData?.code == 'ADMIN',
      productgroupQuantity: data?.productgroupQuantity,
      createdAt: data?.createdAt,
    );
  }
}
