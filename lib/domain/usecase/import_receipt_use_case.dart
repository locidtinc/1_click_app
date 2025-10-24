// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/unit_entity.dart';
import 'package:one_click/domain/repository/warehouse_repository.dart';

@injectable
class ImportRecieptUseCase {
  final WarehouseRepository _repository;

  ImportRecieptUseCase(this._repository);
  // Future<BaseResponseModel<List<ReceitExportModel>>> getList(
  //   ImportReceiptInput input,
  // ) async {
  //   final res = await _repository.getListImportReceipt(input);
  //   return res;
  // }

  Future<BaseResponseModel> createReceipt(CreateReceiptInput input) async {
    final res = await _repository.createReceipt(input);
    return res;
  }
}

class ImportReceiptInput {
  final String? search;
  final int page;
  final String? status;
  final int? id;

  ImportReceiptInput({
    required this.search,
    required this.page,
    required this.status,
    required this.id,
  });
}

class CreateReceiptInput {
  ImportReceiptModel? importReceipt;
  List<Shipment>? shipment;
  List<XFile>? images;

  CreateReceiptInput({this.importReceipt, this.shipment, this.images});

  CreateReceiptInput.fromJson(Map<String, dynamic> json) {
    importReceipt = json['import_receipt'] != null
        ? ImportReceiptModel.fromJson(json['import_receipt'])
        : null;
    if (json['shipment'] != null) {
      shipment = <Shipment>[];
      json['shipment'].forEach((v) {
        shipment!.add(Shipment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (importReceipt != null) {
      data['import_receipt'] = importReceipt!.toJson();
    }
    if (shipment != null) {
      data['shipment'] = shipment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImportReceiptModel {
  String? code;
  String? reason;
  int? warehouse;
  num? totalPrice;

  ImportReceiptModel({
    this.code,
    this.reason,
    this.warehouse,
    this.totalPrice,
  });

  ImportReceiptModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    reason = json['reason'];
    warehouse = json['warehouse'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['reason'] = reason;
    data['warehouse'] = warehouse;
    data['total_price'] = totalPrice;
    return data;
  }
}

class Shipment {
  String? code;
  String? startDate;
  String? endDate;
  num? variant;
  num? storageUnit;
  num? inputUnit;
  // Null? typeItems;
  num? importPrice;
  num? totalImportPrice;
  num? inputQuantity;
  num? warehouseImport;
  List<UnitEntity>? unit;
  Shipment({
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.variant,
    required this.storageUnit,
    required this.inputUnit,
    required this.importPrice,
    required this.totalImportPrice,
    required this.inputQuantity,
    required this.warehouseImport,
    required this.unit,
  });

  Shipment.fromJson(Map<String, dynamic> json) {
    // slot = json['slot'];
    code = json['code'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    variant = json['variant'];
    storageUnit = json['storage_unit'];
    inputUnit = json['input_unit'];
    importPrice = json['import_price'];
    totalImportPrice = json['total_import_price'];
    inputQuantity = json['input_quantity'];
    warehouseImport = json['warehouse_import'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['slot'] = slot;
    data['code'] = code;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['variant'] = variant;
    data['storage_unit'] = storageUnit;
    data['input_unit'] = inputUnit;
    data['import_price'] = importPrice;
    data['total_import_price'] = totalImportPrice;
    data['input_quantity'] = inputQuantity;
    data['warehouse_import'] = warehouseImport;
    data['unit'] = unit;
    return data;
  }

  Shipment copyWith({
    String? slot,
    String? code,
    String? startDate,
    String? endDate,
    num? variant,
    num? storageUnit,
    num? inputUnit,
    num? importPrice,
    num? totalImportPrice,
    num? inputQuantity,
    num? warehouseImport,
    List<UnitEntity>? unit,
  }) {
    return Shipment(
      code: code ?? this.code,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      variant: variant ?? this.variant,
      storageUnit: storageUnit ?? this.storageUnit,
      inputUnit: inputUnit ?? this.inputUnit,
      importPrice: importPrice ?? this.importPrice,
      totalImportPrice: totalImportPrice ?? this.totalImportPrice,
      inputQuantity: inputQuantity ?? this.inputQuantity,
      warehouseImport: warehouseImport ?? this.warehouseImport,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'startDate': startDate,
      'endDate': endDate,
      'variant': variant,
      'storageUnit': storageUnit,
      'inputUnit': inputUnit,
      'importPrice': importPrice,
      'totalImportPrice': totalImportPrice,
      'inputQuantity': inputQuantity,
      'warehouseImport': warehouseImport,
      'unit': unit?.map((x) => x.toJson()).toList(),
    };
  }

  factory Shipment.fromMap(Map<String, dynamic> map) {
    return Shipment(
      code: map['code'] != null ? map['code'] as String : null,
      startDate: map['startDate'] != null ? map['startDate'] as String : null,
      endDate: map['endDate'] != null ? map['endDate'] as String : null,
      variant: map['variant'] != null ? map['variant'] as num : null,
      storageUnit:
          map['storageUnit'] != null ? map['storageUnit'] as num : null,
      inputUnit: map['inputUnit'] != null ? map['inputUnit'] as num : null,
      importPrice:
          map['importPrice'] != null ? map['importPrice'] as num : null,
      totalImportPrice: map['totalImportPrice'] != null
          ? map['totalImportPrice'] as num
          : null,
      inputQuantity:
          map['inputQuantity'] != null ? map['inputQuantity'] as num : null,
      warehouseImport:
          map['warehouseImport'] != null ? map['warehouseImport'] as num : null,
      unit: List<UnitEntity>.from(
        (map['unit'] as List<int>).map<UnitEntity>(
          (x) => UnitEntity.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'Shipment( code: $code, startDate: $startDate, endDate: $endDate, variant: $variant, storageUnit: $storageUnit, inputUnit: $inputUnit, importPrice: $importPrice, totalImportPrice: $totalImportPrice, inputQuantity: $inputQuantity, warehouseImport: $warehouseImport, unit: $unit)';
  }

  @override
  bool operator ==(covariant Shipment other) {
    if (identical(this, other)) return true;

    return other.code == code &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.variant == variant &&
        other.storageUnit == storageUnit &&
        other.inputUnit == inputUnit &&
        other.importPrice == importPrice &&
        other.totalImportPrice == totalImportPrice &&
        other.inputQuantity == inputQuantity &&
        other.warehouseImport == warehouseImport &&
        listEquals(other.unit, unit);
  }

  @override
  int get hashCode {
    return code.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        variant.hashCode ^
        storageUnit.hashCode ^
        inputUnit.hashCode ^
        importPrice.hashCode ^
        totalImportPrice.hashCode ^
        inputQuantity.hashCode ^
        warehouseImport.hashCode ^
        unit.hashCode;
  }
}
