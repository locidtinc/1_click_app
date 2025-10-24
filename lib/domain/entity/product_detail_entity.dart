import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/property_product_model.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import 'product_payload.dart';

part 'product_detail_entity.freezed.dart';

part 'product_detail_entity.g.dart';

@freezed
class ProductDetailEntity with _$ProductDetailEntity {
  const factory ProductDetailEntity({
    @Default('') String title,
    @Default('') String code,
    @Default(null) int? id,
    @Default('') String barcode,
    @Default(0) double priceSell,
    @Default(0) double priceImport,
    @Default([]) List<String> images,
    @Default([]) List<MediaDataEntity> mediaData,
    @Default(null) List<Settings>? settings,
    @Default('') String description,
    @Default('') String codeSystemData,
    @Default('') String brand,
    @Default(null) int? brandId,
    @Default('') String productCategory,
    @Default(null) int? categoryId,
    @Default('') String productGroup,
    @Default(null) int? groupId,
    @Default(true) bool statusProduct,
    @Default(true) bool statusOnline,
    @Default(false) bool isAdminCreated,
    @Default(<VariantResponseEntity>[]) List<VariantResponseEntity> variant,
    @Default(<ProductProperty>[]) List<ProductProperty> properties,
  }) = _ProductDetailEntity;

  factory ProductDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailEntityFromJson(json);
}

@freezed
class VariantResponseEntity with _$VariantResponseEntity {
  const VariantResponseEntity._();

  const factory VariantResponseEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String code,
    @Default(0) double priceSell,
    @Default(0) double priceImport,
    @Default(true) bool status,
    @Default(0) int quantity,
    @Default('') String image,
    @Default(false) bool variant_mykios,
    @Default(<OptionPayloadEntity>[]) List<OptionPayloadEntity> options,
  }) = _VariantResponseEntity;

  factory VariantResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$VariantResponseEntityFromJson(json);
}

@freezed
class MediaDataEntity with _$MediaDataEntity {
  const MediaDataEntity._();

  const factory MediaDataEntity({
    @Required() int? id,
    @Default(PrefKeys.imgProductDefault) String image,
    @Default('') String alt,
  }) = _MediaDataEntity;

  factory MediaDataEntity.fromJson(Map<String, dynamic> json) =>
      _$MediaDataEntityFromJson(json);
}

@freezed
class Settings with _$Settings {
  const Settings._();

  const factory Settings({
    @Default(null) String? title,
    @Default(null) List<String>? value,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}
