// To parse this JSON data, do
//
//     final payloadVariantModel = payloadVariantModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

PayloadVariantModel payloadVariantModelFromJson(String str) =>
    PayloadVariantModel.fromJson(json.decode(str));

String payloadVariantModelToJson(PayloadVariantModel data) =>
    json.encode(data.toJson());

class PayloadVariantModel {
  String? title;
  TextEditingController? barcode;
  List<Option>? options;
  final FocusNode? focusNode;
  final TextEditingController? quantity;
  final TextEditingController? priceSell;
  final TextEditingController? priceImport;
  File? image;
  bool isUse;
  ExpandableController? controller = ExpandableController();
  TextEditingController? nameVariantController;

  PayloadVariantModel({
    this.title,
    this.barcode,
    this.options,
    this.quantity,
    this.priceSell,
    this.priceImport,
    this.controller,
    this.image,
    this.nameVariantController,
    FocusNode? focusNode,
    this.isUse = true,
  }) : focusNode = focusNode ?? FocusNode();

  PayloadVariantModel copyWith({
    String? title,
    TextEditingController? barcode,
    List<Option>? options,
    TextEditingController? quantity,
    TextEditingController? priceSell,
    TextEditingController? priceImport,
    TextEditingController? nameVariantController,
    FocusNode? focusNode,
    File? image,
  }) =>
      PayloadVariantModel(
        title: title ?? this.title,
        barcode: barcode ?? this.barcode,
        options: options ?? this.options,
        quantity: quantity ?? this.quantity,
        priceSell: priceSell ?? this.priceSell,
        priceImport: priceImport ?? this.priceImport,
        focusNode: focusNode ?? this.focusNode,
        image: image ?? this.image,
        nameVariantController:
            nameVariantController ?? this.nameVariantController,
      );

  factory PayloadVariantModel.fromJson(Map<String, dynamic> json) =>
      PayloadVariantModel(
        title: json['title'],
        barcode: json['barcode'],
        options: json['options'] == null
            ? []
            : List<Option>.from(
                json['options']!.map((x) => Option.fromJson(x)),
              ),
        quantity: json['quantity'],
        priceSell: json['price_sell'],
        priceImport: json['price_import'],
        isUse: true,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'barcode': barcode,
        'options': options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        'quantity': quantity,
        'price_sell': priceSell,
        'price_import': priceImport,
      };
}

class Option {
  final String? title;
  final String? values;

  Option({
    this.title,
    this.values,
  });

  Option copyWith({
    String? title,
    String? values,
  }) =>
      Option(
        title: title ?? this.title,
        values: values ?? this.values,
      );

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        title: json['title'],
        values: json['values'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'values': values,
      };
}

extension PayloadVariantModelDispose on PayloadVariantModel {
  void dispose() {
    barcode?.dispose();
    quantity?.dispose();
    priceSell?.dispose();
    priceImport?.dispose();
    nameVariantController?.dispose();
    controller?.dispose();
    focusNode?.dispose();
  }
}
