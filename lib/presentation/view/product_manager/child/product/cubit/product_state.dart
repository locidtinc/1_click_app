import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/variant_entity.dart';

import '../../../../../../domain/entity/product_preview.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    @Default('') String keySearch,
    @Default(10) int limit,
    @Default(0) int count,
    // @Default(<ProductPreviewEntity>[]) List<ProductPreviewEntity> listProduct,
    @Default(<ProductPreviewEntity>[]) List<ProductPreviewEntity> listProduclt,
    @Default(<VariantEntity>[]) List<VariantEntity> listvariant,
    @Default(VariantEntity()) VariantEntity? variantEntity,
    @Default([
      StatusFilter.all,
      StatusFilter.onlineAndOfline,
      StatusFilter.ofline,
      StatusFilter.hide
    ])
    List<StatusFilter> statusListFilter,
    @Default(StatusFilter.all) StatusFilter statusSelected,
    @Default([SystemFilter.all, SystemFilter.chth, SystemFilter.mykiot])
    List<SystemFilter> systemListFilter,
    @Default(SystemFilter.all) SystemFilter systemSelected,
    @Default([
      InventoryFilter.all,
      InventoryFilter.stocking,
      InventoryFilter.outOfStock
    ])
    List<InventoryFilter> inventoryListFilter,
    @Default(InventoryFilter.all) InventoryFilter inventorySelected,
  }) = _ProductState;
}

enum StatusFilter {
  all('Tất cả', null),
  onlineAndOfline('Đang bán trực tiếp và online', 'true'),
  ofline('Chỉ bán trực tiếp', 'false'),
  hide('Đã ẩn', null);

  const StatusFilter(this.title, this.code);

  final String title;
  final String? code;
}

enum SystemFilter {
  all('Tất cả', null),
  chth('Nội bộ', 'CHTH'),
  mykiot('MyKios', 'ADMIN');

  const SystemFilter(this.title, this.code);

  final String title;
  final String? code;
}

enum InventoryFilter {
  all('Tất cả'),
  stocking('Còn hàng'),
  outOfStock('Hết hàng');

  const InventoryFilter(this.title);

  final String title;
}
