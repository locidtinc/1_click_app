import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/product_preview.dart';

part 'group_create_state.freezed.dart';

@freezed
class GroupCreateState with _$GroupCreateState {
  const factory GroupCreateState({
    @Default('') String title,
    @Default(<ProductPreviewEntity>[]) List<ProductPreviewEntity> listProduct,
    @Default(<DropdownMenuItem<int>>[])
    List<DropdownMenuItem<int>> listCategory,
    @Default(null) int? productCategory,
  }) = _GroupCreateState;
}
