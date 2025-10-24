import 'package:one_click/data/models/inventory_model_v2.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/data/models/receipt_import_detail_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'package:one_click/domain/usecase/import_receipt_use_case.dart';
import 'package:one_click/domain/usecase/list_warehouse_use_case.dart';
import 'package:one_click/domain/usecase/warehouse_use_case.dart';

abstract class WarehouseRepository {
  // Future<BaseResponseModel<int>> create(Map<String, dynamic> payload);

  // Future<BaseResponseModel<WarehouseModel>> detail({required int id});

  // Future<BaseResponseModel<WarehouseModel>> update({
  //   required int id,
  //   required Map<String, dynamic> payload,
  // });

  // Future<BaseResponseModel<List<VariantWarehouseModel>>> getVariantList(
  //   VariantListInput input,
  // );

  Future<BaseResponseModel<List<ProductModel>>> getProductWarehouse(
    int idWarehouse,
  );

  // Future<BaseResponseModel<List<WarehouseModel>>> getList(WarehouseInput input);

  // Future<BaseResponseModel<List<TicketModel>>> getListTicket({
  //   required int company,
  //   int? page,
  //   int? limit,
  //   String? search,
  // });

  // Future<BaseResponseModel> updateTicketStatus(int id, String status);

  // Future<dynamic> getTicket(int id);
  Future<BaseResponseModel<List<WarehouseModel>>> getListWareHouse(
    ListWarehouseInput input,
  );
  Future<BaseResponseModel<List<InventoryModelV2>>> getListInventory(
    InventoryInputV2 input,
  );

  // Future<BaseResponseModel<List<ReceitExportModel>>> getListImportReceipt(
  //   ImportReceiptInput input,
  // );

  // Future<BaseResponseModel<List<ReceiptImportDetailModel>>> getListLot(
  //   ReceiptDetailInput input,
  // );

  // Future<BaseResponseModel<ReceitExportModel>> getReceiptInfor(
  //   ReceiptDetailInput input,
  // );

  // Future<BaseResponseModel<List<ProductV3Model>>> getProductsWarehouse(
  //   ProductsWarehouseInput input,
  // );

  Future<BaseResponseModel> createReceipt(CreateReceiptInput input);

  // Future<BaseResponseModel<List<UserDataModel>>> getListUserWarehouse(
  //   int workspace,
  // );
  // Future<BaseResponseModel<List<ProductV3Model>>> getProductsFromAI(
  //     FetchPrdsFromAIInput input,);
}
