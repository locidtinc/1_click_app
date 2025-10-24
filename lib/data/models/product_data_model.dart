import 'package:json_annotation/json_annotation.dart';
import 'package:one_click/data/models/data_value_model.dart';
import 'package:one_click/data/models/media_model.dart';

part 'product_data_model.g.dart';

@JsonSerializable()
class ProductDataModel {
  ProductDataModel(
    this.id,
    this.title,
    this.code,
    this.image,
    this.brandData,
    this.productCategory,
    this.productGroup,
    this.priceSell,
  );

  int? id;
  String? title;
  String? code;
  @JsonKey(name: 'media_data')
  List<MediaModel>? image;
  @JsonKey(name: 'brand_data')
  final List<DataValueModel>? brandData;
  @JsonKey(name: 'productcategory_data')
  final List<DataValueModel>? productCategory;
  @JsonKey(name: 'productgroup_data')
  final List<DataValueModel>? productGroup;
  @JsonKey(name: 'price_sell')
  final double? priceSell;
  factory ProductDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataModelToJson(this);
}
