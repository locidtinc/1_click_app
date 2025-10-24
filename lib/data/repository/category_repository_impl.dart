import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/brand_model.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_state.dart';
import 'package:one_click/data/models/response/base_response.dart';

import '../../domain/repository/category_repository.dart';
import '../../domain/usecase/brand_create_use_case.dart';
import '../models/category_model.dart';
import '../models/product_group_model.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl extends CategoryRepository {
  final BaseDio _baseDio;

  CategoryRepositoryImpl(this._baseDio);

  @override
  Future<BaseResponseModel<List<T>>> getListCategory<T>({
    required TypeCategory data,
    required int page,
    required int limit,
    required String searchKey,
    required String code,
  }) async {
    final res = await _baseDio.dio().get(
          '${Api.category}/${data.endPoint}?page=$page&limit=$limit&title__icontains=$searchKey${code == 'ALL' ? '' : '&system__code=$code'}',
        );
    late List<T> responseData;
    switch (T) {
      case BrandModel:
        responseData = (res.data['data'] as List)
            .map((e) => BrandModel.fromJson(e))
            .toList() as List<T>;
        break;
      default:
    }
    return BaseResponseModel<List<T>>(
      code: res.statusCode,
      message: res.statusMessage,
      data: responseData,
    );
  }

  @override
  Future<BaseResponseModel<BrandModel>> createBrand({
    required String title,
    required List<int> product,
    required List<int> group,
    required File? image,
    required List<ProductBrand> productBrand,
  }) async {
    final map = {
      'brand': {'title': title},
      'product': product,
      'product_brand': productBrand.map((e) => e.toJson()).toList(),
    };
    if (product.isEmpty) {
      map.remove('product');
    }
    final formData = FormData.fromMap({'data': jsonEncode(map)});

    if (image != null) {
      formData.files
          .add(MapEntry('media', await MultipartFile.fromFile(image.path)));
    }

    try {
      final res = await _baseDio.dio().post(Api.brand, data: formData);
      return BaseResponseModel<BrandModel>(
        code: res.data['code'],
        message: res.statusMessage,
        data: BrandModel.fromJson(res.data['data']),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<ProductGroupModel>> createGroup({
    String? title,
    List<int>? product,
    int? productCategory,
  }) async {
    final Map<String, dynamic> data = {
      'productgroup': {
        'title': title,
        'product': product,
      },
    };
    if (productCategory != null) {
      data['productcategory'] = productCategory;
    }
    final res = await _baseDio.dio().post(Api.group, data: data);
    return BaseResponseModel<ProductGroupModel>(
      code: res.data['code'],
      message: res.data['message'],
      data: res.data['code'] == 200
          ? ProductGroupModel.fromJson(res.data['data'])
          : null,
    );
  }

  @override
  Future<BaseResponseModel<CategoryDetailModel>> categoryDetail({
    required int id,
  }) async {
    final res = await _baseDio.dio().get('${Api.category}/productcategory/$id');
    return BaseResponseModel(
      code: res.data['code'],
      message: res.data['message'],
      data: res.data['code'] == 200
          ? CategoryDetailModel.fromJson(res.data['data']['category'])
          : null,
    );
  }

  @override
  Future<BaseResponseModel<bool>> deleteProductItem(
    int id,
    String endPoint,
  ) async {
    try {
      final res = await _baseDio.dio().delete('${Api.category}/$endPoint/$id/');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.statusMessage,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
