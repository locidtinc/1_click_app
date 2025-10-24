import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/receipt_import_detail_model.dart';
import 'package:one_click/data/models/unit_model.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'package:one_click/domain/entity/unit_entity.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/usecase/import_receipt_use_case.dart';
import 'package:one_click/domain/usecase/list_warehouse_use_case.dart';
import 'package:one_click/domain/usecase/variant_get_list_department_use_case.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/cubit/create_warehouse_receipt_state.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/delay_callback.dart';

@injectable
class CreateWarehouseReceiptCubit extends Cubit<CreateWarehouseReceiptState> {
  CreateWarehouseReceiptCubit(
    this._listWareHouseUseCase,
    this._variantGetListDepartmentUseCase,
    // this._productsWarehouseUseCase,
    this._importRecieptUseCase,
    // this._listUseWareHouseUseCase,
    // this._fetchPrdsFromAIUseCase,
  ) : super(const CreateWarehouseReceiptState());

  final GetListWareHouseUseCase _listWareHouseUseCase;
  final VariantGetListDepartmentUseCase _variantGetListDepartmentUseCase;
  // final ProductsWarehouseUseCase _productsWarehouseUseCase;
  final ImportRecieptUseCase _importRecieptUseCase;
  // final ListUseWareHouseUseCase _listUseWareHouseUseCase;
  // final FetchPrdsFromAIUseCase _fetchPrdsFromAIUseCase;

  final DelayCallBack delay = DelayCallBack(delay: 500.milliseconds);
  int _page = 1;

  void get warehouse {}

  void getListWareHouse() async {
    final input = ListWarehouseInput();
    final res = await _listWareHouseUseCase.getListV2(input);
    emit(
      state.copyWith(
        listWareHouse: res,
        warehouse: res.firstOrNull,
        status: BlocStatus.success,
      ),
    );
  }

  void totalPrice(List<ReceiptImportDetailModel> listShipment) {
    final total = listShipment.fold<num>(
      0,
      (pre, element) => pre + (element.variantData?.shipmentPrice ?? 0),
    );

    emit(state.copyWith(totalPrice: total));
  }

  void updateTotalPrice(num? value) {
    emit(state.copyWith(totalPrice: value));
  }

  void setCode(String? value) {
    emit(state.copyWith(code: value));
  }

  void setStartDate(String? value) {
    emit(state.copyWith(startDate: value));
  }

  void setReason(String? value) {
    emit(state.copyWith(reason: value));
  }

  void setProvider(String? value) {
    emit(state.copyWith(provider: value));
  }

  void setWareHouse(WarehouseModel? warehouse) {
    emit(state.copyWith(warehouse: warehouse));
  }

  // void getListUserWareHouse() async {
  //   final res = await _listUseWareHouseUseCase.getListUserWarehouse(getCompanyId ?? 0);
  //   emit(
  //     state.copyWith(
  //       listUser: res,
  //       userCheck: res.firstWhereOrNull((e) => e.id == getAccountId),
  //       status: BlocStatus.success,
  //     ),
  //   );
  // }
  Future<List<VariantEntity>> getListVariant(
    String search, {
    bool isMore = false,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));

    isMore ? _page++ : _page = 1;

