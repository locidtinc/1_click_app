import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_preview.dart';

part 'brand_detail_entity.freezed.dart';

@freezed
class BrandDetailEntity with _$BrandDetailEntity {
  const factory BrandDetailEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default(false) bool isSystem,
    @Default(null) String? image,
    @Default(0) int account,
    @Default(false) bool isAdminCreated,
    @Default(<ProductPreviewEntity>[]) List<ProductPreviewEntity> products,
  }) = _BrandDetailEntity;
}
