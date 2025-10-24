import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/mapper/product_detail_mapper.dart';
import 'package:one_click/data/mapper/product_model_mapper.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/presentation/di/di.dart';

import '../../domain/repository/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(
    this._productModelMapper,
    this._productDetailMapper,
    this._baseDio,
  );

  final ProductModelMapper _productModelMapper;
  final ProductDetailMapper _productDetailMapper;
  final BaseDio _baseDio;

  @override
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
  }) async {
    final param = {
      'page': page,
      'limit': limit,
      'title__icontains': keySearch,
      'barcode__icontains': barcode,
      'account': account,
      'brand__isnull': brandIsnull,
      'system__code': systemCode,
      'status_online__icontains': statusOnline,
      'status_product': statusProduct,
      // 'variant__amount__warehouse': variantAmountWarehouse,
      'exclude_variant__amount__warehouse': excludeVariantAmountWarehouse,
      // 'variant__amount__warehouse': warehouseId,
    };
    if (warehouseId == null) {
      param['variant__amount__warehouse'] = warehouseId;
    } else {
      param['variant__amount__warehouse'] = variantAmountWarehouse;
    }
    param.removeWhere((key, value) => value == null);
    final res = await _baseDio.dio().get(Api.product, queryParameters: param);
    final dataModel = (res.data['data'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
    return _productModelMapper.mapToListEntity(dataModel);
  }

  @override
  Future<BaseResponseModel<ProductModel>> createProduct(
    FormData payload,
  ) async {
    try {
      final res = await _baseDio.dio().post(Api.product, data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['code'] == 200
            ? ProductModel.fromJson(res.data['data'])
            : null,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: '$e',
        data: null,
      );
    }
  }

  @override
  Future<ProductDetailEntity> getDetail({required int productId}) async {
    final res = await _baseDio.dio().get('${Api.variant}$productId/');
    final dataModel = ProductModel.fromJson(res.data['data']);
    return _productDetailMapper.mapToEntity(dataModel);
  }

  @override
  Future<ProductDetailEntity> getProductDetailV2(
      {required int productId}) async {
    final res = await _baseDio.dio().get('${Api.product}$productId/');
    final dataModel = ProductModel.fromJson(res.data['data']);
    return _productDetailMapper.mapToEntity(dataModel);
  }

  @override
  Future<BaseResponseModel<bool>> deleteProduct(int productId) async {
    try {
      final res = await getIt
          .get<BaseDio>()
          .dio()
          .delete('${Api.productDetail}$productId/');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['code'] == 200 ? true : false,
      );
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString(), data: false);
    }
  }

  @override
  Future<BaseResponseModel<ProductModel>> editProduct(
    FormData payload,
    int id,
  ) async {
    try {
      final res = await _baseDio.dio().put('${Api.product}$id/', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['code'] == 200
            ? ProductModel.fromJson(res.data['data'])
            : null,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: 'oopp lỗi rồi còn đâu',
        data: null,
      );
    }
  }

  @override
  Future<BaseResponseModel<List<ProductModel>>> getByQrcode(
    String qrcode,
  ) async {
    if (qrcode.isEmpty) {
      return BaseResponseModel(
        code: 200,
        data: [],
      );
    }
    try {
      final res = await _baseDio.dio().get('${Api.productScan}/$qrcode');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: (res.data['data'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  @override
  Future<List<ProductPreviewEntity>> getProductSuggest({
    required int page,
    required int limit,
    required String keySearch,
    int? account,
    bool? brandIsnull,
    String? systemCode,
    String? barcode,
    String? search,
    int? variantAmountWarehouse,
    int? excludeVariantAmountWarehouse,
    String? statusOnline,
    bool? statusProduct,
    int? warehouseId,
  }) async {
    final res = await _baseDio.dio().get(
        // '${Api.productSuggest}?page=$page&limit=$limit&title__icontains=$keySearch&barcode__icontains=$barcode${account != null ? '&account=$account' : ''}${brandIsnull != null ? '&brand__isnull=$brandIsnull' : ''}${systemCode != null ? '&system__code=$systemCode' : ''}${statusOnline != null ? '&status_online__icontains=$statusOnline' : ''}${statusProduct != null ? '&status_product=$statusProduct' : ''}${variantAmountWarehouse != null ? '&variant__amount__warehouse=$variantAmountWarehouse' : ''}${excludeVariantAmountWarehouse != null ? '&exclude_variant__amount__warehouse=$excludeVariantAmountWarehouse' : ''}${warehouseId == null ? '' : '&variant__amount__warehouse=$warehouseId'}',
        '${Api.productSuggest}?page=$page&limit=$limit'
        '${search != null ? '&search=$search' : '${keySearch != null ? '&title__icontains=$keySearch' : ''}${barcode != null ? '&barcode__icontains=$barcode' : ''}'}'
        '${account != null ? '&account=$account' : ''}'
        '${brandIsnull != null ? '&brand__isnull=$brandIsnull' : ''}'
        '${systemCode != null ? '&system__code=$systemCode' : ''}'
        '${statusOnline != null ? '&status_online__icontains=$statusOnline' : ''}'
        '${statusProduct != null ? '&status_product=$statusProduct' : ''}'
        '${variantAmountWarehouse != null ? '&variant__amount__warehouse=$variantAmountWarehouse' : ''}'
        '${excludeVariantAmountWarehouse != null ? '&exclude_variant__amount__warehouse=$excludeVariantAmountWarehouse' : ''}'
        '${warehouseId != null ? '&variant__amount__warehouse=$warehouseId' : ''}');
    final dataModel = (res.data['data'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
    return _productModelMapper.mapToListEntity(dataModel);
  }
}
