import 'package:json_annotation/json_annotation.dart';
import 'package:one_click/data/models/option_model.dart';
import 'package:one_click/data/models/product_data_model.dart';
import 'package:one_click/data/models/settings_model.dart';
import 'package:one_click/data/models/unit_model.dart';

import 'promotion_item_model.dart';

part 'variant_model.g.dart';

@JsonSerializable()
class VariantModel {
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
  final String? image;
  final int? product;
  final int? account;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'options_data')
  final List<OptionModel>? optionsData;
  @JsonKey(name: 'quantity_in_stock')
  final double? quantityInStock;
  @JsonKey(name: 'product_data')
  final ProductDataModel? productData;
  @JsonKey(name: 'promotion_item_data')
  final List<PromotionItemModel>? promotionItemData;
  @JsonKey(name: 'promotion_item_system')
  final List<PromotionItemModel>? promotionItemSystem;
  @JsonKey(name: 'promotion_item_me')
  final List<PromotionItemModel>? promotionItemMe;
  @JsonKey(name: 'variant_mykios')
  final bool? variantMykios;
  final List<UnitModel>? unit;
  VariantModel({
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
    this.quantityInStock,
    this.productData,
    this.promotionItemData,
    this.promotionItemSystem,
    this.promotionItemMe,
    this.variantMykios,
    this.unit,
  });

  VariantModel copyWith({
    int? id,
    String? title,
    String? code,
    String? barcode,
    double? priceSell,
    double? priceImport,
    bool? status,
    double? quantity,
    Settings? settings,
    String? image,
    int? product,
    int? account,
    DateTime? createdAt,
    List<OptionModel>? optionsData,
    double? quantityInStock,
    ProductDataModel? productData,
    List<PromotionItemModel>? promotionItemData,
    List<PromotionItemModel>? promotionItemSystem,
    List<PromotionItemModel>? promotionItemMe,
    bool? variantMykios,
    List<UnitModel>? unit,
  }) =>
      VariantModel(
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
        quantityInStock: quantityInStock ?? this.quantityInStock,
        productData: productData ?? this.productData,
        promotionItemData: promotionItemData ?? this.promotionItemData,
        promotionItemSystem: promotionItemSystem ?? this.promotionItemSystem,
        promotionItemMe: promotionItemMe ?? this.promotionItemMe,
        variantMykios: variantMykios ?? this.variantMykios,
        unit: unit ?? this.unit,
      );

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);

  Map<String, dynamic> toJson() => _$VariantModelToJson(this);
}
