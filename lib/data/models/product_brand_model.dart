// To parse this JSON data, do
//
//     final productBrandModel = productBrandModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/data/models/system_model.dart';

part 'product_brand_model.g.dart';

@JsonSerializable()
class ProductBrandModel {
  final int? id;
  final String? title;
  final String? code;
  final String? image;
  final List<int>? product;
  @JsonKey(name: 'system_data')
  final SystemDataModel? systemData;
  final int? account;
  @JsonKey(name: 'product_data')
  final List<ProductModel>? productData;

  ProductBrandModel({
    this.id,
    this.title,
    this.code,
    this.image,
    this.product,
    this.systemData,
    this.account,
    this.productData,
  });

  ProductBrandModel copyWith({
    int? id,
    String? title,
    String? code,
    String? image,
    List<int>? product,
    SystemDataModel? systemData,
    int? account,
    List<ProductModel>? productData,
  }) =>
      ProductBrandModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        image: image ?? this.image,
        product: product ?? this.product,
        systemData: systemData ?? this.systemData,
        account: account ?? this.account,
        productData: productData ?? this.productData,
      );

  factory ProductBrandModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductBrandModelToJson(this);
}
