// To parse this JSON data, do
//
//     final orderItemModel = orderItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_model.dart';

part 'order_item_model.g.dart';

OrderItemModel orderItemModelFromJson(String str) =>
    OrderItemModel.fromJson(json.decode(str));

String orderItemModelToJson(OrderItemModel data) => json.encode(data.toJson());

@JsonSerializable()
class OrderItemModel {
  final int? id;
  final double? quantity;
  final double? price;
  final double? discount;
  final int? variant;
  @JsonKey(name: 'variant_data')
  final VariantData? variantData;
  final DateTime? createdAt;
  
  OrderItemModel({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.variant,
    this.variantData,
    this.createdAt,
  });

  OrderItemModel copyWith({
    int? id,
    double? quantity,
    double? price,
    double? discount,
    int? variant,
    VariantData? variantData,
    DateTime? createdAt,
  }) =>
      OrderItemModel(
        id: id ?? this.id,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        variant: variant ?? this.variant,
        variantData: variantData ?? this.variantData,
        createdAt: createdAt ?? this.createdAt,
      );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

@JsonSerializable()
class VariantData {
  final int? id;
  final String? title;
  final String? code;
  final String? barcode;
  @JsonKey(name: 'price_sell')
  final double? priceSell;
  @JsonKey(name: 'price_import')
  final double? priceImport;
  final bool? status;
  final double? quantity;
  final Settings? settings;
  final dynamic image;
  final int? product;
  final int? account;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'options_data')
  final List<OptionsDatum>? optionsData;
  @JsonKey(name: 'product__title')
  final String? productTitle;
  @JsonKey(name: 'quantity_in_stock')
  final dynamic quantityInStock;
  @JsonKey(name: 'unit_sell')
  final String? unitSell;

  VariantData( {
    this.id,
    this.title,
    this.code,
    this.barcode,
    this.priceSell,
    this.priceImport,
    this.status,
    this.quantity,
    this.settings,
    this.image,
    this.product,
    this.account,
    this.createdAt,
    this.optionsData,
    this.productTitle,
    this.quantityInStock,
    this.unitSell
  });

  VariantData copyWith({
    int? id,
    String? title,
    String? code,
    String? barcode,
    double? priceSell,
    double? priceImport,
    bool? status,
    double? quantity,
    Settings? settings,
    dynamic image,
    int? product,
    int? account,
    DateTime? createdAt,
    List<OptionsDatum>? optionsData,
    String? productTitle,
    dynamic quantityInStock,
    String? unitSell
  }) =>
      VariantData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        barcode: barcode ?? this.barcode,
        priceSell: priceSell ?? this.priceSell,
        priceImport: priceImport ?? this.priceImport,
        status: status ?? this.status,
        quantity: quantity ?? this.quantity,
        settings: settings ?? this.settings,
        image: image ?? this.image,
        product: product ?? this.product,
        account: account ?? this.account,
        createdAt: createdAt ?? this.createdAt,
        optionsData: optionsData ?? this.optionsData,
        productTitle: productTitle ?? this.productTitle,
        quantityInStock: quantityInStock ?? this.quantityInStock,
        unitSell: unitSell??this.unitSell,
      );

  factory VariantData.fromJson(Map<String, dynamic> json) =>
      _$VariantDataFromJson(json);

  Map<String, dynamic> toJson() => _$VariantDataToJson(this);
}

@JsonSerializable()
class OptionsDatum {
  final int? id;
  final String? title;
  final dynamic code;
  final String? values;
  final bool? status;

  OptionsDatum({
    this.id,
    this.title,
    this.code,
    this.values,
    this.status,
  });

  OptionsDatum copyWith({
    int? id,
    String? title,
    dynamic code,
    String? values,
    bool? status,
  }) =>
      OptionsDatum(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        values: values ?? this.values,
        status: status ?? this.status,
      );

  factory OptionsDatum.fromJson(Map<String, dynamic> json) =>
      _$OptionsDatumFromJson(json);

  Map<String, dynamic> toJson() => _$OptionsDatumToJson(this);
}
