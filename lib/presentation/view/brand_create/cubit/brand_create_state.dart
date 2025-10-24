import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_preview.dart';

part 'brand_create_state.freezed.dart';

@freezed
class BrandCreateState with _$BrandCreateState {
  const factory BrandCreateState({
    @Default(null) File? imagePicker,
    @Default('') String title,
    @Default(<ProductPreviewEntity>[])
    List<ProductPreviewEntity> productsSelected,
  }) = _BrandCreateState;
}
