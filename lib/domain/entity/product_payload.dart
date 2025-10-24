import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_payload.freezed.dart';

part 'product_payload.g.dart';

@freezed
class ProductPayloadEntity with _$ProductPayloadEntity {
  const ProductPayloadEntity._();

  const factory ProductPayloadEntity({
    @Default(ProductInfoPayloadEntity()) ProductInfoPayloadEntity product,
    @Default(<VariantPayloadEntity>[]) List<VariantPayloadEntity> variant,
    int? brand,
    @JsonKey(name: 'productgroup') int? productGroup,
    @JsonKey(name: 'productcategory') int? productCategory,
    @JsonKey(name: 'status_synchronized_sell', includeToJson: false) @Default(true) bool statusSynchronizedSell,
    @JsonKey(name: 'status_synchronized_import', includeToJson: false) @Default(true) bool statusSynchronizedImport,
    @JsonKey(name: 'list_media_variant') @Default([]) List<bool> listMediaVariant,
    @Default(<UntitPayloadEntity>[]) List<UntitPayloadEntity> unit,
  }) = _ProductPayloadEntity;

  factory ProductPayloadEntity.fromJson(Map<String, dynamic> json) => _$ProductPayloadEntityFromJson(json);
}

@freezed
class ProductInfoPayloadEntity with _$ProductInfoPayloadEntity {
  const ProductInfoPayloadEntity._();

  const factory ProductInfoPayloadEntity({
    @Default('') String title,
    @Default('') String barcode,
    @JsonKey(name: 'price_sell') @Default(0) int priceSell,
    @JsonKey(name: 'price_import') @Default(0) int priceImport,
    @Default('') String description,
    @JsonKey(name: 'status_product') @Default(true) bool statusProduct,
    @JsonKey(name: 'status_online') @Default(true) bool statusOnline,
    @JsonKey(name: 'option') @Default(null) String? option,
  }) = _ProductInfoPayloadEntity;

  factory ProductInfoPayloadEntity.fromJson(Map<String, dynamic> json) => _$ProductInfoPayloadEntityFromJson(json);
}

@freezed
class VariantPayloadEntity with _$VariantPayloadEntity {
  const VariantPayloadEntity._();

  const factory VariantPayloadEntity({
    @Default('') String title,
    @Default('') String barcode,
    @Default(true) bool status,
    @JsonKey(name: 'price_sell') @Default(0) int priceSell,
    @JsonKey(name: 'price_import') @Default(0) int priceImport,
    @Default(0) int quantity,
    @Default(<OptionPayloadEntity>[]) List<OptionPayloadEntity> options,
  }) = _VariantPayloadEntity;

  factory VariantPayloadEntity.fromJson(Map<String, dynamic> json) => _$VariantPayloadEntityFromJson(json);
}

@freezed
class OptionPayloadEntity with _$OptionPayloadEntity {
  const OptionPayloadEntity._();

  const factory OptionPayloadEntity({
    @Default('') String title,
    @Default('') String values,
  }) = _OptionPayloadEntity;

  factory OptionPayloadEntity.fromJson(Map<String, dynamic> json) => _$OptionPayloadEntityFromJson(json);
}

@freezed
class UntitPayloadEntity with _$UntitPayloadEntity {
  const UntitPayloadEntity._();
  const factory UntitPayloadEntity({
    @Default('') String title,
    @Default(0) int level,
    @JsonKey(name: 'conversion_value') @Default(0) int conversionValue,
    @JsonKey(name: 'storage_unit') @Default(false) bool storageUnit,
    @JsonKey(name: 'sell_unit') @Default(false) bool sellUnit,
  }) = _UntitPayloadEntity;

  factory UntitPayloadEntity.fromJson(Map<String, dynamic> json) => _$UntitPayloadEntityFromJson(json);
}
