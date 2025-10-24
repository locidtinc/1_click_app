// To parse this JSON data, do
//
//     final productGroupModel = productGroupModelFromJson(jsonString);

// import 'dart:convert';

import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';

// ProductGroupModel productGroupModelFromJson(String str) =>
//     ProductGroupModel.fromJson(json.decode(str));

// String productGroupModelToJson(ProductGroupModel data) =>
//     json.encode(data.toJson());

class ProductGroupModel {
  final int? id;
  final String? title;
  final String? code;
  final int? account;
  final int? system;
  final List<int>? product;
  final List<ProductModel>? productData;
  final List<TypeData>? category;
  final int? productQuantity;
  final DateTime? createdAt;

  ProductGroupModel({
    this.id,
    this.title,
    this.code,
    this.account,
    this.system,
    this.product,
    this.productData,
    this.category,
    this.productQuantity,
    this.createdAt,
  });

  ProductGroupModel copyWith({
    int? id,
    String? title,
    String? code,
    int? account,
    int? system,
    List<int>? product,
    List<ProductModel>? productData,
    List<TypeData>? category,
    int? productQuantity,
    DateTime? createdAt,
  }) =>
      ProductGroupModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        account: account ?? this.account,
        system: system ?? this.system,
        product: product ?? this.product,
        productData: productData ?? this.productData,
        category: category ?? this.category,
        productQuantity: productQuantity ?? this.productQuantity,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ProductGroupModel.fromJson(Map<String, dynamic> json) =>
      ProductGroupModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        account: json['account'],
        system: json['system'],
        product: json['product'] == null
            ? []
            : List<int>.from(json['product']!.map((x) => x)),
        productData: json['product_data'] == null
            ? []
            : List<ProductModel>.from(
                json['product_data']!.map((x) => ProductModel.fromJson(x)),
              ),
        category: json['category_data'] == null
            ? []
            : List<TypeData>.from(
                json['category_data']!.map((x) => TypeData.fromJson(x)),
              ),
        productQuantity: json['product_quantity'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'account': account,
        'system': system,
        'product':
            product == null ? [] : List<dynamic>.from(product!.map((x) => x)),
        'product_data': productData == null
            ? []
            : List<dynamic>.from(productData!.map((x) => x.toJson())),
        'category_data': category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
        'product_quantity': productQuantity,
        'created_at': createdAt?.toIso8601String(),
      };
}
