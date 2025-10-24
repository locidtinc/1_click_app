import 'dart:convert';

import 'package:cross_file/src/types/interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/inventory_model_v2.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/data/models/receipt_import_detail_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'package:one_click/domain/repository/warehouse_repository.dart';
import 'package:one_click/domain/usecase/import_receipt_use_case.dart';
import 'package:one_click/domain/usecase/list_warehouse_use_case.dart';
import 'package:one_click/domain/usecase/warehouse_use_case.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

@LazySingleton(as: WarehouseRepository)
class WarehouseRepositoryImpl extends WarehouseRepository {
  WarehouseRepositoryImpl(
    this._dio,
  );

  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<ProductModel>>> getProductWarehouse(
      int idWarehouse) {
    throw UnimplementedError();
  }

  // final BaseDioAI _dioAI;

  // @override
  // Future<BaseResponseModel<int>> create(
  //   Map<String, dynamic> payload,
  // ) async {
  //   try {
  //     payload.removeWhere((key, value) => value == null || value == '');
  //     final res = await _dio.dio().post(
  //       Api.warehouseList,
  //       data: payload,
  //     );
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: res.data['details'],
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(
  //       code: 400,
  //       message: e.toString(),
  //     );
  //   }
  // }

  // @override
  // Future<BaseResponseModel<List<WarehouseModel>>> getList(
  //   WarehouseInput input,
  // ) async {
  //   try {
  //     final query = {
  //       'page': input.page,
  //       'limit': input.limit,
  //       'company': input.company,
  //       'search': input.search,
  //     };
  //     final res = await _dio.dio().get(Api.warehouseList, data: query);
  //     final data = (res.data['data'] as List).map((e) => WarehouseModel.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<BaseResponseModel<List<TicketModel>>> getListTicket({
  //   required int company,
  //   int? page,
  //   int? limit,
  //   String? search,
  // }) async {
  //   try {
  //     final query = {
  //       'page': page,
  //       'limit': limit,
  //       'company': company,
  //       'search': search,
  //     };
  //     final res = await _dio.get(Api.ticketList, data: query);
  //     final data = (res.data['details'] as List).map((e) => TicketModel.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<dynamic> getTicket(int id) async {
  //   try {
  //     return await _dio.get('${Api.ticketDetail}$id');
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     return null;
  //   }
  // }

  // @override
  // Future<BaseResponseModel<List<VariantWarehouseModel>>> getVariantList(
  //   VariantListInput input,
  // ) async {
  //   try {
  //     final query = {
  //       'page': input.page,
  //       'limit': input.limit,
  //       'company': input.company,
  //       'search': input.search,
  //     };
  //     final res = await _dio.get(Api.variantList, data: query);
  //     final data = (res.data['details'] as List).map((e) => VariantWarehouseModel.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<BaseResponseModel> updateTicketStatus(int id, String status) async {
  //   try {
  //     final query = {'id': id, 'status': status, 'note': ''};
  //     final res = await _dio.put(Api.ticketStatus, data: query);
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //     );
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<BaseResponseModel<WarehouseModel>> detail({required int id}) async {
  //   try {
  //     final res = await _dio.get('${Api.warehouse}/detail/$id');
  //     final data = WarehouseModel.fromJson(res.data['details']);
  //     return BaseResponseModel<WarehouseModel>(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     return BaseResponseModel(
  //       code: 400,
  //       message: e.toString(),
  //     );
  //   }
  // }

  // @override
  // Future<BaseResponseModel<WarehouseModel>> update({
  //   required int id,
  //   required Map<String, dynamic> payload,
  // }) async {
  //   try {
  //     final res = await _dio.put(
  //       '${Api.warehouse}/detail/$id',
  //       data: payload,
  //     );
  //     return BaseResponseModel<WarehouseModel>(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //     );
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     return BaseResponseModel(
  //       code: 400,
  //       message: e.toString(),
  //     );
  //   }
  // }

  // @override
  // Future<BaseResponseModel<List<ProductModel>>> getProductWarehouse(
  //   int idWarehouse,
  // ) async {
  //   try {
  //     final res = await _dio.dio().get(
  //       '${Api.warehouseList}/product?warehouse=$idWarehouse',
  //     );
  //     final data = (res.data['data'] as List).map((e) => ProductModel.fromJson(e)).toList();
  //     return BaseResponseModel<List<ProductModel>>(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     return BaseResponseModel(
  //       code: 400,
  //       message: e.toString(),
  //     );
  //   }
  // }

  @override
  Future<BaseResponseModel<List<WarehouseModel>>> getListWareHouse(
    ListWarehouseInput input,
  ) async {
    try {
      final idWarehouse =
          AppSharedPreference.instance.getValue(PrefKeys.warehouseId);
      final query = {
        'connect_system': 'MYKIOS',
        // 'exp_date': input.expired,
      };
      query.removeWhere((key, value) => value == null);
      final res = await _dio
          .dio()
          .get('${Api.warehouseList}$idWarehouse/', data: query);
      final data = (WarehouseModel.fromJson(res.data['data']));
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: [data],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<InventoryModelV2>>> getListInventory(
    InventoryInputV2 input,
  ) async {
    try {
      final query = {
        'limit': input.limit,
        'search': input.search,
        'warehouse_id': input.id,
        'connect_system': 'MYKIOS',
        'exp_date': input.expired,
        'workspace': input.workspace,
      };
      query.removeWhere((key, value) => value == null);
      final res =
          await _dio.dio().get(Api.reportWareHouse, queryParameters: query);
      final data = (res.data['data'] as List)
          .map((e) => InventoryModelV2.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  // @override
  // Future<BaseResponseModel<List<ReceitExportModel>>> getListImportReceipt(
  //   ImportReceiptInput input,
  // ) async {
  //   try {
  //     final query = {
  //       'page': input.page,
  //       'limit': 10,
  //       'search': input.search,
  //       'warehouse': input.id,
  //       'status__code': input.status,
  //     };
  //     query.removeWhere((key, value) => value == null);
  //     final res = await _dio.get(Api.importReceipts, data: query);
  //     final data = (res.data['data'] as List).map((e) => ReceitExportModel.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<BaseResponseModel<List<ReceiptImportDetailModel>>> getListLot(
  //   ReceiptDetailInput input,
  // ) async {
  //   try {
  //     final query = {
  //       'warehouse_import': input.warehouseId,
  //       'import_receipt': input.id,
  //     };
  //     query.removeWhere((key, value) => value == null);
  //     final res = await _dio.get(Api.importReceiptDetail, data: query);
  //     final data = (res.data['data'] as List).map((e) => ReceiptImportDetailModel.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<BaseResponseModel<ReceitExportModel>> getReceiptInfor(
  //   ReceiptDetailInput input,
  // ) async {
  //   try {
  //     final res = await _dio.get('${Api.importReceiptInfor}/${input.id}');
  //     final data = ReceitExportModel.fromJson(res.data['data']);
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<BaseResponseModel<List<ProductV3Model>>> getProductsWarehouse(
  //   ProductsWarehouseInput input,
  // ) async {
  //   try {
  //     final payload = {
  //       'company': input.company,
  //       'search': input.search,
  //       'page': input.page,
  //     };
  //     payload.removeWhere((key, value) => value == null || value == '');
  //     final res = await _dio.get(
  //       Api.productList,
  //       data: payload,
  //     );
  //     final data = (res.data['details'] as List).map((e) => ProductV3Model.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     print('products: $e');
  //     return BaseResponseModel(
  //       code: 400,
  //       message: e.toString(),
  //       data: [],
  //     );
  //   }
  // }

  @override
  Future<BaseResponseModel> createReceipt(CreateReceiptInput input) async {
    try {
      final inputJson = (input.toJson());
      inputJson.removeWhere((key, value) => value == null || value == '');
      // final formData = FormData();
      // final payload = {'data': jsonEncode(inputJson)};
      // // final payload = jsonEncode(inputJson);
      // final FormData formData = FormData.fromMap(payload);
      // inputJson.forEach((key, value) {
      //   formData.fields.add(
      //     MapEntry(key, value is List || value is Map ? jsonEncode(value) : value.toString()),
      //   );
      // });
      // if (input.images != null) {
      //   for (final element in input.images!) {
      //     final image = await MultipartFile.fromFile(element.path);
      //     formData.files.add(MapEntry('files', image));
      //   }
      // }
      final res =
          await _dio.dio().post(Api.createImportReceipt, data: inputJson);
      if (res.data['code'] == 200) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['data'],
        );
      }
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  // @override
  // Future<BaseResponseModel<List<UserDataModel>>> getListUserWarehouse(
  //   int workspace,
  // ) async {
  //   try {
  //     final payload = {'workspace': workspace};
  //     final res = await _dio.get(Api.listUserWarehouse, data: payload);
  //     final data = (res.data['data'] as List).map((e) => UserDataModel.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }

  // @override
  // Future<BaseResponseModel<List<ProductV3Model>>> getProductsFromAI(
  //   FetchPrdsFromAIInput input,
  // ) async {
  //   try {
  //     final payload = {'workspace_id': input.workspaceId};
  //     final FormData formData = FormData.fromMap(payload);

  //     for (final element in input.imgs) {
  //       final image = await MultipartFile.fromFile(element.path);
  //       formData.files.add(MapEntry('file', image));
  //     }

  //     final res = await _dioAI.post(Api.prdsFromAI, data: formData);
  //     final data = (res.data['details'] as List).map((e) => ProductV3Model.fromJson(e)).toList();
  //     return BaseResponseModel(
  //       code: res.data['code'],
  //       message: res.data['message'],
  //       data: data,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return BaseResponseModel(code: 400, message: e.toString());
  //   }
  // }
}
