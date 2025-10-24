import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/mapper/brand_detail_mapper.dart';
import 'package:one_click/data/models/brand_detail_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';
import 'package:one_click/domain/repository/product_brand_repository.dart';

@LazySingleton(as: ProductBrandRepository)
class ProductBrandRepositoryImpl extends ProductBrandRepository {
  ProductBrandRepositoryImpl(this._baseDio, this._mapper);

  final BaseDio _baseDio;
  final BrandDetailMapper _mapper;

  @override
  Future<Response> getList({int? page, String? search}) async {
    final res = await _baseDio
        .dio()
        .get('${Api.productBrand}?page=$page&title__icontains=$search');
    return res;
  }

  @override
  Future<BrandDetailEntity> getBrandDetail(int id) async {
    final res = await _baseDio.dio().get('${Api.productBrand}$id/');
    final dataModel = BrandDetailModel.fromJson(res.data['data']['brand']);
    return _mapper.mapToEntity(dataModel);
  }

  @override
  Future<BaseResponseModel<BrandDetailEntity>> updateProductBrand(
    int id,
    String title,
    List<int> product,
    File? image,
  ) async {
    try {
      final map = {
        'title': title,
        'product': product,
      };
      if (product.isEmpty) {
        map.remove('product');
      }
      final formData = FormData.fromMap({'data': jsonEncode(map)});

      if (image != null) {
        formData.files
            .add(MapEntry('media', await MultipartFile.fromFile(image.path)));
      }
      final res = await _baseDio.dio().put(
            '${Api.productBrand}$id/',
            data: formData,
          );
      final dataModel = BrandDetailModel.fromJson(res.data['data']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: _mapper.mapToEntity(dataModel),
      );
    } on DioError catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.statusMessage,
      );
    }
  }
}
