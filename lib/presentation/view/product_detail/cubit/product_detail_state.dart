import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';

part 'product_detail_state.freezed.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    @Default(ProductDetailEntity()) ProductDetailEntity? productDetailEntity,
    @Default(0) int selectedImage,
  }) = _ProductDetailState;
}
