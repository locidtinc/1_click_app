import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/payload/product/payload_variant.dart';
import 'package:one_click/domain/entity/option_data.dart';
part 'variant_create_product.freezed.dart';

@freezed

/// [VariantCreateProductEntity] được dùng trong chỉnh sửa sản phẩm
///
/// Mục đích dùng để tạo ra các variant mới khi người dùng thêm giá trị thuộc tính
///
/// Sau quá trình chỉnh sửa thì cuối cùng sẽ mapper [PayloadVariantModel] để tạo request
class VariantCreateProductEntity with _$VariantCreateProductEntity {
  const VariantCreateProductEntity._();

  const factory VariantCreateProductEntity({
    @Default('') String title,
    @Default('') String barcode,
    @Default('0') String quantity,
    @Default('0') String priceSell,
    @Default('0') String priceImport,
    @Default(null) File? image,
    @Default(true) bool isUse,
    @Default([]) List<OptionDataEntity> options,
  }) = _VariantCreateProductEntity;
}
