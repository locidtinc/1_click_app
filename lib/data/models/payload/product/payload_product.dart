// To parse this JSON data, do
//
//     final payloadProductModel = payloadProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

PayloadProductModel payloadProductModelFromJson(String str) =>
    PayloadProductModel.fromJson(json.decode(str));

String payloadProductModelToJson(PayloadProductModel data) =>
    json.encode(data.toJson());

class PayloadProductModel {
  final TextEditingController? title;
  final TextEditingController? barcode;
  final TextEditingController? priceSell;
  final TextEditingController? priceImport;
  final bool? statusProduct;
  final bool? statusOnline;
  final TextEditingController? description;
  final ExpandableController? expandableController;

  PayloadProductModel({
    this.title,
    this.barcode,
    this.priceSell,
    this.priceImport,
    this.statusProduct,
    this.statusOnline,
    this.description,
    this.expandableController,
  });

  PayloadProductModel copyWith({
    TextEditingController? title,
    TextEditingController? barcode,
    TextEditingController? priceSell,
    TextEditingController? priceImport,
    bool? statusProduct,
    bool? statusOnline,
    TextEditingController? description,
  }) =>
      PayloadProductModel(
        title: title ?? this.title,
        barcode: barcode ?? this.barcode,
        priceSell: priceSell ?? this.priceSell,
        priceImport: priceImport ?? this.priceImport,
        statusProduct: statusProduct ?? this.statusProduct,
        statusOnline: statusOnline ?? this.statusOnline,
        description: description ?? this.description,
      );

  factory PayloadProductModel.fromJson(Map<String, dynamic> json) =>
      PayloadProductModel(
        title: json['title'],
        barcode: json['barcode'],
        priceSell: json['price_sell'],
        priceImport: json['price_import'],
        statusProduct: json['status_product'],
        statusOnline: json['status_online'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'title': title?.text,
        'barcode': barcode?.text,
        'price_sell': priceSell?.text,
        'price_import': priceImport?.text,
        'status_product': statusProduct,
        'status_online': statusOnline,
        'description': description?.text,
      };
}
