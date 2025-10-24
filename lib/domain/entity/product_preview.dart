import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_preview.freezed.dart';

@freezed
class ProductPreviewEntity with _$ProductPreviewEntity {
  const ProductPreviewEntity._();

  const factory ProductPreviewEntity({
    @Default(0) int id,
    @Default('') String imageUrl,
    @Default('') String barcode,
    @Default('') String productName,
    @Default('') String productCode,
    @Default(0) int productPrice,
    @Default(0) int priceImport,
    @Default(true) bool isAdminCreated,
    @Default(null) String? brandName,
    @Default(null) int? brandId,
    @Default(null) String? groupName,
    @Default(null) int? groupId,
  }) = _ProductPreviewEntity;
}
