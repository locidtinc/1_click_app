import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_tab.dart';
import 'package:one_click/presentation/view/product_manager/child/category/category_page.dart';
import 'package:one_click/presentation/view/product_manager/child/product/product_page.dart';

part 'product_manager_state.freezed.dart';

@freezed
class ProductManagerState with _$ProductManagerState {
  const factory ProductManagerState({
    @Default(
      ProductTab(
        title: 'Danh mục',
        page: SizedBox(),
      ),
    )
    ProductTab tabChoose,
  }) = _ProductManagerState;
}
