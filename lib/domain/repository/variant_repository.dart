import 'package:dio/dio.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/store_model/product_shipments_model.dart';
import 'package:one_click/domain/entity/product_shipments_entity.dart';
import 'package:one_click/domain/entity/variant_entity.dart';

import '../../data/models/variant_model.dart';

abstract class VariantRepository {
  Future<BaseResponseModel<List<VariantModel>>> getList(
    int page,
    int limit,
    String searchKey,
    String? accountSystemCode,
    bool? status,
  );

  Future<BaseResponseModel<List<VariantModel>>> getByScanBarcode(
    String barcode,
  );
  Future<BaseResponseModel<List<VariantModel>>> getListDepartment(
    int page,
    int limit,
    String searchKey,
    String? accountSystemCode,
    bool? status,
  );

  Future<BaseResponseModel<VariantEntity>> getVariantDetail(int id);

  Future<BaseResponseModel> updateVariant(int id, FormData payload);
  Future<BaseResponseModel<List<VariantModel>>> getListPromotion({
    required int page,
    required int limit,
    required String searchKey,
  });
  Future<BaseResponseModel<List<ProductShipmentsEntity>>> getProdShipments({
    required int id,
  });
}
