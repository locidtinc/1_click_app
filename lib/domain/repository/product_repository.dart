import 'package:dio/dio.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/entity/product_preview.dart';

import '../../data/models/response/base_response.dart';

abstract class ProductRepository {
  Future<List<ProductPreviewEntity>> getList({
    required int page,
    required int limit,
    required String keySearch,
    int? account,
    bool? brandIsnull,
    String? systemCode,
    String? barcode,

    ///id warehouse account
    int? variantAmountWarehouse,
    int? excludeVariantAmountWarehouse,
    String? statusOnline,
    bool? statusProduct,
    int? warehouseId,
  });
  Future<List<ProductPreviewEntity>> getProductSuggest({
    required int page,
    required int limit,
    required String keySearch,
    int? account,
    bool? brandIsnull,
    String? systemCode,
    String? barcode,

    ///id warehouse account
    int? variantAmountWarehouse,
    int? excludeVariantAmountWarehouse,
    String? statusOnline,
    bool? statusProduct,
    int? warehouseId,
    String? search,
  });

  Future<ProductDetailEntity> getDetail({required int productId});
  Future<ProductDetailEntity> getProductDetailV2({required int productId});

  Future<BaseResponseModel<ProductModel>> createProduct(FormData payload);

  Future<BaseResponseModel<ProductModel>> editProduct(FormData payload, int id);

  Future<BaseResponseModel<bool>> deleteProduct(int productId);

  Future<BaseResponseModel<List<ProductModel>>> getByQrcode(String qrcode);
}
