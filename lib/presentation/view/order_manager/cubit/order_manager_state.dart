import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/product_tab.dart';
import '../child/all_order/all_order_view.dart';

part 'order_manager_state.freezed.dart';

@freezed
class OrderManagerState with _$OrderManagerState {
  const factory OrderManagerState({
    @Default([
      ProductTab(
        title: 'Bán trực tiếp',
        page: AllOrderView(
          isOnline: false,
        ),
      ),
      ProductTab(
        title: 'Đơn bán Online',
        page: AllOrderView(
          isOnline: true,
        ),
      ),
      ProductTab(
        title: 'Tất cả đơn',
        page: AllOrderView(
          isOnline: null,
        ),
      ),
    ])
    List<ProductTab> listTab,
    @Default(
      ProductTab(
        title: 'Danh mục',
        page: SizedBox(),
      ),
    )
    ProductTab tabChoose,
  }) = _OrderManagerState;
}
