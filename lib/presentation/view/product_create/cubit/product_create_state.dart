import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click/data/models/payload/product/unit_v2_model.dart';
import 'package:one_click/data/models/unit_model.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import '../../../../domain/entity/product_payload.dart';

part 'product_create_state.freezed.dart';

@freezed
class ProductCreateState with _$ProductCreateState {
  const factory ProductCreateState({
    @Default(ProductPayloadEntity()) ProductPayloadEntity productPayloadEntity,
    @Default(true) bool statusProduct,
    @Default(true) bool statusOnline,
    @Default(true) bool statusVariantDefault,
    @Default(<XFile>[]) List<XFile> listImage,
    @Default(<XFile>[]) List<XFile> listVariantImage,
    @Default('') String productName,
    @Default('') String priceSell,
    @Default('') String priceImport,
    @Default('') String barCode,
    @Default('') String productDescreption,
    @Default('0') String amountVariantDefault,
    @Default(null) File? imageVariantDefault,
    @Default([]) List<ProductDetailEntity> listProductScan,
    @Default([]) List<BrandEntity> listGroup,
    @Default([]) List<BrandEntity> listCategory,
    @Default([]) List<BrandEntity> listBrand,
    int? brand,
    int? productgroup,
    int? productcategory,
    @Default([]) List<UnitV2Model> listUnit,
    @Default(0) double vat,
    @Default(0) double importPrice,
    @Default([]) List<UnitV2Model> listDelete,
    // @Default(<ProductBrandPreviewEntity>[]) List<ProductBrandPreviewEntity> listProductBrandPreview,
    // @Default(<DropdownMenuItem>[]) List<DropdownMenuItem> listProductBrandPreviewDropdown,
  }) = _ProductCreateState;
}
