import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click/data/models/receipt_import_detail_model.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';

class CreateWarehouseReceiptState extends Equatable {
  final List<WarehouseModel> listWareHouse;
  final List<ReceiptImportDetailModel> listShipment;
  // final List<UserDataModel> listUser;
  final List<ProductV3Model> listPrdsAI;
  final List<XFile> images;
  final WarehouseModel? warehouse;
  // final UserDataModel? userCheck;
  final String? code;
  final String? reason;
  final String? provider;
  final num? totalPrice;
  final String? startDate;
  final bool hasUpdate;
  final BlocStatus status;
  final String? msg;
  final int? limit;

  const CreateWarehouseReceiptState({
    this.limit = 10,
    this.listWareHouse = const [],
    this.listShipment = const [],
    // this.listUser = const [],
    this.listPrdsAI = const [],
    this.images = const [],
    this.warehouse,
    // this.userCheck,
    this.code,
    this.reason,
    this.provider,
    this.totalPrice = 0,
    this.startDate,
    this.hasUpdate = false,
    this.status = BlocStatus.initial,
    this.msg,
  });

  CreateWarehouseReceiptState copyWith({
    List<WarehouseModel>? listWareHouse,
    List<ReceiptImportDetailModel>? listShipment,
    // List<UserDataModel>? listUser,
    List<ProductV3Model>? listPrdsAI,
    List<XFile>? images,
    WarehouseModel? warehouse,
    // UserDataModel? userCheck,
    String? code,
    String? reason,
    String? provider,
    num? totalPrice,
    String? startDate,
    bool? hasUpdate,
    BlocStatus? status,
    String? msg,
    int? limit,
  }) {
    return CreateWarehouseReceiptState(
      listWareHouse: listWareHouse ?? this.listWareHouse,
      listShipment: listShipment ?? this.listShipment,
      // listUser: listUser ?? this.listUser,
      listPrdsAI: listPrdsAI ?? this.listPrdsAI,
      images: images ?? this.images,
      warehouse: warehouse ?? this.warehouse,
      // userCheck: userCheck ?? this.userCheck,
      code: code ?? this.code,
      reason: reason ?? this.reason,
      provider: provider ?? this.provider,
      totalPrice: totalPrice ?? this.totalPrice,
      startDate: startDate ?? this.startDate,
      hasUpdate: hasUpdate ?? this.hasUpdate,
      status: status ?? this.status,
      msg: msg ?? this.msg, limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
        listWareHouse,
        listShipment,
        // listUser,
        listPrdsAI,
        images,
        warehouse,
        // userCheck,
        code,
        reason,
        provider,
        totalPrice,
        startDate,
        hasUpdate,
        status,
        msg,
      ];
}
