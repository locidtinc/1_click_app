import 'package:one_click/data/models/response/base_response.dart';

import '../../data/models/type_discount_model.dart';

abstract class PromotionRepository {
  Future<BaseResponseModel<List<TypeDiscountModel>>> typeDiscount();
}
