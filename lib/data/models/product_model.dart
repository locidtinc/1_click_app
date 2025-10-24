import 'package:json_annotation/json_annotation.dart';
import 'package:one_click/data/models/data_value_model.dart';
import 'package:one_click/data/models/media_model.dart';
import 'package:one_click/data/models/property_product_model.dart';
import 'package:one_click/data/models/settings_model.dart';
import 'package:one_click/data/models/system_model.dart';
import 'package:one_click/data/models/variant_model.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int? id;
  final String? title;
  final String? code;
  final String? barcode;
  @JsonKey(name: 'price_sell')
  final double? priceSell;
  final List<int>? media;
  @JsonKey(name: 'price_import')
  final double? priceImport;
  @JsonKey(name: 'status_product')
  final bool? statusProduct;
  @JsonKey(name: 'status_online')
  final bool? statusOnline;
  final String? description;
  // final List<Settings>? settings;
  final int? system;
  @JsonKey(name: 'media_data')
  final List<MediaModel>? mediaData;
  @JsonKey(name: 'variant_data')
  final List<VariantModel>? variantData;
  @JsonKey(name: 'system_data')
  final SystemDataModel? systemData;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'brand_data')
  final List<DataValueModel>? brandData;
  @JsonKey(name: 'productcategory_data')
  final List<DataValueModel>? productCategory;
  @JsonKey(name: 'productgroup_data')
  final List<DataValueModel>? productGroup;

  ProductModel({
    this.id,
    this.title,
    this.code,
    this.barcode,
    this.priceSell,
    this.media,
    this.priceImport,
    this.statusProduct,
    this.statusOnline,
    this.description,
    // this.settings,
    this.system,
    this.mediaData,
    this.variantData,
    this.systemData,
    this.createdAt,
    this.brandData,
    this.productCategory,
    this.productGroup,
  });

  ProductModel copyWith({
    int? id,
    String? title,
    String? code,
    String? barcode,
    double? priceSell,
    List<int>? media,
    double? priceImport,
    bool? statusProduct,
    bool? statusOnline,
    String? description,
    Settings? settings,
    int? system,
    List<MediaModel>? mediaData,
    List<VariantModel>? variantData,
    SystemDataModel? systemData,
    DateTime? createdAt,
  }) =>
      ProductModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        barcode: barcode ?? this.barcode,
        priceSell: priceSell ?? this.priceSell,
        media: media ?? this.media,
        priceImport: priceImport ?? this.priceImport,
        statusProduct: statusProduct ?? this.statusProduct,
        statusOnline: statusOnline ?? this.statusOnline,
        description: description ?? this.description,
        // settings: settings ?? this.settings,
        system: system ?? this.system,
        mediaData: mediaData ?? this.mediaData,
        variantData: variantData ?? this.variantData,
        systemData: systemData ?? this.systemData,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  List<ProductProperty> properties() {
    final List<ProductProperty> listProperties = [];
    List<ProductProperty> listPropertiesResult = [];
    if (variantData == null || (variantData != null && variantData!.isEmpty)) {
      return listProperties;
    }
    for (final variant in variantData!) {
      for (int i = 0; i < variant.optionsData!.length; i++) {
        listProperties.add(
          ProductProperty(
            title: variant.optionsData![i].title!,
            childProperties: [variant.optionsData![i].values!],
          ),
        );
      }
    }
    listPropertiesResult = compressData(listProperties);
    return listPropertiesResult;
  }

  List<ProductProperty> compressData(List<ProductProperty> list) {
    final map = <String, ProductProperty>{};

    for (final data in list) {
      map.update(
        data.title,
        (oldData) => ProductProperty(
          title: data.title,
          childProperties: [
            ...data.childProperties,
            ...oldData.childProperties
          ],
        ),
        ifAbsent: () => data,
      );
    }

    return map.values.toList();
  }
}
