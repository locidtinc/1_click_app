import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_brand_preview.freezed.dart';

@freezed
class ProductBrandPreviewEntity with _$ProductBrandPreviewEntity {
  const ProductBrandPreviewEntity._();

  const factory ProductBrandPreviewEntity({
    @Default('') String title,
    @Default('') String code,
    @Default(1) int id,
  }) = _ProductBrandPreviewEntity;
}
