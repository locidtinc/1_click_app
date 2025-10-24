import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/mapper/product_shipments_mapper.dart';
import 'package:one_click/data/mapper/shipments_infor_mapper.dart';
import 'package:one_click/data/mapper/variant_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/store_model/product_shipments_model.dart';
import 'package:one_click/data/models/store_model/shipments_infor_model.dart';
import 'package:one_click/data/models/variant_model.dart';
import 'package:one_click/domain/entity/product_shipments_entity.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../domain/repository/variant_repository.dart';

@LazySingleton(as: VariantRepository)
class VariantRepositoryImpl extends VariantRepository {
  VariantRepositoryImpl(this._dio, this._mapper, this._mapperProductShipment,
      this._mapperShipmentInfor);

  final BaseDio _dio;
  final VariantDetailMapper _mapper;
  final ProductShipmentsMapper _mapperProductShipment;
  final ShipmentsInforMapper _mapperShipmentInfor;

  @override
  Future<BaseResponseModel<List<VariantModel>>> getList(
    int page,
    int limit,
    String searchKey,
    String? accountSystemCode,
    bool? status,
  ) async {
    try {
      final idWarehouse =
          AppSharedPreference.instance.getValue(PrefKeys.warehouseId);
      final payload = {
        'page': page,
        'limit': limit,
        'title__icontains': searchKey,
        'account__system__code': accountSystemCode,
        if (accountSystemCode == null) 'amount__warehouse': idWarehouse,
        'status': status,
      };
      payload.removeWhere((key, value) => value == null);
      final res = await _dio.dio().get(
            Api.variant,
            queryParameters: payload,
          );
      final dataModel = (res.data['data'] as List)
          .map((e) => VariantModel.fromJson(e))
          .toList();
      return BaseResponseModel<List<VariantModel>>(
        code: res.statusCode,
        message: res.statusMessage,
        data: dataModel,
      );
    } catch (e) {
      return BaseResponseModel<List<VariantModel>>(
        code: 500,
        message: e.toString(),
        data: [],
      );
    }
  }

  @override
  Future<BaseResponseModel<List<VariantModel>>> getListDepartment(
    int page,
    int limit,
    String searchKey,
    String? accountSystemCode,
    bool? status,
  ) async {
    try {
      final idWarehouse =
          AppSharedPreference.instance.getValue(PrefKeys.warehouseId);
      final payload = {
        'page': page,
        'limit': limit,
        'title__icontains': searchKey,
        'account__system__code': accountSystemCode,
        if (accountSystemCode == null) 'amount__warehouse': idWarehouse,
        'status': status,
      };
      payload.removeWhere((key, value) => value == null);
      final res = await _dio.dio().get(
            Api.variantDepartment,
            queryParameters: payload,
          );
      final dataModel = (res.data['data'] as List)
          .map((e) => VariantModel.fromJson(e))
          .toList();
      return BaseResponseModel<List<VariantModel>>(
        code: res.statusCode,
        message: res.statusMessage,
        data: dataModel,
        extra: res.data['count'],
      );
    } catch (e) {
      return BaseResponseModel<List<VariantModel>>(
        code: 500,
        message: e.toString(),
        data: [],
      );
    }
  }

  @override
  Future<BaseResponseModel<List<VariantModel>>> getByScanBarcode(
    String barcode,
  ) async {
    print('QRRRR');
    final res = await _dio.dio().get('${Api.variantScan}$barcode');
    print('res $res');
    List<VariantModel> dataModel = [];
    if (res.data['code'] == 200) {
      dataModel = (res.data['data'] as List)
          .map((e) => VariantModel.fromJson(e))
          .toList();
    }
    return BaseResponseModel<List<VariantModel>>(
      code: res.data['code'],
      message: res.data['message'],
      data: dataModel
          .where((e) => e.status != false && e.quantityInStock != 0)
          .toList(),
    );
  }

  @override
  Future<BaseResponseModel<VariantEntity>> getVariantDetail(int id) async {
    final res = await _dio.dio().get('${Api.variant}$id/');
    VariantModel? dataModel;
    if (res.data['code'] == 200) {
      dataModel = VariantModel.fromJson(res.data['data']);
    }
    return BaseResponseModel<VariantEntity>(
      code: res.data['code'],
      message: res.data['message'],
      data: _mapper.mapToEntity(dataModel),
    );
  }

  @override
  Future<BaseResponseModel> updateVariant(int id, FormData payload) async {
    try {
      final res = await _dio.dio().put('${Api.variant}$id/', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data'],
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
  Future<BaseResponseModel<List<VariantModel>>> getListPromotion({
    required int page,
    required int limit,
    required String searchKey,
  }) async {
    final res = await _dio.dio().get(
          '${Api.variantPromotion}?limit=$limit&page=$page&title__icontains=$searchKey',
        );
    return BaseResponseModel(
      code: res.data['code'],
      message: res.data['message'],
      data: (res.data['data'] as List)
          .map((e) => VariantModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Future<BaseResponseModel<List<ProductShipmentsEntity>>> getProdShipments({
    required int id,
  }) async {
    try {
      final res = await _dio.dio().get('${Api.prdShipments}/$id');
      final data = (res.data['data'] as List)
          .map((e) => ProductShipmentsModel.fromJson(e))
          .toList();
      final extra = ShipmentsInforModel.fromJson(res.data['bonus']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: _mapperProductShipment.mapToListEntity(data),
        extra: _mapperShipmentInfor.mapToEntity(extra),
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }
}
