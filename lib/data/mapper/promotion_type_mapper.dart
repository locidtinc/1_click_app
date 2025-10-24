import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/domain/entity/promotion_type.dart';

import '../models/type_discount_model.dart';

@injectable
class PromotionTypeEntityMapper
    extends BaseDataMapper<TypeDiscountModel, PromotionTypeEntity> {
  @override
  PromotionTypeEntity mapToEntity(TypeDiscountModel? data) {
    return PromotionTypeEntity(
      id: data?.id,
      title: data?.title ?? '',
      code: data?.code ?? '',
    );
  }
}
