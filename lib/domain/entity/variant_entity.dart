import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/unit_entity.dart';

part 'variant_entity.freezed.dart';

part 'variant_entity.g.dart';

@freezed
class VariantEntity with _$VariantEntity {
  const VariantEntity._();

  const factory VariantEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String code,
    @Default('') String barCode,
    @Default(0) double priceSell,
    @Default(0) double priceSellDefault,
    @Default(0) double priceImport,
    @Default(true) bool status,
    @Default('') String image,
    @Default(0) int amount,
    @Default(ProductDataEntity()) ProductDataEntity productData,
    @Default(null) PromotionItemEntity? promotion,
    @Default(false) bool variantMykios,
    @Default(0) double? quantityInStock,
    @Default([]) List<UnitEntity> unit,
    //tạo biến
    @Default(0) final num? inputQuantity,
    @Default(0) final num? inputPrice,
    @Default(0) final num? shipmentPrice,
    @JsonKey(name: 'unit_sell') final UnitEntity? unitSell,
  }) = _VariantEntity;

  factory VariantEntity.fromJson(Map<String, dynamic> json) =>
      _$VariantEntityFromJson(json);

  // Map<String, dynamic> toJson() => _$VariantEntityToJson(this);
}

@freezed
class ProductDataEntity with _$ProductDataEntity {
  const factory ProductDataEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default(0) double priceSell,
    @Default('') String code,
    @Default('') String image,
    @Default('') String brand,
    @Default('') String category,
    @Default('') String group,
    @Default('') String codeSystemData,
  }) = _ProductDataEntity;

  factory ProductDataEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductDataEntityFromJson(json);
}

@freezed
class PromotionItemEntity with _$PromotionItemEntity {
  const factory PromotionItemEntity({
    @Default(1) int promotion,
    @Default(0.0) double discount,
    @Default(0) int quantity,
    @Default(1) int typeDiscount,
  }) = _PromotionItemEntity;

  factory PromotionItemEntity.fromJson(Map<String, dynamic> json) =>
      _$PromotionItemEntityFromJson(json);
}