    final input = VariantGetListDepartmentInput(
      page: _page,
      limit: state.limit ?? 10,
      searchKey: search,
    );
    final res = await _variantGetListDepartmentUseCase.execute(input);
    return res.responseEntity.data?.where((e) => e.status != false).toList()
        as List<VariantEntity>;
  }

  void addLot({VariantEntity? productData, bool isReload = true}) {
    final updated = [
      ...state.listShipment,
      ReceiptImportDetailModel(variantData: productData)
    ];
    emit(state.copyWith(
        listShipment: updated,
        status: isReload ? BlocStatus.reload : state.status));
  }

  void addProd(int index, VariantEntity? prod, {bool isReload = true}) {
    final updated = state.listShipment.asMap().entries.map((entry) {
      return index == entry.key
          ? entry.value.copyWith(variantData: prod)
          : entry.value;
    }).toList();
    emit(state.copyWith(
        listShipment: updated,
        status: isReload ? BlocStatus.reload : state.status));
  }

  void updateShipment(
    int index, {
    bool? isShow,
    int? inputQuantity,
    int? inputPrice,
    int? shipmentPrice,
    String? shipmentCode,
    DateTime? startDate,
    DateTime? endDate,
    bool? isDelete,
    UnitEntity? unit,
    bool isReload = true,
  }) {
    delay.debounce(() {
      print('unit===== $unit');
      final updated = state.listShipment.map(
        (shipment) {
          final indexShipment = state.listShipment.indexOf(shipment);
          if (index == indexShipment) {
            shipment = shipment.copyWith(
              code: shipmentCode ?? shipment.code,
              startDate: startDate ?? shipment.startDate,
              endDate: endDate ?? shipment.endDate,
              variantData: isDelete == true
                  ? null
                  : shipment.variantData?.copyWith(
                        inputQuantity: inputQuantity ??
                            shipment.variantData?.inputQuantity,
                        inputPrice:
                            inputPrice ?? shipment.variantData?.inputPrice,
                        shipmentPrice:
                            // shipmentPrice ??
                            ((inputPrice ??
                                    shipment.variantData?.inputPrice ??
                                    0) *
                                (inputQuantity ??
                                    shipment.variantData?.inputQuantity ??
                                    0)),
                        unitSell:
                            unit ?? shipment.variantData?.unit.firstOrNull,
                      ) ??
                      shipment.variantData,
              isExpand: isShow ?? true,
            );
          }
          return shipment;
        },
      ).toList();
      emit(state.copyWith(
          listShipment: updated,
          status: isReload ? BlocStatus.reload : state.status));
    });
  }

  // void updateShipmentV2(
  //   int index, {
  //   int? inputQuantity,
  //   num? inputPrice,
  //   num? shipmentPrice,
  //   UnitV3Model? unit,
  // }) {
  //   final updated = state.listShipment.mapIndexed((i, shipment) {
  //     if (i != index) return shipment;
  //     final data = shipment.productData;
  //     return shipment.copyWith(
  //       productData: data?.copyWith(
  //         inputQuantity: inputQuantity ?? data.inputQuantity,
  //         inputPrice: inputPrice ?? data.inputPrice,
  //         shipmentPrice: (inputPrice ?? data.inputPrice ?? 0) * (inputQuantity ?? data.inputQuantity ?? 0),
  //         unitSell: unit ?? data.unitSell,
  //       ),
  //     );
  //   }).toList();
  //   emit(state.copyWith(listShipment: updated));
  // }

  void deleteShipment(int index) {
    final updated = [...state.listShipment]..removeAt(index);
    emit(state.copyWith(listShipment: updated, status: BlocStatus.reload));
  }

  void createReceipt(BuildContext context) async {
    try {
      emit(state.copyWith(hasUpdate: false));
      DialogUtils.showLoadingDialog(context,
          content: 'Đang tạo phiếu nhập kho');
      final input = CreateReceiptInput(
        importReceipt: ImportReceiptModel(
          code: state.code,
          reason: state.reason,
          warehouse: state.warehouse?.id,
          totalPrice: state.totalPrice,
        ),
        shipment: state.listShipment
            .map(
              (e) => Shipment(
                code: e.code,
                startDate: e.startDate?.toText(fomat: 'yyyy-MM-dd'),
                endDate: e.endDate.toText(fomat: 'yyyy-MM-dd'),
                variant: e.variantData?.id,
                storageUnit: e.variantData?.unit.firstOrNull?.id,
                inputUnit: e.variantData?.unitSell?.id,
                importPrice: e.variantData?.inputPrice,
                totalImportPrice: e.variantData?.shipmentPrice,
                inputQuantity: e.variantData?.inputQuantity,
                warehouseImport: state.warehouse?.id,
                unit: e.variantData?.unit
                    .map((f) => UnitEntity(
                        id: f.id,
                        conversionValue: f.conversionValue,
                        level: f.level,
                        sellUnit: f.sellUnit,
                        storageUnit: f.storageUnit,
                        title: f.title))
                    .toList(),
              ),
            )
            .toList(),
        images: state.images,
      );
      final res = await _importRecieptUseCase.createReceipt(input);
      if (res.code == 200) {
        emit(
          state.copyWith(
            hasUpdate: true,
            listShipment: [],
            images: [],
            status: BlocStatus.submitSuccess,
          ),
        );
      } else {
        emit(state.copyWith(
            status: BlocStatus.submitFailure, msg: 'res.message'));
      }
    } catch (e) {
      context.pop();
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: e.toString()));
    }
  }

  // void addFiles(XFile element) {
  //   emit(state.copyWith(images: [...state.images, element], status: BlocStatus.reload));
  // }

  void removeFile(int index) {
    final updated = [...state.images]..removeAt(index);
    emit(state.copyWith(images: updated, status: BlocStatus.reload));
  }

  // void getPrdsFromAI(BuildContext context) async {
  //   try {
  //     DialogUtils.showLoadingDialog(context, 'Đang lấy thông tin sản phẩm trong phiếu xuất');
  //     final input = FetchPrdsFromAIInput(workspaceId: getCompanyId ?? 0, imgs: state.images);
  //     final output = await _fetchPrdsFromAIUseCase.execute(input);

  //     if (output.response.code == 200) {
  //       context.pop();
  //       final listPrdsAI = output.response.data ?? [];
  //       final listShipment = [...state.listShipment];

  //       while (listShipment.length < listPrdsAI.length) {
  //         listShipment.add(const ReceiptImportDetailModel());
  //       }

  //       for (var i = 0; i < listPrdsAI.length; i++) {
  //         final prd = listPrdsAI[i];
  //         listShipment[i] = listShipment[i].copyWith(productData: prd);

  //         final inputQuantity = int.tryParse(prd.quantityExtract ?? '');
  //         final inputPrice = num.tryParse(
  //           (prd.unitPriceExtract ?? '').replaceAll('.', '').replaceAll(',', '.'),
  //         );
  //         final shipmentPrice = num.tryParse(
  //           (prd.totalAmountExtract ?? '').replaceAll('.', '').replaceAll(',', '.'),
  //         );

  //         listShipment[i] = listShipment[i].copyWith(
  //           productData: prd.copyWith(
  //             inputQuantity: inputQuantity,
  //             inputPrice: inputPrice,
  //             shipmentPrice: shipmentPrice,
  //           ),
  //         );
  //       }

  //       emit(
  //         state.copyWith(
  //           listShipment: listShipment,
  //           listPrdsAI: listPrdsAI,
  //           status: BlocStatus.reload,
  //         ),
  //       );
  //     } else {
  //       context.pop();
  //       DialogUtils.showErrorDialog(context, content: 'Đã có lỗi xảy ra');
  //       emit(state.copyWith(status: BlocStatus.error));
  //     }
  //   } catch (e) {
  //     context.pop();
  //     DialogUtils.showErrorDialog(context, content: e.toString());
  //     emit(state.copyWith(status: BlocStatus.error));
  //   }
  // }
}
