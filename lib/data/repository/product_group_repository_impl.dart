import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/product_group_mapper.dart';
import 'package:one_click/data/models/product_group_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/usecase/group_create_use_case.dart';

import '../../domain/repository/product_group_repository.dart';
import '../apis/base_dio.dart';
import '../apis/end_point.dart';

@LazySingleton(as: ProductGroupRepository)
class ProductGroupRepositoryImpl extends ProductGroupRepository {
  ProductGroupRepositoryImpl(this._baseDio, this._productGroupMapper);

  final ProductGroupMapper _productGroupMapper;
  final BaseDio _baseDio;

  @override
  Future<Response> getList() async {
    final res = await _baseDio.dio().get(Api.productGroup);
    return res;
  }

  @override
  Future<GroupDetailEntity> getProductGroupDetail(int id) async {
    final res = await _baseDio.dio().get('${Api.productGroup}$id/');
    final dataModel = ProductGroupModel.fromJson(res.data['data']);
    return _productGroupMapper.mapToEntity(dataModel);
  }

  @override
  Future<BaseResponseModel<GroupDetailEntity>> updateProductGroup(
    int id,
    GroupCreateInput payload,
  ) async {
    try {
      final body = {
        'title': payload.title,
        'product': payload.product,
        'product_category': payload.productCategory,
      };
      final res =
          await _baseDio.dio().put('${Api.productGroup}$id/', data: body);
      final dataModel = ProductGroupModel.fromJson(res.data['data']);
      final groups = _productGroupMapper.mapToEntity(dataModel);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: groups,
      );
    } on DioError catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.statusMessage,
      );
    }
  }
}
