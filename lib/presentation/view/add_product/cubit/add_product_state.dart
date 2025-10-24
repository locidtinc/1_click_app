import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_preview.dart';

part 'add_product_state.freezed.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState({
    @Default(<ProductPreviewEntity>[]) List<ProductPreviewEntity> products,
    @Default(<ProductPreviewEntity>[])
    List<ProductPreviewEntity> productsSelected,
    @Default(10) int limit,
    @Default('') String searchKey,
  }) = _AddProductState;
}
