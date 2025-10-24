import 'package:dio/dio.dart';
import 'package:one_click/data/models/category_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';

abstract class ProductCategoryRepository {
  Future<Response> getList({
    String? search,
    int? page,
  });

  Future<CategoryDetailEntity> getProductCategoryDetail(int id);

  Future<BaseResponseModel<CategoryDetailModel>> createProductCategory(
    String title,
    List<int> groups,
  );

  Future<BaseResponseModel<CategoryDetailModel>> updateProductCategory(
    int id,
    String title,
    List<int> groups,
  );
}
