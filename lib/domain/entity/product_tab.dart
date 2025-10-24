import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_tab.freezed.dart';

@freezed
class ProductTab with _$ProductTab {
  const ProductTab._();

  const factory ProductTab({
    @Default('') String title,
    @Default(SizedBox()) Widget page,
  }) = _ProductTab;
}
