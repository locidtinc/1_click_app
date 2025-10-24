// To parse this JSON data, do
//
//     final ProductPropertieModel = ProductPropertieModelFromJson(jsonString);

import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

ProductPropertiesModel productPropertiesModelFromJson(String str) => ProductPropertiesModel.fromJson(json.decode(str));

String productPropertiesModelToJson(ProductPropertiesModel data) => json.encode(data.toJson());

class ProductPropertiesModel {
  ProductPropertiesModel({
    this.name,
    this.value,
    this.controller,
    this.isUse,
    this.id,
    FocusNode? focusNode,
  }) : focusNode = focusNode ?? FocusNode();

  final TextEditingController? name;
  List<String>? value;
  final ExpandableController? controller;
  bool? isUse;
  final int? id;
  final FocusNode? focusNode;
  factory ProductPropertiesModel.fromJson(Map<String, dynamic> json) => ProductPropertiesModel(
        name: json['name'],
        value: json['value'] == null ? [] : List<String>.from(json['value']!.map((x) => x)),
        controller: json['controller'],
        isUse: json['isUse'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name!.text,
        'value': value == null ? [] : List<dynamic>.from(value!.map((x) => x)),
        'controller': controller,
        'isUse': isUse,
        'id': id,
      };
}
