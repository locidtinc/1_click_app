import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_edit_properties.dart';

import '../../../../domain/entity/product_detail_entity.dart';
import '../../../../domain/entity/variant_create_product.dart';

part 'product_edit_state.freezed.dart';

@freezed
class ProductEditState with _$ProductEditState {
  const factory ProductEditState({
    @Default(null) ProductDetailEntity? product,
    @Default([]) List<File> imagesPicker,
    @Default([]) List<ProductEditPropertiesEntity> listProperties,
    @Default([]) List<VariantCreateProductEntity> listNewVariant,
    @Default([]) List<String> listTitleNewVariant,
    @Default([]) List<String> listTitleAllVariant,
    @Default([]) List<String> listTitleOldVariant,
    @Default([]) List<DropdownMenuItem<int>> listBrandDropdonw,
    @Default([]) List<DropdownMenuItem<int>> listCategoryDropdonw,
    @Default([]) List<DropdownMenuItem<int>> listGroupDropdonw,
    @Default(true) bool statusSynchronizedSell,
    @Default(true) bool statusSynchronizedImport,
  }) = _ProductEditState;
}
