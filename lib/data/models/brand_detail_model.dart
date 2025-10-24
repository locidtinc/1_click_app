import 'package:json_annotation/json_annotation.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/data/models/system_model.dart';

part 'brand_detail_model.g.dart';

@JsonSerializable()
class BrandDetailModel {
  BrandDetailModel(
    this.id,
    this.title,
    this.code,
    this.image,
    this.product,
    this.systemData,
    this.account,
    this.productData,
  );

  int? id;
  String? title;
  String? code;
  String? image;
  List<int>? product;
  @JsonKey(name: 'system_data')
  SystemDataModel? systemData;
  int? account;
  @JsonKey(name: 'product_data')
  List<ProductModel>? productData;

  factory BrandDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BrandDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandDetailModelToJson(this);
}
