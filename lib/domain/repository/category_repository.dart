import 'dart:io';

import 'package:one_click/data/models/category_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_state.dart';

import '../../data/models/brand_model.dart';
import '../../data/models/product_group_model.dart';
import '../usecase/brand_create_use_case.dart';

abstract class CategoryRepository {
  Future<BaseResponseModel<List<T>>> getListCategory<T>({
    required TypeCategory data,
    required int page,
    required int limit,
    required String searchKey,
    required String code,
  });

  Future<BaseResponseModel<ProductGroupModel>> createGroup({
    String? title,
    List<int>? product,
    int? productCategory,
  });

  Future<BaseResponseModel<BrandModel>> createBrand({
    required String title,
    required List<int> product,
    required List<int> group,
    required File? image,
    required List<ProductBrand> productBrand,
  });

  Future<BaseResponseModel<CategoryDetailModel>> categoryDetail({
    required int id,
  });

  Future<BaseResponseModel<bool>> deleteProductItem(int id, String endPoint);
}
