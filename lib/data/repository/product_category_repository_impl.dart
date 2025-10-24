import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/mapper/product_category_mapper.dart';
import 'package:one_click/data/models/category_model.dart';
import 'package:one_click/data/models/product_category_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';
import 'package:one_click/domain/repository/product_category_repository.dart';

@LazySingleton(as: ProductCategoryRepository)
class ProductCategoryRepositoryImpl extends ProductCategoryRepository {
  ProductCategoryRepositoryImpl(this._mapper, this._baseDio);

  final ProductCategoryMapper _mapper;
  final BaseDio _baseDio;

  @override
  Future<Response> getList({String? search, int? page}) async {
    final res =
        await _baseDio.dio().get('${Api.productCategory}?page=$page&search=');
    return res;
  }

  @override
  Future<CategoryDetailEntity> getProductCategoryDetail(int id) async {
    final res = await _baseDio.dio().get('${Api.productCategory}$id/');
    final dataModel =
        ProductCategoryModel.fromJson(res.data['data']['category']);
    return _mapper.mapToEntity(dataModel);
  }

  @override
  Future<BaseResponseModel<CategoryDetailModel>> createProductCategory(
    String title,
    List<int> groups,
  ) async {
    try {
      final body = {
        'title': title,
        'group': groups,
      };
      final res = await _baseDio.dio().post(Api.productCategory, data: body);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: CategoryDetailModel.fromJson(res.data['data']),
      );
    } on DioError catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.statusMessage,
      );
    }
  }

  @override
  Future<BaseResponseModel<CategoryDetailModel>> updateProductCategory(
    int id,
    String title,
    List<int> groups,
  ) async {
    try {
      final body = {
        'title': title,
        'group': groups,
      };
      final res = await _baseDio
          .dio()
          .put('${Api.productCategory}$id/', data: jsonEncode(body));
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: CategoryDetailModel.fromJson(res.data['data']),
      );
    } on DioError catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.statusMessage,
      );
    }
  }
}
