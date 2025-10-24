import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/type_discount_model.dart';
import 'package:one_click/data/models/response/base_response.dart';

import '../../domain/repository/promotion_repository.dart';

@LazySingleton(as: PromotionRepository)
class PromotionRepositoryImpl extends PromotionRepository {
  final BaseDio _baseDio;
  PromotionRepositoryImpl(this._baseDio);
  @override
  Future<BaseResponseModel<List<TypeDiscountModel>>> typeDiscount() async {
    try {
      final res = await _baseDio.dio().get(Api.promotionType);
      final listModel = (res.data['data'] as List)
          .map((e) => TypeDiscountModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: listModel,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
