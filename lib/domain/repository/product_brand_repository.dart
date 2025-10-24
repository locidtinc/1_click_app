import 'dart:io';

import 'package:dio/dio.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';

abstract class ProductBrandRepository {
  Future<Response> getList({
    int? page,
    String? search,
  });

  Future<BrandDetailEntity> getBrandDetail(int id);

  Future<BaseResponseModel<BrandDetailEntity>> updateProductBrand(
    int id,
    String title,
    List<int> product,
    File? image,
  );
}
